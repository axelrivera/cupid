//
//  Common.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/15/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Common.h"

float randomValueBetween(float low, float high)
{
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

