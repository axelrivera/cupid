//
//  GreyMonster.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/13/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Monster.h"

@interface Monster (Private)

- (void)initAnimations;

@end

@implementation Monster

@synthesize movingAnim = movingAnim_;

- (id)init
{
	self = [super init];
	if (self) {
		self.gameObjectType = kMonsterType;
		[self initAnimations];
	}
	return self;
}

- (void)dealloc
{
	[movingAnim_ release];
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
		{
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monster_grey_1.png"]];
			[self revive];
			break;
		}
		case kStateTraveling:
		{
			[self runAction:
			 [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:movingAnim_ restoreOriginalFrame:NO]]];
			float xOffset = [self boundingBox].size.width / 2.0f;
			float offScreenXPosition = (xOffset * -1) - 1;
			action = [CCSequence actions:
					  [CCMoveTo actionWithDuration:randomValueBetween(2.0f, 10.0f) position:ccp(offScreenXPosition, self.position.y)],
					  [CCCallFunc actionWithTarget:self selector:@selector(destroy)],
					  nil];
            break;
        }
		default:
		{
			CCLOG(@"Monster: Unknown state %@", self.characterState);
            break;
		}
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
												ofSize:CGSizeMake(34.0f, 34.0f)
									   atStartingPoint:CGPointMake(9.0f, 22.0f)];
}

#pragma mark - Private Methods

- (void)initAnimations
{
	self.movingAnim = [self loadPlistForAnimationName:@"movingAnim" andClassName:NSStringFromClass([self class])];
}

@end
