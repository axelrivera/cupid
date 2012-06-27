//
//  GameObject.m
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize isActive = isActive_;
@synthesize reactsToScreenBoundaries = reactsToScreenBoundaries_;
@synthesize screenSize = screenSize_;
@synthesize gameObjectType = gameObjectType_;

- (id) init
{
    self = [super init];
    if (self) {
        //CCLOG(@"GameObject: init");
        screenSize_ = [CCDirector sharedDirector].winSize;
        isActive_ = YES;
        gameObjectType_ = kObjectTypeNone;
    }
    return self;
}

#pragma mark Custom Methods

- (void)changeState:(CharacterStates)newState
{
    //CCLOG(@"GameObject: changeState: method should be overridden.");
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    //CCLOG(@"GameObject: updateStateWithDeltaTime:andListOfGameObjects method should be overridden.");
}

- (CGRect)adjustedBoundingBox
{
    // adjustedBoundingBox method should be overridden.
    return self.boundingBox;
}

- (CCAnimation *)loadPlistForAnimationName:(NSString *)animationName andClassName:(NSString *)className
{
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", className];
    NSString *plistPath = nil;
    
    // Get the path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"]; 
    }
    
    // Read in the plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // Return nil if the dictionary was not found
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil;
    }
    
    // Get just the mini-dictionary for this animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    
    // Return nil if the mini-dictionary was not found
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName: %@", animationName);
        return nil;
    }
    
    // Get the delay value for the animation
    float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelayPerUnit:animationDelay];
    
    // Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache  sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    return animationToReturn;
}

- (void)zombify
{
	[self stopAllActions];
    [self runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:0.0],
      [CCCallFuncN actionWithTarget:self 
                           selector:@selector(setNodeInvisible:)],
      nil]];
}

- (void)reanimate
{
	[self stopAllActions];
    self.visible = YES;
    self.opacity = 255;
}

- (void)destroy
{
	[self stopAllActions];
	self.visible = NO;
	[self removeFromParentAndCleanup:YES];
}

#pragma mark - Selector Actions

- (void)setNodeInvisible:(CCNode *)sender {
    sender.position = CGPointZero;
    sender.visible = NO;
}

@end
