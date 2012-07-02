//
//  SpriteArray.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "GameObjectArray.h"
#import "GameObject.h"

@implementation GameObjectArray
{
	NSInteger _nextItem;
}

@synthesize array = _array;

- (id)initWithCapacity:(NSInteger)capacity
			 className:(NSString *)className
	   spriteFrameName:(NSString *)spriteFrameName
			 batchNode:(CCSpriteBatchNode *)batchNode
				 world:(b2World *)world
			 maxHp:(NSInteger)maxHp
{
	Class myClass = NSClassFromString(className);
	NSAssert(![myClass isKindOfClass:[GameObject class]], @"Game Object: invalid object");
	
	self = [super init];
	if (self) {
		_nextItem = 0;
		_array = [[CCArray alloc] initWithCapacity:capacity];
		for (int i = 0; i < capacity; i++) {
			id myObject = [[[myClass alloc] initWithSpriteFrameName:spriteFrameName world:world maxHp:maxHp] autorelease];
			[myObject setVisible:NO];
			[batchNode addChild:myObject];
			[_array addObject:myObject];
		}
	}
	return self;
}

- (id)nextObject
{
	id retVal = [_array objectAtIndex:_nextItem];
	_nextItem++;
	if (_nextItem >= [_array count]) {
		_nextItem = 0;
	}
	return retVal;
}

- (void)dealloc
{
	[_array release];
	[super dealloc];
}

@end
