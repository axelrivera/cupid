//
//  Scene1ActionLayer.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "CommonProtocols.h"
#import "GameManager.h"
#import "GameControlLayer.h"
#import "GameOverLayer.h"

@class GameScoreLayer;

@interface Scene1ActionLayer : CCLayer <GameplayLayerDelegate, GameOverLayerDelegate>

@property (nonatomic, assign) GameScoreLayer *gameScoreLayer;

- (void)connectControlsWithFlyButton:(SneakyButton *)flyButton andAttackButton:(SneakyButton *)attackButton;

- (void)beginContact:(b2Contact *)contact;
- (void)endContact:(b2Contact *)contact;

@end
