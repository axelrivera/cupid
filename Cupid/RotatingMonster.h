//
//  BlueMonster.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/13/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface RotatingMonster : GameCharacter

@property (nonatomic, assign) id <GameplayLayerDelegate> delegate;

@end
