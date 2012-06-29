//
//  GameObject.m
//  SpaceViking
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "ShapeCache.h"

@interface GameObject (Private)

- (void)createBody;
- (void)destroyBody;

@end

@implementation GameObject

@synthesize health = _health;
@synthesize world = _world;
@synthesize body = _body;
@synthesize frameName = _frameName;
@synthesize gameObjectType = _gameObjectType;
@synthesize maxHealth = _maxHealth;
@synthesize screenSize = _screenSize;
@synthesize isActive = _isActive;
@synthesize reactsToScreenBoundaries = _reactsToScreenBoundaries;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName
						world:(b2World *)world
					maxHealth:(NSInteger)maxHealth
{
	self = [super initWithSpriteFrameName:spriteFrameName];
	if (self) {
		//CCLOG(@"GameObject: init");
        _screenSize = [CCDirector sharedDirector].winSize;
        _isActive = YES;
        _gameObjectType = kObjectTypeNone;
		_health = maxHealth;
		_maxHealth = maxHealth;
		_world = world;
		_frameName = [spriteFrameName retain];
	}
	return self;
}

- (void)dealloc
{
	[_frameName release];
	[super dealloc];
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

- (BOOL)dead
{
    return self.maxHealth == 0;
}

- (void)destroy
{    
    self.maxHealth = 0;
    [self stopAllActions];
    [self runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:0.1],
      [CCCallFuncN actionWithTarget:self 
                           selector:@selector(setNodeInvisible:)],
      nil]];
}

- (void)revive
{
    _health = self.maxHealth;
    [self stopAllActions];
    self.visible = YES;
    self.opacity = 255.0;
    [self createBody];
}

- (void)takeHit {
    if (self.health > 0) {
        _health--;
    }
    if (self.health == 0) {
        [self destroy];
    } 
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

#pragma mark - Private Methods

- (void) createBody
{    
    [self destroyBody];
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(self.position.x / PTM_RATIO, self.position.y / PTM_RATIO);
    bodyDef.userData = self;
    _body = _world->CreateBody(&bodyDef);
	NSString *shapeName = [self.frameName stringByDeletingPathExtension];
    [[ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:shapeName scale:self.scale];
    [self setAnchorPoint:[[ShapeCache sharedShapeCache] anchorPointForShape:shapeName]];
}

- (void) destroyBody
{
    if (_body != NULL) {
        _world->DestroyBody(_body);
        _body = NULL;
    }
}

#pragma mark - Selector Methods

- (void)setNodeInvisible:(CCNode *)sender
{
    sender.position = CGPointZero;
    sender.visible = NO;
    [self destroyBody];
}

@end
