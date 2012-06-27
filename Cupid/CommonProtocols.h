//
//  CommonProtocols.h
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateAttacking,
    kStateTakingDamage,
    kStateTraveling,
    kStateDead,
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kCupidType,
    kArrowType,
    kMonsterType,
    kRotatingMonsterType,
	kMonsterBeamType
} GameObjectType;

@protocol GameplayLayerDelegate

- (void)createObjectOfType:(GameObjectType)objectType
                withHealth:(int)initialHealth
                atLocation:(CGPoint)spawnLocation
                withZValue:(int)zValue;

- (void)createArrowWithPosition:(CGPoint)spawnPosition;
- (void)createMonsterBeamWithPosition:(CGPoint)spawnPosition;

@end

