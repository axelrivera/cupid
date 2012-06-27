//
//  GameOverLayer.h
//  CloudUp
//
//  Created by Axel Rivera on 11/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameManager.h"

@protocol GameOverLayerDelegate;

@interface GameOverLayer : CCLayer
{
	CCLabelBMFont *titleLabel_;
	CCMenuItemLabel *mainMenuItem_;
	CCMenuItemLabel *restartMenuItem_;
}

@property (nonatomic, assign) id <GameOverLayerDelegate> delegate;

@end

@protocol GameOverLayerDelegate

- (void)shouldReturnToMainMenu:(id)sender;
- (void)shouldRestartScene:(id)sender;

@end


