//
//  GameManager.h
//  SpaceViking
//
//  Created by arn on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface GameManager : NSObject
{
    SceneTypes currentScene_;
    BOOL hasAudioBeenInitialized_;
    SimpleAudioEngine *soundEngine_;
}

@property (nonatomic, assign) BOOL isMusicON;
@property (nonatomic, assign) BOOL isSoundEffectsON;
@property (nonatomic, assign) BOOL hasPlayerDied;
@property (nonatomic, assign) GameManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

+ (GameManager *)sharedGameManager;

- (CGSize)getDimensionsForcurrentScene;

- (void)runSceneWithID:(SceneTypes)sceneID;
- (void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen;

- (void)setupAudioEngine;
- (ALuint)playSoundEffect:(NSString *)soundEffectKey;
- (void)stopSoundEffect:(ALuint)soundEffectID;
- (void)playBackgroundTrack:(NSString *)trackFilename;

@end
