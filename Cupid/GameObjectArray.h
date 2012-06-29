//
//  SpriteArray.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface GameObjectArray : NSObject

@property (nonatomic, readonly) CCArray *array;

- (id)initWithCapacity:(NSInteger)capacity
			 className:(NSString *)className
	   spriteFrameName:(NSString *)spriteFrameName
			 batchNode:(CCSpriteBatchNode *)batchNode
				 world:(b2World *)world
			 maxHealth:(NSInteger)maxHealth;

- (id)nextObject;

@end
