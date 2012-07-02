//
//  GameObject.h
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "CommonProtocols.h"
#import "CCSprite+Extras.h"
//#import "GameManager.h"

@interface GameObject : CCSprite

@property (nonatomic, readonly) NSInteger hp;
@property (nonatomic, readonly) b2World *world;
@property (nonatomic, readonly) b2Body *body;
@property (nonatomic, readonly) NSString *defaultName;

@property (nonatomic, assign) GameObjectType gameObjectType;
@property (nonatomic, assign) CGFloat maxHp;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL reactsToScreenBoundaries;

// The Shape Name will be derived from the spriteFrameName
- (id)initWithSpriteFrameName:(NSString *)spriteFrameName
						world:(b2World *)world
					maxHp:(NSInteger)maxHp;

- (void)changeState:(CharacterStates)newState;
- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects;
- (BOOL)dead;
- (void)destroy;
- (void)revive;
- (void)takeHit;
- (CGRect)adjustedBoundingBox;
- (CCAnimation *)loadPlistForAnimationName:(NSString *)animationName andClassName:(NSString *)className;

@end
