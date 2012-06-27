//
//  GameControlLayer.m
//  SpaceViking
//
//  Created by Axel Rivera on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameControlLayer.h"

@interface GameControlLayer (Private)

- (void)initButtons;

@end

@implementation GameControlLayer

@synthesize flyButton = flyButton_;
@synthesize attackButton = attackButton_;

- (id)init
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        [self initButtons];
        CCLOG(@"GameControlLayer: Initialized");
    }
    return self;
}

- (void)dealloc
{
    [flyButton_ release];
    [attackButton_ release];
    [super dealloc];
}

#pragma mark - Private Methods

- (void)initButtons
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	NSString *buttonUpName = nil;
	NSString *buttonDownName = nil;
	
    CGRect flyButtonDimensions = CGRectMake(0.0f, 0.0f, 64.0f, 64.0f);
    CGRect attackButtonDimensions = CGRectMake(0.0f, 0.0f, 64.0f, 64.0f);
    
    CGPoint flyButtonPosition;
    CGPoint attackButtonPosition;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		buttonUpName = @"buttonUp-hd.png";
		buttonDownName = @"buttonDown-hd.png";
		flyButtonDimensions = CGRectMake(0.0f, 0.0f, 128.0f, 128.0f);
		attackButtonDimensions = CGRectMake(0.0f, 0.0f, 128.0f, 128.0f);
		flyButtonPosition = ccp(screenSize.width * 0.09f, screenSize.height * 0.12f);
		attackButtonPosition = ccp(screenSize.width * 0.91f, screenSize.height * 0.12f);
	} else {
		buttonUpName = @"buttonUp.png";
		buttonDownName = @"buttonDown.png";
		flyButtonDimensions = CGRectMake(0.0f, 0.0f, 64.0f, 64.0f);
		attackButtonDimensions = CGRectMake(0.0f, 0.0f, 64.0f, 64.0f);
		flyButtonPosition = ccp(screenSize.width * 0.09f, screenSize.height * 0.12f);
		attackButtonPosition = ccp(screenSize.width * 0.91f, screenSize.height * 0.12f);
	}
    
    SneakyButtonSkinnedBase *flyButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    flyButtonBase.position = flyButtonPosition;
    flyButtonBase.defaultSprite = [CCSprite spriteWithFile:buttonUpName];
    flyButtonBase.activatedSprite = [CCSprite spriteWithFile:buttonDownName];
    flyButtonBase.pressSprite = [CCSprite spriteWithFile:buttonDownName];
    
    flyButton_ = [[SneakyButton alloc] initWithRect:flyButtonDimensions];
    flyButton_.isToggleable = NO;
	flyButton_.isHoldable = YES;
    flyButtonBase.button = flyButton_;
    [self addChild:flyButtonBase];
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    attackButtonBase.position = attackButtonPosition;
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:buttonUpName];
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:buttonDownName];
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:buttonDownName];
    
    attackButton_ = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
    attackButton_.isToggleable = NO;
    attackButtonBase.button = attackButton_;
    [self addChild:attackButtonBase];
}

@end
