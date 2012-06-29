//
//  GameCharacter.m
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCharacter.h"
#import "GameManager.h"

@implementation GameCharacter

@synthesize characterState = characterState_;

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Custom Methods

- (void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = self.position;
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsForcurrentScene];
    
    float xOffset = 24.0f;
    
    if (currentSpritePosition.x < xOffset) {
        self.position = ccp(xOffset, currentSpritePosition.y);
    } else if (currentSpritePosition.x > (levelSize.width - xOffset)) {
        self.position = ccp(levelSize.width - xOffset, currentSpritePosition.y);
    }
}

@end
