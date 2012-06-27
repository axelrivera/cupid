//
//  CCSprite+Extras.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "CCSprite+Extras.h"

@implementation CCSprite (Extras)

+ (CGRect)adjustedBoundingBoxForBoundingBox:(CGRect)boundingBox ofSize:(CGSize)size atStartingPoint:(CGPoint)startingPoint
{	
	float percentXOffset = startingPoint.x / boundingBox.size.width;
	float percentYOffset = startingPoint.y / boundingBox.size.height;
	
	float percentXCrop = 1 - (size.width / boundingBox.size.width);
	float percentYCrop = 1 - (size.height / boundingBox.size.height);

	float xOffset = boundingBox.size.width * percentXOffset;
	float yOffset = boundingBox.size.height * percentYOffset;
	
	float xCropAmount = boundingBox.size.width * percentXCrop;
    float yCropAmount = boundingBox.size.height * percentYCrop;
	
	boundingBox = CGRectMake(boundingBox.origin.x + xOffset,
								  boundingBox.origin.y + yOffset,
								  boundingBox.size.width - xCropAmount,
								  boundingBox.size.height - yCropAmount);
	return boundingBox;
}

@end
