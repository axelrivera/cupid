//
//  GameOverLayer.m
//  CloudUp
//
//  Created by Axel Rivera on 11/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "GameOverLayer.h"

@interface GameOverLayer (Private)

- (void)mainMenuAction:(id)sender;
- (void)restartSceneAction:(id)sender;

@end

@implementation GameOverLayer
{
	CCLabelBMFont *titleLabel_;
	CCMenuItemLabel *mainMenuItem_;
	CCMenuItemLabel *restartMenuItem_;
}

@synthesize delegate = delegate_;

- (id)init
{
    self = [super init];
    if (self) {
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		NSString *fontName = @"CupidFont.fnt";
		
		titleLabel_ = [CCLabelBMFont labelWithString:@"Game Over" fntFile:fontName];
		titleLabel_.scale = 0.7f;
		titleLabel_.position = ccp(screenSize.width / 2.0, screenSize.height * 0.65);
		[self addChild:titleLabel_];
		
		CCLabelBMFont *mainMenuLabel = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:fontName];
		mainMenuItem_ = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(mainMenuAction:)];
		mainMenuItem_.scale = 0.4f;
		
		CCLabelBMFont *restartMenuLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:fontName];
		restartMenuItem_ = [CCMenuItemLabel itemWithLabel:restartMenuLabel target:self selector:@selector(restartSceneAction:)];
		restartMenuItem_.scale = 0.4f;
		
		CCMenu *menu = [CCMenu menuWithItems:mainMenuItem_, restartMenuItem_, nil];
		menu.position = ccp(screenSize.width / 2.0f, screenSize.height * 0.4f);
		[menu alignItemsHorizontallyWithPadding:screenSize.width * 0.2f];
		[self addChild:menu];
    }
    return self;
}

- (void)dealloc
{
	delegate_ = nil;
	[super dealloc];
}

#pragma mark - Custom Methods

- (void)mainMenuAction:(id)sender
{
	[mainMenuItem_ runAction:
	 [CCSequence actions:
	  [CCScaleTo actionWithDuration:2.0 scale:1.3],
	  [CCDelayTime actionWithDuration:2.0],
	  nil]];

	[delegate_ shouldReturnToMainMenu:sender];
}

- (void)restartSceneAction:(id)sender
{
	[restartMenuItem_ runAction:
	 [CCSequence actions:
	  [CCScaleTo actionWithDuration:2.0 scale:1.3],
	  [CCDelayTime actionWithDuration:2.0],
	  nil]];
	[delegate_ shouldRestartScene:sender];
}

@end
