//
//  Arrow.m
//  CloudUp
//
//  Created by Axel Rivera on 11/18/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName world:(b2World *)world maxHp:(NSInteger)maxHp
{
    self = [super initWithSpriteFrameName:spriteFrameName world:world maxHp:maxHp];
    if (self) {
        self.gameObjectType = kArrowType;
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
			break;
        case kStateTraveling:
		{
			CGSize winSize = [CCDirector sharedDirector].winSize;
			CGFloat xOffset = winSize.width + [self boundingBox].size.width;
            action = [CCSequence actions:
					  [CCMoveBy actionWithDuration:1.0 position:ccp(xOffset, 0)],
					  [CCCallFunc actionWithTarget:self selector:@selector(destroy)],
					  nil];
            break;
		}
        default:
            CCLOG(@"Arrow: Unknown state %@", self.characterState);
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
