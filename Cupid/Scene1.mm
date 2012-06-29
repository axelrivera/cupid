//
//  Scene1.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Scene1.h"
#import "Scene1BackgroundLayer.h"
#import "Scene1ActionLayer.h"
#import "GameControlLayer.h"

@implementation Scene1

- (id)init
{
	self = [super init];
	if (self) {
		Scene1BackgroundLayer *backgroundLayer = [Scene1BackgroundLayer node];
		[self addChild:backgroundLayer z:0];
		
		GameControlLayer *controlLayer = [GameControlLayer node];
		[self addChild:controlLayer z:10 tag:2];
		
		Scene1ActionLayer *actionLayer = [Scene1ActionLayer node];
		[actionLayer connectControlsWithFlyButton:controlLayer.flyButton andAttackButton:controlLayer.attackButton];
		[self addChild:actionLayer z:5];
	}
	return self;
}

@end
