//
//  Star.m
//  Cupid
//
//  Created by Axel Rivera on 7/8/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "Star.h"

@implementation Star

- (id)init
{
    self = [super init];
    if (self) {
        self.gameObjectType = kStarType;
    }
    return self;
}

- (void)dealloc
{
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
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.defaultName]];
			self.maxHp = 1;
			[self revive];
			NSLog(@"Spawning Star with Frame: %@", self.defaultName);
			break;
        case kStateTraveling:
		{
			CGSize winSize = [CCDirector sharedDirector].winSize;
			float xOffset = -winSize.width - self.contentSize.width;
			action = [CCSequence actions:
					  [CCMoveBy actionWithDuration:randomValueBetween(2.0f, 10.0f) position:ccp(xOffset, 0)],
					  [CCCallFunc actionWithTarget:self selector:@selector(destroy)],
					  nil];
            break;
        }
        default:
            CCLOG(@"%@: Unknown state %@", NSStringFromClass([self class]), self.characterState);
            break;
    }
    
    if (action) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
	// Update Method
}

@end