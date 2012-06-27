//
//  SpriteArray.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "GameObjectArray.h"

@implementation GameObjectArray

@synthesize array = array_;

- (id)initWithCapacity:(int)capacity spriteFrameName:(NSString *)spriteFrameName batchNode:(CCSpriteBatchNode *)batchNode
{
	GameObject *gameObject = [[GameObject alloc] initWithSpriteFrameName:spriteFrameName];
	[self initWithCapacity:capacity
				 className:NSStringFromClass([GameObject class])
		   spriteFrameName:spriteFrameName
				 batchNode:batchNode];
	[gameObject release];
	return self;
}

- (id)initWithCapacity:(int)capacity
			 className:(NSString *)className
	   spriteFrameName:(NSString *)spriteFrameName
			 batchNode:(CCSpriteBatchNode *)batchNode
{
	Class myClass = NSClassFromString(className);
	NSAssert(![myClass isKindOfClass:[GameObject class]], @"Game Object: invalid object");
	
	self = [super init];
	if (self) {
		nextItem_ = 0;
		array_ = [[CCArray alloc] initWithCapacity:capacity];
		for (int i = 0; i < capacity; i++) {
			GameObject *myObject = (GameObject *)[[[myClass alloc] initWithSpriteFrameName:spriteFrameName] autorelease];
			myObject.visible = NO;
			[batchNode addChild:myObject];
			[array_ addObject:myObject];
		}
	}
	return self;
}

- (id)nextObject
{
	id retVal = [array_ objectAtIndex:nextItem_];
	nextItem_++;
	if (nextItem_ >= [array_ count]) {
		nextItem_ = 0;
	}
	return retVal;
}

- (void)dealloc
{
	[array_ release];
	[super dealloc];
}

@end
