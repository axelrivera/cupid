//
//  GameObject.h
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CommonProtocols.h"
#import "CCSprite+Extras.h"
//#import "GameManager.h"

@interface GameObject : CCSprite

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL reactsToScreenBoundaries;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) GameObjectType gameObjectType;

- (void)changeState:(CharacterStates)newState;
- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects;
- (CGRect)adjustedBoundingBox;
- (CCAnimation *)loadPlistForAnimationName:(NSString *)animationName andClassName:(NSString *)className;

- (void)zombify;
- (void)reanimate;
- (void)destroy;

@end
