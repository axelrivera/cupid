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

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName world:(b2World *)world maxHp:(NSInteger)maxHp
{
	self = [super initWithSpriteFrameName:spriteFrameName world:world maxHp:maxHp];
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
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.defaultName]];
			[self revive];
			break;
		}
		case kStateTraveling:
		{
			[self runAction:
			 [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:movingAnim_ restoreOriginalFrame:NO]]];
			CGSize winSize = [CCDirector sharedDirector].winSize;
			float xOffset = -winSize.width - self.contentSize.width;
			//float offScreenXPosition = (xOffset * -1) - 1;
			action = [CCSequence actions:
					  //[CCMoveTo actionWithDuration:randomValueBetween(2.0f, 10.0f) position:ccp(offScreenXPosition, self.position.y)],
					  [CCMoveBy actionWithDuration:randomValueBetween(2.0f, 10.0f) position:ccp(xOffset, 0)],
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

#pragma mark - Private Methods

- (void)initAnimations
{
	self.movingAnim = [self loadPlistForAnimationName:@"movingAnim" andClassName:NSStringFromClass([self class])];
}

@end
