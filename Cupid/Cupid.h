//
//  Cupid.h
//  CloudUp
//
//  Created by Axel Rivera on 11/11/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PESprite.h"
#import "SneakyButton.h"

@interface Cupid : PESprite

@property (nonatomic, assign) id <GameplayLayerDelegate> delegate;

@property (nonatomic, assign) BOOL isMoving;

@property (nonatomic, retain) CCAnimation *flappingAnim;
@property (nonatomic, retain) CCAnimation *shootingAnim;

@property (nonatomic, assign) SneakyButton *flyButton;
@property (nonatomic, assign) SneakyButton *attackButton;

@end
