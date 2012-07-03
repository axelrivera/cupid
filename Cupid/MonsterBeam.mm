//
//  MonsterBeam.m
//  Cupid
//
//  Created by Axel Rivera on 3/18/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "MonsterBeam.h"

@implementation MonsterBeam

- (id)init
{
	self = [super init];
	if (self) {
		CCLOG(@"MonsterBeam: initialized");
		self.gameObjectType = kMonsterBeamType;
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
			CGFloat velocity = (winSize.width + ([self boundingBox].size.width / 2.0)) / 1.5f;
			CGFloat duration = self.position.x / velocity;
            action = [CCSequence actions:
					  [CCMoveTo actionWithDuration:duration position:ccp(0.0 - 29.0f, self.position.y)],
					  [CCCallFunc actionWithTarget:self selector:@selector(destroy)],
					  nil];
            break;
		}
        default:
            CCLOG(@"Monster Beam: Unknown state %@", self.characterState);
            break;
    }
    
    if (action) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
	
}

@end
