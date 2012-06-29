//
//  Cupid.m
//  CloudUp
//
//  Created by Axel Rivera on 11/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Cupid.h"
#import "CCSprite+Extras.h"

@interface Cupid (Private)

- (void)initAnimations;
- (void)fly:(ccTime)deltaTime;
- (void)fall:(ccTime)deltaTime;
- (void)shootArrow;

@end

@implementation Cupid

@synthesize delegate = delegate_;
@synthesize isMoving = isMoving_;
@synthesize flappingAnim = flappingAnim_;
@synthesize shootingAnim = shootingAnim_; 
@synthesize flyButton = flyButton_;
@synthesize attackButton = attackButton_;

- (id)init
{
    self = [super init];
    if (self) {
        self.gameObjectType = kCupidType;
		isMoving_ = NO;
        [self initAnimations];
    }
    return self;
}

- (void)dealloc
{
    delegate_ = nil;
	flyButton_ = nil;
	attackButton_ = nil;
    [flappingAnim_ release];
    [shootingAnim_ release];
    [super dealloc];
}

#pragma mark - Parent Methods

- (void)changeState:(CharacterStates)newState
{
    [self stopAllActions];
    id action = nil;
    self.characterState = newState;
    
    switch (newState) {
        case kStateIdle:
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cupid_1.png"]];
            break;
		case kStateTraveling:
			action = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:flappingAnim_ restoreOriginalFrame:YES]];
			break;
        case kStateAttacking:
            action = [CCSpawn actions:
                      [CCAnimate actionWithAnimation:shootingAnim_ restoreOriginalFrame:YES],
                      [CCCallFunc actionWithTarget:self selector:@selector(shootArrow)],
                      nil];
            break;
		case kStateDead:
			break;
        default:
			CCLOG(@"Cupid: Unknown state %@", self.characterState);
            break;
    }
    if (action) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if (self.characterState == kStateDead) {
        return;
    }
	
	if (isMoving_ && (attackButton_.active && self.characterState != kStateAttacking)) {
		[self changeState:kStateAttacking];
		return;
	}
	
	if (!isMoving_ && flyButton_.active) {
		isMoving_ = YES;
	}
		
	if (isMoving_ && flyButton_.active) {
		if (self.characterState != kStateTraveling) {
			[self changeState:kStateTraveling];
		}
		[self fly:deltaTime];
	} else if (isMoving_ && !flyButton_.active) {
		if (self.characterState != kStateIdle) {
			[self changeState:kStateIdle];
		}
		[self fall:deltaTime];
	}
}

#pragma mark - Private Methods

- (void)initAnimations
{
    self.flappingAnim = [self loadPlistForAnimationName:@"flappingAnim" andClassName:NSStringFromClass([self class])];
    self.shootingAnim = [self loadPlistForAnimationName:@"shootingAnim" andClassName:NSStringFromClass([self class])];
}

- (void)fly:(ccTime)deltaTime
{
	CGRect cupidBoundingBox = [self adjustedBoundingBox];
	CGPoint scaledVelocity = ccp(0.0f, 150.0f);
    CGPoint oldPosition = self.position;
	
	float top = cupidBoundingBox.origin.y + cupidBoundingBox.size.height;
	
	CGPoint newPosition;
	
	if (top >= self.screenSize.height) {
		newPosition = ccp(oldPosition.x, 245.0f);
	} else {
		newPosition = ccp(oldPosition.x, oldPosition.y + scaledVelocity.y * deltaTime);
	}
	
    self.position = newPosition;
}

- (void)fall:(ccTime)deltaTime
{	
	CGPoint scaledVelocity = ccp(0.0f, 150.0f);
    CGPoint oldPosition = self.position;
	
	float bottom = oldPosition.y;
	
	CGPoint newPosition;
	
	if (bottom <= 0.0f) {
		newPosition = ccp(oldPosition.x, 0.0f);
	} else {
		newPosition = ccp(oldPosition.x, oldPosition.y - scaledVelocity.y * deltaTime);
	}
	
    self.position = newPosition;
}

- (void)shootArrow
{
    CGRect boundingBox = [self boundingBox];
    
    float xPosition = boundingBox.origin.x + (boundingBox.size.width * 0.6484f);
    float yPosition = boundingBox.origin.y + (boundingBox.size.height * 0.4715f);
    
    CGPoint arrowFiringPosition = ccp(xPosition, yPosition);
    [self.delegate createArrowWithPosition:arrowFiringPosition];
}

@end
