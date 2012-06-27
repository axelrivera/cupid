//
//  MonsterBeam.m
//  Cupid
//
//  Created by Axel Rivera on 3/18/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "MonsterBeam.h"

@interface MonsterBeam (Private)

- (void)initAnimations;

@end

@implementation MonsterBeam

@synthesize firingAnim = firingAnim_;
@synthesize travelingAnim = travelingAnim_;

- (id)init
{
	self = [super init];
	if (self) {
		CCLOG(@"MonsterBeam: initialized");
		self.gameObjectType = kMonsterBeamType;
		[self initAnimations];
	}
	return self;
}

- (void)dealloc
{
	[firingAnim_ release];
	[travelingAnim_ release];
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
			action = [CCAnimate actionWithAnimation:self.firingAnim restoreOriginalFrame:NO];
			[self reanimate];
			break;
        case kStateTraveling:
			[self runAction:
			 [CCRepeatForever actionWithAction:
			  [CCAnimate actionWithAnimation:self.firingAnim restoreOriginalFrame:NO]]];
			
            action = [CCSequence actions:
					  [CCMoveTo actionWithDuration:1.0f position:ccp(0.0 - 22.0f, self.position.y)],
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
	return [super adjustedBoundingBox];
}

#pragma mark - Private Methods

- (void)initAnimations
{
	self.firingAnim = [self loadPlistForAnimationName:@"firingAnim" andClassName:NSStringFromClass([self class])];
	self.travelingAnim = [self loadPlistForAnimationName:@"travelingAnim" andClassName:NSStringFromClass([self class])];
}

@end
