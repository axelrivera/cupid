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
@synthesize invincible = _invincible;
@synthesize moving = _moving;
@synthesize flappingAnim = flappingAnim_;
@synthesize shootingAnim = shootingAnim_; 
@synthesize flyButton = flyButton_;
@synthesize attackButton = attackButton_;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName world:(b2World *)world maxHp:(NSInteger)maxHp
{
    self = [super initWithSpriteFrameName:spriteFrameName world:world maxHp:maxHp];
    if (self) {
        self.gameObjectType = kCupidType;
		_invincible = NO;
		_moving = NO;
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
		{
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.defaultName]];
            break;
		}
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
    if (self.characterState == kStateDead && [self numberOfRunningActions] == 0) {
        return;
    }
	
	if (self.isMoving && (attackButton_.active && self.characterState != kStateAttacking)) {
		[self changeState:kStateAttacking];
		return;
	}
	
	if (self.isMoving && self.characterState == kStateAttacking) {
		[self changeState:kStateTraveling];
		return;
	}
	
	if (!self.isMoving && flyButton_.active) {
		self.moving = YES;
		[self changeState:kStateTraveling];
	}
		
	if (self.isMoving && flyButton_.active) {
		[self fly:deltaTime];
	} else if (self.isMoving && !flyButton_.active) {
		[self fall:deltaTime];
	}
}

- (void)takeHit
{
	[super takeHit];
	if ([self dead]) {
		[self changeState:kStateDead];
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
	CGPoint scaledVelocity = ccp(0.0f, kCupidFlyAcceleration);
    CGPoint oldPosition = self.position;
	
	float top = oldPosition.y + (self.contentSize.height / 2.0);
	
	CGPoint newPosition;
	
	if (top >= self.screenSize.height) {
		newPosition = ccp(oldPosition.x, self.screenSize.height - (self.contentSize.height * 0.45));
	} else {
		newPosition = ccp(oldPosition.x, oldPosition.y + scaledVelocity.y * deltaTime);
	}
	
    self.position = newPosition;
}

- (void)fall:(ccTime)deltaTime
{	
	CGPoint scaledVelocity = ccp(0.0f, kCupidFallAcceleration);
    CGPoint oldPosition = self.position;
	
	float bottom = oldPosition.y - (self.contentSize.height / 2.0);
	
	CGPoint newPosition;
	
	if (bottom <= 0.0f) {
		newPosition = ccp(oldPosition.x, self.contentSize.height * 0.45);
	} else {
		newPosition = ccp(oldPosition.x, oldPosition.y - scaledVelocity.y * deltaTime);
	}
	
    self.position = newPosition;
}

- (void)shootArrow
{
    CGRect boundingBox = [self boundingBox];
    float xPosition = boundingBox.origin.x + (boundingBox.size.width * 0.75f);
    float yPosition = boundingBox.origin.y + (boundingBox.size.height * 0.5f);
    CGPoint arrowFiringPosition = ccp(xPosition, yPosition);
    [self.delegate createArrowWithPosition:arrowFiringPosition];
}

@end
