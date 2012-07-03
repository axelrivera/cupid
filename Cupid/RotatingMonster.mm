//
//  BlueMonster.m
//  CupidVsMonsters
//
//  Created by Axel Rivera on 12/13/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RotatingMonster.h"

@implementation RotatingMonster

@synthesize delegate = delegate_;

- (id)init
{
	self = [super init];
	if (self) {
		self.gameObjectType = kRotatingMonsterType;
	}
	return self;
}

- (void)dealloc
{
	delegate_ = nil;
	[super dealloc];
}

#pragma mark - Parent Methods

- (void)changeState:(CharacterStates)newState
{
	[self stopAllActions];
    id action = nil;
    self.characterState = newState;
	
	switch (newState) {
		case kStateSpawning:
		{
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.defaultName]];
			[self revive];
			break;
		}
		case kStateTraveling:
		{
			CGSize winSize = [CCDirector sharedDirector].winSize;
			
			CGPoint startPos;
			ccBezierConfig bezierConfig;
			
			CGPoint pos1 = ccp(winSize.width * 1.3, 
                               randomValueBetween(0, winSize.height * 0.1));
			
            CGPoint cp1 = ccp(randomValueBetween(winSize.width * 0.1, winSize.width * 0.6), 
                              randomValueBetween(0, winSize.height * 0.3));
            
			CGPoint pos2 = ccp(winSize.width * 1.3, 
                               randomValueBetween(winSize.height * 0.9, winSize.height * 1.0));
            
			CGPoint cp2 = ccp(randomValueBetween(winSize.width * 0.1, winSize.width * 0.6), 
                              randomValueBetween(winSize.height * 0.7, winSize.height * 1.0));
			
            if (arc4random() % 2 == 0) {
                startPos = pos1;
                bezierConfig.controlPoint_1 = cp1;
                bezierConfig.controlPoint_2 = cp2;
                bezierConfig.endPosition = pos2;
            } else {
                startPos = pos2;
                bezierConfig.controlPoint_1 = cp2;
                bezierConfig.controlPoint_2 = cp1;
                bezierConfig.endPosition = pos1;
            }
			
			//action = [CCBezierTo actionWithDuration:5.0 bezier:bezierConfig];
			
			[self runAction:
			 [CCRepeatForever actionWithAction:
			  [CCSequence actions:
			   [CCDelayTime actionWithDuration:0.5],
			   [CCRotateBy actionWithDuration:2.0 angle:365.0],
			   [CCCallFunc actionWithTarget:self selector:@selector(shootBeam)],
			   nil]]];
//			float xOffset = [self boundingBox].size.width / 2.0f;
//			float offScreenXPosition = (xOffset * -1) - 1;
			action = [CCSequence actions:
					  [CCBezierTo actionWithDuration:6.0 bezier:bezierConfig],
					  [CCCallFunc actionWithTarget:self selector:@selector(destroy)],
					  nil];
            break;
		}
        default:
		{
			CCLOG(@"Rotating Monster: Unknown state %@", self.characterState);
            break;
		}
    }
    if (action) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
}

#pragma mark - Selector Methods

- (void)shootBeam
{
	CGRect boundingBox = [self boundingBox];
    
    float xPosition = boundingBox.origin.x + (boundingBox.size.width * 0.2f);
	float yPosition = boundingBox.origin.y + (boundingBox.size.height * 0.5f);
	
	CGPoint beamFiringPosition = ccp(xPosition, yPosition);
	[self.delegate createMonsterBeamWithPosition:beamFiringPosition];
}

@end
