//
//  Scene1ActionLayer.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Scene1ActionLayer.h"
#import "Cupid.h"
#import "Arrow.h"
#import "Monster.h"
#import "RotatingMonster.h"
#import "MonsterBeam.h"

@interface Scene1ActionLayer (Private)

- (void)spawnCupid;
- (void)setupArrays;
- (void)updateMonsters:(ccTime)deltaTime;
- (void)updateRotatingMonsters:(ccTime)deltaTime;
- (void)updateCollisions:(ccTime)deltaTime;
- (void)createCloud;
- (void)resetCloudWithNode:(id)node;
- (void)loadGameOverLayer;

@end

@implementation Scene1ActionLayer
{
	CCSpriteBatchNode *sceneSpriteBatchNode_;
	double nextMonsterSpawn_;
	double nextRotatingMonsterSpawn_;
	GameObjectArray *monsterArray_;
	GameObjectArray *rotatingMonsterArray_;
	GameObjectArray *arrowArray_;
	GameObjectArray *beamArray_;
	BOOL gameOver_;
}

- (id)init
{
	self = [super init];
	if (self) {
		gameOver_ = NO;
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet-iPhone.plist"];
		sceneSpriteBatchNode_ = [CCSpriteBatchNode batchNodeWithFile:@"spritesheet-iPhone.png"];
		
        [self addChild:sceneSpriteBatchNode_ z:5];
		
		for (int x = 0; x < 15; x++) {
            [self createCloud];
        }
		
		[self spawnCupid];
		[self scheduleUpdate];
		[self setupArrays];
	}
	return self;
}

- (void)dealloc
{
	[monsterArray_ release];
	[rotatingMonsterArray_ release];
	[arrowArray_ release];
	[beamArray_ release];
	[super dealloc];
}

- (void)update:(ccTime)deltaTime
{
	if (gameOver_) return;
	
	CCArray *listOfGameObjects = [sceneSpriteBatchNode_ children];
	
	Cupid *cupid = (Cupid *)[sceneSpriteBatchNode_ getChildByTag:kCupidSpriteTagValue];
	[cupid updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
	
	if (cupid.characterState == kStateDead && [cupid numberOfRunningActions] == 0) {
		gameOver_ = YES;
		[self loadGameOverLayer];
		return;
	}
	
	[self updateMonsters:deltaTime];
	[self updateRotatingMonsters:deltaTime];
	[self updateCollisions:deltaTime];
}

#pragma mark - Custom Methods

- (void)connectControlsWithFlyButton:(SneakyButton *)flyButton andAttackButton:(SneakyButton *)attackButton
{
	Cupid *cupid = (Cupid *)[sceneSpriteBatchNode_ getChildByTag:kCupidSpriteTagValue];
	cupid.flyButton = flyButton;
	cupid.attackButton = attackButton;
}

#pragma mark - Private Methods

- (void)spawnCupid
{
	Cupid *cupid = [[Cupid alloc] initWithSpriteFrameName:@"cupid_1.png"];
	cupid.delegate = self;
	cupid.position = ccp(100.0f, 150.0f);
	[sceneSpriteBatchNode_ addChild:cupid z:kCupidSpriteZValue tag:kCupidSpriteTagValue];
	[cupid release];
}

- (void)setupArrays
{
	monsterArray_ = [[GameObjectArray alloc] initWithCapacity:30
												   className:NSStringFromClass([Monster class])
											  spriteFrameName:@"monster_grey_1.png"
													batchNode:sceneSpriteBatchNode_];
	
	rotatingMonsterArray_ = [[GameObjectArray alloc] initWithCapacity:10
													  className:NSStringFromClass([RotatingMonster class])
													  spriteFrameName:@"monster_blue.png"
															batchNode:sceneSpriteBatchNode_];

	arrowArray_ = [[GameObjectArray alloc] initWithCapacity:20
												 className:NSStringFromClass([Arrow class])
											spriteFrameName:@"arrow_1.png"
												  batchNode:sceneSpriteBatchNode_];
	
	beamArray_ = [[GameObjectArray alloc] initWithCapacity:20
										   className:NSStringFromClass([MonsterBeam class])
										   spriteFrameName:@"beam_1.png"
												 batchNode:sceneSpriteBatchNode_];
}

- (void)createCloud
{
	int cloudToDraw = random() % 3 + 1; // Random number between 1 and 3
	NSString *cloudFrameName = [NSString stringWithFormat:@"bg_cloud_%d.png", cloudToDraw];
	GameObject *cloudSprite = [GameObject spriteWithSpriteFrameName:cloudFrameName];
	[sceneSpriteBatchNode_ addChild:cloudSprite];
	[self resetCloudWithNode:cloudSprite];	
}

- (void)resetCloudWithNode:(id)node
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	CCNode *cloud = (CCNode *)node;
	float xOffset = [cloud boundingBox].size.width / 2.0f;
	
	int xPosition = screenSize.width + 1 + xOffset;
	int yPosition = random() % (int)screenSize.height;
	
	cloud.position = ccp(xPosition, yPosition);
	
	int moveDuration = random() % kMaxCloudMoveDuration;
	
	if (moveDuration < kMinCloudMoveDuration) {
		moveDuration = kMinCloudMoveDuration;
	}
	
	float offScreenXPosition = (xOffset * -1) - 1;
	
	id moveAction = [CCMoveTo actionWithDuration:moveDuration
										position:ccp(offScreenXPosition, cloud.position.y)];
	id resetAction = [CCCallFuncN actionWithTarget:self selector:@selector(resetCloudWithNode:)];
	id sequenceAction = [CCSequence actions:moveAction, resetAction, nil];
	[cloud runAction:sequenceAction];
	int newZOrder = -1 * (kMaxCloudMoveDuration - moveDuration);
	[sceneSpriteBatchNode_ reorderChild:cloud z:newZOrder];
}

