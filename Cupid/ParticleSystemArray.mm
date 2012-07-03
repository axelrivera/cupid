//
//  ParticleSystemArray.mm
//  Cupid
//
//  Created by Axel Rivera on 7/2/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "ParticleSystemArray.h"

@implementation ParticleSystemArray
{
	CCArray *_array;
	NSInteger _nextItem;
}

@synthesize array = _array;

- (id)initWithFile:(NSString *)file capacity:(int)capacity parent:(CCNode *)parent
{
	self = [super init];
    if (self) {
        _array = [[CCArray alloc] initWithCapacity:capacity];
        for(NSInteger i = 0; i < capacity; i++) {            
            CCParticleSystemQuad *particleSystem = [CCParticleSystemQuad particleWithFile:file];                       
            [particleSystem stopSystem];
            [parent addChild:particleSystem z:10];
            [_array addObject:particleSystem];
        }
    }
    return self;
}

- (void)dealloc {
    [_array release];
    [super dealloc];
}

- (id)nextParticleSystem
{
    CCParticleSystemQuad *result = [_array objectAtIndex:_nextItem];
    _nextItem++;
    
	if (_nextItem >= [_array count]) {
		_nextItem = 0;
	}
	
	result.scale = 1.0;
    
    return result;
}

@end
