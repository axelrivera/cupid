//
//  BlueMonster.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/13/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RotatingMonster.h"

@implementation RotatingMonster

@synthesize delegate = delegate_;

- (id)init
{
	self = [super init];
	if (self) {
		self.gameObjectType = kRotatingMonsterType;
	}
	return self;
}

- (void)dealloc
{
	delegate_ = nil;
	[super dealloc];
}

#pragma mark - Parent Methods

- (void)changeState:(CharacterStates)newState
{
	[self stopAllActions];
    id action = nil;
    self.characterState = newState;
	
	switch (newState) {
		case kStateSpawning:
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monster_blue.png"]];
			[self reanimate];
			break;
		case kStateTraveling:
			[self runAction:
			 [CCRepeatForever actionWithAction:
			  [CCSequence actions:
			   [CCDelayTime actionWithDuration:0.5],
			   [CCRotateBy actionWithDuration:2.5 angle:360.0f],
			   [CCCallFunc actionWithTarget:self selector:@selector(shootBeam)],
			   nil]]];
			float xOffset = [self boundingBox].size.width / 2.0f;
			float offScreenXPosition = (xOffset * -1) - 1;
			action = [CCSequence actions:
					  [CCMoveTo actionWithDuration:randomValueBetween(8.0f, 12.0f) position:ccp(offScreenXPosition, self.position.y)],
					  [CCCallFunc actionWithTarget:self selector:@selector(zombify)],
					  nil];
            break;
        default:
			CCLOG(@"Rotating Monster: Unknown state %@", self.characterState);
            break;
    }
    if (action) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
}

- (CGRect)adjustedBoundingBox
{
	return [CCSprite adjustedBoundingBoxForBoundingBox:[self boundingBox]
												ofSize:CGSizeMake(65.0f, 40.0f)
									   atStartingPoint:CGPointMake(3.0f, 19.0f)];
}

#pragma mark - Selector Methods

- (void)shootBeam
{
	CGRect boundingBox = [self boundingBox];
    
    float xPosition = boundingBox.origin.x + (boundingBox.size.width * 0.6484f);
    float yPosition = boundingBox.origin.y + (boundingBox.size.height * 0.4715f);
    
    CGPoint beamFiringPosition = ccp(xPosition, yPosition);
    [self.delegate createMonsterBeamWithPosition:beamFiringPosition];
}

@end