- (void)updateMonsters:(ccTime)deltaTime
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Is it time to spawn monster?
    double curTime = CACurrentMediaTime();
    if (curTime > nextMonsterSpawn_) {
        float spawnSecsLow = 0.2f;
        float spawnSecsHigh = 1.0f;
        float randSecs = randomValueBetween(spawnSecsLow, spawnSecsHigh);
        nextMonsterSpawn_ = randSecs + curTime;
		
        // Create a new monster object
        GameCharacter *monster = (GameCharacter *)[monsterArray_ nextObject];
		monster.characterHealth = 1;
		
		float randYLow = 0.0 + (monster.contentSize.height / 2.0);
		float randYHigh = screenSize.height - (monster.contentSize.height / 2.0);
		float randY = randomValueBetween(randYLow, randYHigh);
		monster.position = ccp(screenSize.width + monster.contentSize.width / 2.0f, randY);
		
        [monster changeState:kStateSpawning];
		[monster changeState:kStateTraveling];
    }
}

- (void)updateRotatingMonsters:(ccTime)deltaTime
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Is it time to spawn monster?
    double curTime = CACurrentMediaTime();
    if (curTime > nextRotatingMonsterSpawn_) {
        float spawnSecsLow = 5.0f;
        float spawnSecsHigh = 10.0f;
        float randSecs = randomValueBetween(spawnSecsLow, spawnSecsHigh);
        nextRotatingMonsterSpawn_ = randSecs + curTime;
		
        // Create a new monster object
        RotatingMonster *rotatingMonster = (RotatingMonster *)[rotatingMonsterArray_ nextObject];
		rotatingMonster.delegate = self;
		rotatingMonster.characterHealth = 2;
		
		float randYLow = 0.0 + (rotatingMonster.contentSize.height / 2.0);
		float randYHigh = screenSize.height - (rotatingMonster.contentSize.height / 2.0);
		float randY = randomValueBetween(randYLow, randYHigh);
		rotatingMonster.position = ccp(screenSize.width + rotatingMonster.contentSize.width / 2.0f, randY);
		
		[sceneSpriteBatchNode_ reorderChild:rotatingMonster z:1000];
		
        [rotatingMonster changeState:kStateSpawning];
		[rotatingMonster changeState:kStateTraveling];
    }	
}

- (void)updateCollisions:(ccTime)deltaTime
{
	for (GameCharacter *arrow in arrowArray_.array) {
        if (!arrow.visible) continue;
        
        for (GameCharacter *monster in monsterArray_.array) {
            if (!monster.visible) continue;
            
            if (CGRectIntersectsRect([monster adjustedBoundingBox], [arrow adjustedBoundingBox])) {
                [monster takeHit];
				if ([monster isDead]) {
					monster.visible = NO;
				}
                arrow.visible = NO;
                break;
            }   
        }
		
		for (GameCharacter *rotatingMonster in rotatingMonsterArray_.array) {
            if (!rotatingMonster.visible) continue;
            
            if (CGRectIntersectsRect([rotatingMonster adjustedBoundingBox], [arrow adjustedBoundingBox])) {
                [rotatingMonster takeHit];
				if ([rotatingMonster isDead]) {
					//rotatingMonster.visible = NO;
					[rotatingMonster zombify];
				}
                arrow.visible = NO;
                break;
            }   
        } 
    }
	
	Cupid *cupid = (Cupid *)[sceneSpriteBatchNode_ getChildByTag:kCupidSpriteTagValue];
	
	for (GameCharacter *monster in monsterArray_.array) {
		if (!monster.visible) continue;
		
		if (CGRectIntersectsRect([monster adjustedBoundingBox], [cupid adjustedBoundingBox])) {
			[cupid changeState:kStateDead];
		}
	}
	
	for (GameCharacter *rotatingMonster in rotatingMonsterArray_.array) {
		if (!rotatingMonster.visible) continue;
		
		if (CGRectIntersectsRect([rotatingMonster adjustedBoundingBox], [cupid adjustedBoundingBox])) {
			[cupid changeState:kStateDead];
		}
	}
}

- (void)loadGameOverLayer
{
	GameOverLayer *gameOverLayer = [GameOverLayer node];
	gameOverLayer.delegate = self;
	[self addChild:gameOverLayer z:500];
}

#pragma mark - Gameplay Delegate Methods

- (void)createObjectOfType:(GameObjectType)objectType
                withHealth:(int)initialHealth
                atLocation:(CGPoint)spawnLocation
                withZValue:(int)zValue
{

}

- (void)createArrowWithPosition:(CGPoint)spawnPosition
{
    Arrow *arrow = (Arrow *)[arrowArray_ nextObject];
    arrow.position = spawnPosition;
    [arrow changeState:kStateSpawning];
	[arrow changeState:kStateTraveling];
}

- (void)createMonsterBeamWithPosition:(CGPoint)spawnPosition
{
	MonsterBeam *beam = (MonsterBeam *)[beamArray_ nextObject];
	beam.position = spawnPosition;
	[beam changeState:kStateSpawning];
	[beam changeState:kStateTraveling];
}

- (void)shouldReturnToMainMenu:(id)sender
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

- (void)shouldRestartScene:(id)sender
{
	[[GameManager sharedGameManager] runSceneWithID:kGameLevel1];
}

@end
