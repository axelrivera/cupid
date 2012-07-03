//
//  Scene1ActionLayer.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Scene1ActionLayer.h"

#import "SimpleAudioEngine.h"
#import "GLES-Render.h"
#import "ShapeCache.h"
#import "SimpleContactListener.h"
#import "Cupid.h"
#import "Arrow.h"
#import "Monster.h"
#import "RotatingMonster.h"
#import "MonsterBeam.h"
#import "GameObjectArray.h"
#import "ParticleSystemArray.h"

@interface Scene1ActionLayer (Private)

- (void)spawnCupid;
- (void)setupArrays;
- (void)updateMonsters:(ccTime)deltaTime;
- (void)updateRotatingMonsters:(ccTime)deltaTime;
- (void)updateBox2D:(ccTime)deltaTime;
- (void)createCloud;
- (void)resetCloudWithNode:(id)node;
- (void)loadGameOverLayer;

- (void)setupSound;

- (void)setupWorld;
- (void)setupDebugDraw;

@end

@implementation Scene1ActionLayer
{
	CCSpriteBatchNode *_sceneSpriteBatchNode;
	double _nextMonsterSpawn;
	double _nextRotatingMonsterSpawn;
	GameObjectArray *_monsterArray;
	GameObjectArray *_rotatingMonsterArray;
	GameObjectArray *_arrowArray;
	GameObjectArray *_beamArray;
	ParticleSystemArray *_explosionsArray;
	BOOL _gameOver;
	
	// Box2D
	b2World *_world;
	b2ContactListener *_contactListener;
    GLESDebugDraw *_debugDraw;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setupWorld];
		//[self setupDebugDraw];
		
		_gameOver = NO;
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet-iPhone.plist"];
		_sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"spritesheet-iPhone.png"];
        [self addChild:_sceneSpriteBatchNode z:-1];
		
		[[ShapeCache sharedShapeCache] addShapesWithFile:@"shapes-iPhone.plist"];
		
		[self setupSound];
		
		[self scheduleUpdate];
		[self spawnCupid];
		[self setupArrays];
		
		for (int x = 0; x < 15; x++) {
            [self createCloud];
        }
	}
	return self;
}

//- (void)draw
//{   
//    glDisable(GL_TEXTURE_2D);
//    glDisableClientState(GL_COLOR_ARRAY);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//    _world->DrawDebugData();
//    
//    glEnable(GL_TEXTURE_2D);
//    glEnableClientState(GL_COLOR_ARRAY);
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
//}

- (void)dealloc
{
	[_monsterArray release];
	[_rotatingMonsterArray release];
	[_arrowArray release];
	[_beamArray release];
	[_explosionsArray release];
	[super dealloc];
}

- (void)update:(ccTime)deltaTime
{
	if (_gameOver) return;
	
	CCArray *listOfGameObjects = [_sceneSpriteBatchNode children];
	
	Cupid *cupid = (Cupid *)[_sceneSpriteBatchNode getChildByTag:kCupidSpriteTagValue];
	[cupid updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
	
	if (cupid.characterState == kStateDead && [cupid numberOfRunningActions] == 0) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
		_gameOver = YES;
		[self loadGameOverLayer];
		return;
	}
	
	[self updateMonsters:deltaTime];
	[self updateRotatingMonsters:deltaTime];
	[self updateBox2D:deltaTime];
}

#pragma mark - Custom Methods

- (void)connectControlsWithFlyButton:(SneakyButton *)flyButton andAttackButton:(SneakyButton *)attackButton
{
	Cupid *cupid = (Cupid *)[_sceneSpriteBatchNode getChildByTag:kCupidSpriteTagValue];
	cupid.flyButton = flyButton;
	cupid.attackButton = attackButton;
}

#pragma mark - Private Methods

- (void)spawnCupid
{
	Cupid *cupid = [[[Cupid alloc] initWithSpriteFrameName:@"cupid_1.png" world:_world maxHp:1] autorelease];
	cupid.delegate = self;
	cupid.position = ccp(100.0f, 150.0f);
	[cupid revive];
	[_sceneSpriteBatchNode addChild:cupid z:kCupidSpriteZValue tag:kCupidSpriteTagValue];
}

