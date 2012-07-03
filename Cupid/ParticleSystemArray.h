//
//  ParticleSystemArray.h
//  Cupid
//
//  Created by Axel Rivera on 7/2/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParticleSystemArray : NSObject

@property (nonatomic, readonly) CCArray *array;

- (id)initWithFile:(NSString *)file capacity:(NSInteger)capacity parent:(CCNode *)parent;
- (id)nextParticleSystem;

@end
