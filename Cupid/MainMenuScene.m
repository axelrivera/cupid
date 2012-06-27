//
//  MainMenuScene.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/17/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"

@implementation MainMenuScene

- (id)init
{
	self = [super init];
	if (self) {
		MainMenuLayer *menuLayer = [MainMenuLayer node];
		[self addChild:menuLayer];
	}
	return self;
}

@end
