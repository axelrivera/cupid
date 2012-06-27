//
//  MonsterBeam.h
//  Cupid
//
//  Created by Axel Rivera on 3/18/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface MonsterBeam : GameCharacter

@property (nonatomic, retain) CCAnimation *firingAnim;
@property (nonatomic, retain) CCAnimation *travelingAnim;

@end
