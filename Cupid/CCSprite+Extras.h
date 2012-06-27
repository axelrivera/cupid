//
//  CCSprite+Extras.h
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "CCSprite.h"

@interface CCSprite (Extras)

+ (CGRect)adjustedBoundingBoxForBoundingBox:(CGRect)boundingBox ofSize:(CGSize)size atStartingPoint:(CGPoint)startingPoint;

@end
