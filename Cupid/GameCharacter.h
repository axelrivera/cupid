//
//  GameCharacter.h
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject

@property (nonatomic, assign) CharacterStates characterState;

- (void)checkAndClampSpritePosition;

@end