- (void)setupArrays
{
	_monsterArray = [[GameObjectArray alloc] initWithCapacity:15
													className:NSStringFromClass([Monster class])
											  spriteFrameName:@"monster_grey_1.png"
													batchNode:_sceneSpriteBatchNode
														world:_world
														maxHp:1];
	
	_rotatingMonsterArray = [[GameObjectArray alloc] initWithCapacity:10
															className:NSStringFromClass([RotatingMonster class])
													  spriteFrameName:@"monster_blue.png"
															batchNode:_sceneSpriteBatchNode
																world:_world
																maxHp:3];
	
	_arrowArray = [[GameObjectArray alloc] initWithCapacity:15
												  className:NSStringFromClass([Arrow class])
											spriteFrameName:@"arrow_1.png"
												  batchNode:_sceneSpriteBatchNode
													  world:_world
													  maxHp:1];
	
	_beamArray = [[GameObjectArray alloc] initWithCapacity:20
												 className:NSStringFromClass([MonsterBeam class])
										   spriteFrameName:@"laserbeam_red.png"
												 batchNode:_sceneSpriteBatchNode
													 world:_world
													 maxHp:1];
	
	_explosionsArray = [[ParticleSystemArray alloc] initWithFile:@"Explosion.plist" capacity:3 parent:self];
}

- (void)createCloud
{
	int cloudToDraw = arc4random() % 3 + 1; // Random number between 1 and 3
	NSString *cloudFrameName = [NSString stringWithFormat:@"bg_cloud_%d.png", cloudToDraw];
	GameObject *cloudSprite = [GameObject spriteWithSpriteFrameName:cloudFrameName];
	[_sceneSpriteBatchNode addChild:cloudSprite];
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
	[_sceneSpriteBatchNode reorderChild:cloud z:newZOrder];
}

- (void)updateMonsters:(ccTime)deltaTime
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Is it time to spawn monster?
    double curTime = CACurrentMediaTime();
    if (curTime > _nextMonsterSpawn) {
        float randSecs = randomValueBetween(0.2, 1.0);
        _nextMonsterSpawn = randSecs + curTime;
		
        // Create a new monster object
        GameCharacter *monster = (GameCharacter *)[_monsterArray nextObject];
		if (monster.visible) {
			return;
		}
		
		float randYLow = 0.0 + (monster.contentSize.height / 2.0);
		float randYHigh = screenSize.height - (monster.contentSize.height / 2.0);
		float randY = randomValueBetween(randYLow, randYHigh);
		monster.position = ccp(screenSize.width + monster.contentSize.width / 2.0f, randY);
		
		// Set it's size to be one of 3 random sizes
        int randNum = arc4random() % 3;
        if (randNum == 0) {
            monster.scale = 0.75;
            monster.maxHp = 1;
        } else if (randNum == 1) {
            monster.scale = 1.0;
            monster.maxHp = 2;
        } else {
            monster.scale = 1.25;
            monster.maxHp = 3;
        }
		
        [monster changeState:kStateSpawning];
		[monster changeState:kStateTraveling];
    }
}

- (void)updateRotatingMonsters:(ccTime)deltaTime
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Is it time to spawn monster?
    double curTime = CACurrentMediaTime();
    if (curTime > _nextRotatingMonsterSpawn) {
        float spawnSecsLow = 5.0f;
        float spawnSecsHigh = 10.0f;
        float randSecs = randomValueBetween(spawnSecsLow, spawnSecsHigh);
        _nextRotatingMonsterSpawn = randSecs + curTime;
		
        // Create a new monster object
        RotatingMonster *rotatingMonster = (RotatingMonster *)[_rotatingMonsterArray nextObject];
		rotatingMonster.maxHp = 4;
		rotatingMonster.delegate = self;
		
		float randYLow = 0.0 + (rotatingMonster.contentSize.height / 2.0);
		float randYHigh = screenSize.height - (rotatingMonster.contentSize.height / 2.0);
		float randY = randomValueBetween(randYLow, randYHigh);
		rotatingMonster.position = ccp(screenSize.width + rotatingMonster.contentSize.width / 2.0f, randY);
				
        [rotatingMonster changeState:kStateSpawning];
		[rotatingMonster changeState:kStateTraveling];
    }	
}

- (void)updateBox2D:(ccTime)deltaTime
{
	_world->Step(deltaTime, 1, 1);
    for(b2Body *b = _world->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetUserData() != NULL) {
            GameObject *sprite = (GameObject *)b->GetUserData();
            
			if (!sprite.visible) continue;
			
            b2Vec2 b2Position = b2Vec2(sprite.position.x / PTM_RATIO, sprite.position.y / PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            
            b->SetTransform(b2Position, b2Angle);
        }
    }
}

- (void)loadGameOverLayer
{
	GameOverLayer *gameOverLayer = [GameOverLayer node];
	gameOverLayer.delegate = self;
	[self addChild:gameOverLayer z:500];
}

