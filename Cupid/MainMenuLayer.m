//
//  MainMenuLayer.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/17/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "MainMenuLayer.h"

@interface MainMenuLayer (Private)

- (void)playAction:(id)sender;

@end

@implementation MainMenuLayer

- (id)init
{
	self = [super init];
	if (self) {
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		NSString *backgroundName = @"backgroundiPhone.png";
		NSString *fontName = @"CupidFont.fnt";
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			backgroundName = @"backgroundiPad.png";
			fontName = @"CupidFont-hd.fnt";
		}
		
		CCSprite *background = [CCSprite spriteWithFile:backgroundName];
		background.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f);
		[self addChild:background z:0];
		
		titleLabel_ = [CCLabelBMFont labelWithString:@"Cupid vs Monsters" fntFile:fontName];
		titleLabel_.scale = 0.6f;
		titleLabel_.position = ccp(screenSize.width / 2.0, screenSize.height * 0.6);
		[self addChild:titleLabel_];
		
		CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play" fntFile:fontName];
		playMenuItem_ = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playAction:)];
		playMenuItem_.scale = 0.6f;
		playMenuItem_.position = ccp(screenSize.width / 2.0f, screenSize.height * 0.3f);
		
		CCMenu *menu = [CCMenu menuWithItems:playMenuItem_, nil];
		menu.position = CGPointZero;
		[self addChild:menu];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - Selector Actions

- (void)playAction:(id)sender
{
	[playMenuItem_ runAction:
	 [CCSequence actions:
	  [CCScaleTo actionWithDuration:2.0 scale:1.3],
	  [CCDelayTime actionWithDuration:2.0],
	  nil]];
	[[GameManager sharedGameManager] runSceneWithID:kGameLevel1];
}

@end
