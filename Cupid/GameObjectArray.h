//
//  SpriteArray.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"

@interface GameObjectArray : NSObject
{
	int nextItem_;
}

@property (nonatomic, readonly) CCArray *array;

- (id)initWithCapacity:(int)capacity spriteFrameName:(NSString *)spriteFrameName batchNode:(CCSpriteBatchNode *)batchNode;
- (id)initWithCapacity:(int)capacity
			 className:(NSString *)className
	   spriteFrameName:(NSString *)spriteFrameName
			 batchNode:(CCSpriteBatchNode *)batchNode;
- (id)nextObject;

@end
