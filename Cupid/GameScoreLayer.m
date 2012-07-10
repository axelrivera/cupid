//
//  GameScoreLayer.m
//  Cupid
//
//  Created by Axel Rivera on 7/8/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "GameScoreLayer.h"

#define kScoreLabelLeftPadding 10.0
#define kScoreLabelTopPadding 10.0

@implementation GameScoreLayer
{
	NSNumberFormatter *_scoreFormatter;
}

@synthesize scoreLabel = _scoreLabel;

- (id)init
{
	self = [super init];
	if (self) {
		_scoreFormatter = [[NSNumberFormatter alloc] init];
		_scoreFormatter.numberStyle = NSNumberFormatterDecimalStyle;
		_scoreFormatter.maximumFractionDigits = 0;
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		_scoreLabel = [[CCLabelBMFont labelWithString:@"0"
											  fntFile:@"GameScoreFont.fnt"] retain];
		
		_scoreLabel.position = ccp(kScoreLabelLeftPadding + _scoreLabel.contentSize.width / 2.0,
								   winSize.height - (kScoreLabelTopPadding + (_scoreLabel.contentSize.height / 2.0)));
		
		[self addChild:_scoreLabel];
	}
	return self;
}

- (void)dealloc
{
	[_scoreLabel release];
	[super dealloc];
}

- (void)setScoreLabelWithInteger:(NSInteger)score
{
	CGSize winSize = [CCDirector sharedDirector].winSize;
	_scoreLabel.string = [_scoreFormatter stringFromNumber:[NSNumber numberWithInteger:score]];
	_scoreLabel.position = ccp(kScoreLabelLeftPadding + _scoreLabel.contentSize.width / 2.0,
							   winSize.height - (kScoreLabelTopPadding + (_scoreLabel.contentSize.height / 2.0)));
}

@end