- (void)setupSound
{
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Positive_Boy.mp3" loop:YES];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"dead.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"laser.wav"];
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
    Arrow *arrow = (Arrow *)[_arrowArray nextObject];
    arrow.position = spawnPosition;
	[[SimpleAudioEngine sharedEngine] playEffect:@"shoot.wav"];
    [arrow changeState:kStateSpawning];
	[arrow changeState:kStateTraveling];
}

- (void)createMonsterBeamWithPosition:(CGPoint)spawnPosition
{
	MonsterBeam *beam = (MonsterBeam *)[_beamArray nextObject];
	beam.position = spawnPosition;
	[[SimpleAudioEngine sharedEngine] playEffect:@"laser.wav"];
	[beam changeState:kStateSpawning];
	[beam changeState:kStateTraveling];
}

- (void)shouldReturnToMainMenu:(id)sender
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

- (void)shouldRestartScene:(id)sender
{
	[[GameManager sharedGameManager] runSceneWithID:kGameLevel1];
}

- (void)setupWorld {    
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = false; 
    _world = new b2World(gravity, doSleep); 
    _contactListener = new SimpleContactListener(self);
    _world->SetContactListener(_contactListener);
}

- (void)setupDebugDraw {    
    _debugDraw = new GLESDebugDraw(PTM_RATIO * [[CCDirector sharedDirector] contentScaleFactor]);
    _world->SetDebugDraw(_debugDraw);
    _debugDraw->SetFlags(b2DebugDraw::e_shapeBit | b2DebugDraw::e_jointBit);
}

#pragma mark - SimpleContactListener Callback Methods

- (void)beginContact:(b2Contact *)contact
{
	b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
	
    b2Body *bodyA = fixtureA->GetBody();
    b2Body *bodyB = fixtureB->GetBody();
    
	GameObject *spriteA = (GameObject *)bodyA->GetUserData();
    GameObject *spriteB = (GameObject *)bodyB->GetUserData();
    
    if (!spriteA.visible || !spriteB.visible) return;
	
	b2WorldManifold manifold;
	contact->GetWorldManifold(&manifold);
	b2Vec2 b2ContactPoint = manifold.points[0];
	CGPoint contactPoint = ccp(b2ContactPoint.x * PTM_RATIO, b2ContactPoint.y * PTM_RATIO);
    
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if ((fixtureA->GetFilterData().categoryBits & kCategoryCupidArrow && fixtureB->GetFilterData().categoryBits & kCategoryEnemy) ||
        (fixtureB->GetFilterData().categoryBits & kCategoryCupidArrow && fixtureA->GetFilterData().categoryBits & kCategoryEnemy))
	{ 
        // Determine enemy and arrow
        GameObject *enemy = (GameObject *)spriteA;
        GameObject *arrow = (GameObject *)spriteB;
        if (fixtureB->GetFilterData().categoryBits & kCategoryEnemy) {
            enemy = (GameObject *)spriteB;
            arrow = (GameObject *)spriteA;
        }
        
        // Make sure not already dead
        if (![enemy dead] && ![arrow dead]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
            [enemy takeHit];
			if ([enemy dead]) {
				CCParticleSystemQuad *explosion = [_explosionsArray nextParticleSystem];
				explosion.scale = 0.2;
				explosion.position = contactPoint;
				[explosion resetSystem];
			} else {
				CCParticleSystemQuad *explosion = [_explosionsArray nextParticleSystem];
				explosion.scale *= 0.1;
				explosion.position = contactPoint;
				[explosion resetSystem];
			}
			
            [arrow takeHit];           
        }
    }
    
    if ((fixtureA->GetFilterData().categoryBits & kCategoryCupid && fixtureB->GetFilterData().categoryBits & kCategoryEnemy) ||
        (fixtureB->GetFilterData().categoryBits & kCategoryCupid && fixtureA->GetFilterData().categoryBits & kCategoryEnemy))
	{
		GameObject *enemy = (GameObject *)spriteA;
        if (fixtureB->GetFilterData().categoryBits & kCategoryEnemy) {
            enemy = (GameObject *)spriteB;
        }
		
		if (enemy.gameObjectType == kMonsterBeamType) {
			[enemy takeHit];
		}

        Cupid *cupid = (Cupid *)[_sceneSpriteBatchNode getChildByTag:kCupidSpriteTagValue];
		[cupid takeHit];
    }    
}

- (void)endContact:(b2Contact *)contact
{
	// End Contact Code
}

@end
