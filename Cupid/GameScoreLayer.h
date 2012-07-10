//
//  GameScoreLayer.h
//  Cupid
//
//  Created by Axel Rivera on 7/8/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "cocos2d.h"

@interface GameScoreLayer : CCLayer

@property (nonatomic, retain, readonly) CCLabelBMFont *scoreLabel;

- (void)setScoreLabelWithInteger:(NSInteger)score;

@end

