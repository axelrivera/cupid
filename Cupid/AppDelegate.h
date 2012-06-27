//
//  AppDelegate.h
//  Cupid
//
//  Created by Axel Rivera on 3/15/12.
//  Copyright Axel Rivera 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
