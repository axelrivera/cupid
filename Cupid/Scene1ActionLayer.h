//
//  Scene1ActionLayer.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CommonProtocols.h"
#import "GameManager.h"
#import "GameControlLayer.h"
#import "GameObjectArray.h"
#import "GameOverLayer.h"

@interface Scene1ActionLayer : CCLayer <GameplayLayerDelegate, GameOverLayerDelegate>

- (void)connectControlsWithFlyButton:(SneakyButton *)flyButton andAttackButton:(SneakyButton *)attackButton;

@end
