//
//  GameCharacter.m
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCharacter.h"
#import "GameManager.h"

@implementation GameCharacter

@synthesize characterHealth = characterHealth_;
@synthesize characterState = characterState_;

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Custom Methods

- (int)getWeaponDamage
{
    // getWeaponDamate should be overridden.
    return 0;
}

- (void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = self.position;
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsForcurrentScene];
    
    float xOffset = 24.0f;
    
    if (currentSpritePosition.x < xOffset) {
        self.position = ccp(xOffset, currentSpritePosition.y);
    } else if (currentSpritePosition.x > (levelSize.width - xOffset)) {
        self.position = ccp(levelSize.width - xOffset, currentSpritePosition.y);
    }
}

- (void)zombify
{
	self.characterHealth = 0;
	[super zombify];
}

- (BOOL)isDead
{
	if (self.characterHealth <= 0) {
		return YES;
	}
	return NO;
}

- (void)reanimateWithHealth:(int)health
{
	self.characterHealth = health;
	[super reanimate];
}

- (void)takeHit
{
	[self takeHitWithDamage:1];
}

- (void)takeHitWithDamage:(int)damage
{
	if (![self isDead]) {
		self.characterHealth -= damage;
	}
}

@end
