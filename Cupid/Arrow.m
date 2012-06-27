//
//  Arrow.m
//  CloudUp
//
//  Created by Axel Rivera on 11/18/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Arrow.h"

@interface Arrow (Private)

- (void)initAnimations;
- (BOOL)isOutsideOfScreen;

@end

@implementation Arrow

- (id)init
{
    self = [super init];
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
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"arrow_1.png"]];
			[self reanimate];
			break;
        case kStateTraveling:
            action = [CCSequence actions:
					  [CCMoveTo actionWithDuration:1.0f position:ccp(self.screenSize.width + 22.0f, self.position.y)],
					  [CCCallFunc actionWithTarget:self selector:@selector(zombify)],
					  nil];
            break;
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
}

- (CGRect)adjustedBoundingBox
{
	return [CCSprite adjustedBoundingBoxForBoundingBox:[self boundingBox]
												ofSize:CGSizeMake(19.0f, 4.0f)
									   atStartingPoint:ccp(2.0f, 3.0f)];
}

#pragma mark - Private Methods

- (BOOL)isOutsideOfScreen
{
    CGPoint currentSpritePosition = self.position;
    if (currentSpritePosition.x > self.screenSize.width) {
        [self changeState:kStateDead];
        return YES;
    }
    return NO;
}

@end
