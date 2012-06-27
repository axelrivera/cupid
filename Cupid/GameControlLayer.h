//
//  GameControlLayer.h
//  SpaceViking
//
//  Created by Axel Rivera on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"

@interface GameControlLayer : CCLayer

@property (nonatomic, readonly) SneakyButton *flyButton;
@property (nonatomic, readonly) SneakyButton *attackButton;

@end
