//
//  GameCharacter.h
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject

@property (nonatomic, assign) int characterHealth;
@property (nonatomic, assign) CharacterStates characterState;

- (int)getWeaponDamage;
- (void)checkAndClampSpritePosition;
- (BOOL)isDead;
- (void)reanimateWithHealth:(int)health;
- (void)takeHit;
- (void)takeHitWithDamage:(int)damage;

@end
