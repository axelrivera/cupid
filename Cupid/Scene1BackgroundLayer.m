//
//  Scene1BackgroundLayer.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Scene1BackgroundLayer.h"

@implementation Scene1BackgroundLayer

- (id)init
{
    self = [super init];
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		NSString *fileName = @"backgroundiPhone.png";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			fileName = @"backgroundiPad.png";
		}
		
        CCSprite *backgroundImage = [CCSprite spriteWithFile:fileName];
        backgroundImage.position = CGPointMake(screenSize.width / 2.0f, screenSize.height / 2.0f);
        [self addChild:backgroundImage z:0 tag:0];
    }
    return self;
}

@end
