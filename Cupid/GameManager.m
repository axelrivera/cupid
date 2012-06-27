//
//  GameManager.m
//  SpaceViking
//
//  Created by arn on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "MainMenuScene.h"
#import "Scene1.h"

@interface GameManager (Private)

- (NSString *)formatSceneTypeToString:(SceneTypes)sceneID;
- (NSDictionary *)getSoundEffectsListForSceneWithID:(SceneTypes)sceneID;
- (void)loadAudioForSceneWithID:(NSNumber *)sceneIDNumber;
- (void)unloadAudioForSceneWithID:(NSNumber *)sceneIDNumber;

@end

@implementation GameManager

static GameManager *sharedGameManager_ = nil;

@synthesize isMusicON = isMusicON_;
@synthesize isSoundEffectsON = isSoundEffectsON_;
@synthesize hasPlayerDied = hasPlayerDied_;
@synthesize managerSoundState = managerSoundState_;
@synthesize listOfSoundEffectFiles = listOfSoundEffectFiles_;
@synthesize soundEffectsState = soundEffectsState_;

- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"GameManager: Initialized");
        isMusicON_ = YES;
        isSoundEffectsON_ = YES;
        hasPlayerDied_ = NO;
        currentScene_ = kNoSceneUninitialized;
        hasAudioBeenInitialized_ = NO;
        soundEngine_ = nil;
        managerSoundState_ = kAudioManagerUninitialized;
    }
    return self;
}

#pragma mark - Custom Methods

- (CGSize)getDimensionsForcurrentScene
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGSize levelSize = CGSizeZero;
    
    switch (currentScene_) {
		case kMainMenuScene:
        case kGameLevel1:
            levelSize = screenSize;
            break;
        default:
            CCLOG(@"Unknows SceneID, returning default size");
            levelSize = screenSize;
            break;
    }
    return levelSize;
}

- (void)runSceneWithID:(SceneTypes)sceneID
{
    CCLOG(@"Game Manager: Run Scene %d", sceneID);
    
    SceneTypes oldScene = currentScene_;
    id sceneToRun = nil;
    
    switch (sceneID) {
		case kMainMenuScene:
			sceneToRun = [MainMenuScene node];
			break;
        case kGameLevel1:
            sceneToRun = [Scene1 node];
            break;
         default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    
    if (sceneToRun == nil) {
        // Revert back, since no new scene was found
        currentScene_ = oldScene;
        return;
    }
    
    //[self performSelectorInBackground:@selector(loadAudioForSceneWithID:)
    //                       withObject:[NSNumber numberWithInt:currentScene_]];
    
    // Menu Scenes have a value of < 100
//    if (sceneID < 100) {
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//            CGSize screenSize = [CCDirector sharedDirector].winSizeInPixels;
//            if (screenSize.width == 960.0f) {
//                // iPhone 4 Retina
//                [sceneToRun setScaleX:0.9375f];
//                [sceneToRun setScaleY:0.8333f];
//                CCLOG(@"GameManager: Scaling for iPhone 4 (retina)");
//            } else {
//                [sceneToRun setScaleX:0.4688f];
//                [sceneToRun setScaleY:0.4166f];
//                CCLOG(@"GameManager: Scaling for iPhone 3G (non-retina)"); 
//            }
//        }
//    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
    
    //[self performSelectorInBackground:@selector(unloadAudioForSceneWithID:)
    //                       withObject:[NSNumber numberWithInt:oldScene]];
    
    currentScene_ = sceneID;
}

- (void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen
{
    NSURL *urlToOpen = [NSURL URLWithString:@"http://riveralabs.com"];
    if (![[UIApplication sharedApplication] openURL:urlToOpen]) {
        CCLOG(@"%@%@",@"GameScene: Failed to open URL:", [urlToOpen description]);
        [self runSceneWithID:kGameLevel1];
    }
}

- (void)setupAudioEngine
{
    if (hasAudioBeenInitialized_ == YES) {
        return;
    } else {
        hasAudioBeenInitialized_ = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                          selector:@selector(initAudioAsync)
                                                                                            object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

- (void)playBackgroundTrack:(NSString *)trackFilename
{
    // Wait to make sure soundEngine is initialized
    if (managerSoundState_ != kAudioManagerReady && managerSoundState_ != kAudioManagerFailed) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if (managerSoundState_ == kAudioManagerReady || managerSoundState_ == kAudioManagerFailed) {
                break;
            }
            waitCycles++;
        }
    }
    
    if (managerSoundState_ == kAudioManagerReady) {
        if ([soundEngine_ isBackgroundMusicPlaying]) {
            [soundEngine_ stopBackgroundMusic];
        }
        [soundEngine_ preloadBackgroundMusic:trackFilename];
        [soundEngine_ playBackgroundMusic:trackFilename loop:YES];
    }
}

- (void)stopSoundEffect:(ALuint)soundEffectID
{
    if (managerSoundState_ == kAudioManagerReady) {
        [soundEngine_ stopEffect:soundEffectID];
    }
}

- (ALuint)playSoundEffect:(NSString *)soundEffectKey
{
    ALuint soundID = 0;
    if (managerSoundState_ == kAudioManagerReady) {
        NSNumber *isSFXLoaded = [soundEffectsState_ objectForKey:soundEffectKey];
        if ([isSFXLoaded boolValue] == SFX_LOADED) {
            soundID = [soundEngine_ playEffect:[listOfSoundEffectFiles_ objectForKey:soundEffectKey]];
        } else {
            CCLOG(@"GameManager: Sound Effect %@ is not loaded.", soundEffectKey);
        }
    } else {
        CCLOG(@"GameManager: Sound Manager is not ready cannot play %@", soundEffectKey);
    }
    return soundID;
}

#pragma mark - Private Methods

- (NSString *)formatSceneTypeToString:(SceneTypes)sceneID
{
    NSString *result = nil;
    
    switch (sceneID) {
        case kNoSceneUninitialized:
            result = @"kNoSceneUninitialized";
            break;
		case kMainMenuScene:
			result = @"kMainMenuScene";
        case kGameLevel1:
            result = @"kGameLevel1";
            break;
         default:
            [NSException raise:NSGenericException format:@"Unexpected SceneType"];
            break;
    }
    return result;
}

- (NSDictionary *)getSoundEffectsListForSceneWithID:(SceneTypes)sceneID
{
    NSString *fullFileName = @"SoundEffects.plist";
    NSString *plistPath = nil;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"SoundEffects" ofType:@"plist"];
    }
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (plistDictionary == nil) {
        CCLOG(@"Error reading SoundEffect.plist"); // No Plist Dictionary or file found
        return nil;
    }
    
    if (listOfSoundEffectFiles_ == nil || [listOfSoundEffectFiles_ count] < 1) {
        [self setListOfSoundEffectFiles:[[NSMutableDictionary alloc] init]];
        for (NSString *sceneSoundDictionary in plistDictionary) {
            [listOfSoundEffectFiles_ addEntriesFromDictionary:[plistDictionary objectForKey:sceneSoundDictionary]];
        }
        CCLOG(@"Number of SFX files: %d", [listOfSoundEffectFiles_ count]);
    }
    
    if (soundEffectsState_ == nil || [soundEffectsState_ count] < 1) {
        [self setSoundEffectsState:[[NSMutableDictionary alloc] init]];
        for (NSString *SoundEffectKey in listOfSoundEffectFiles_) {
            [soundEffectsState_ setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:SoundEffectKey];
        } 
    }
    
    NSString *sceneIDName = [self formatSceneTypeToString:sceneID];
    NSDictionary *soundEffectsList = [plistDictionary objectForKey:sceneIDName];
    
    return soundEffectsList;
}

- (void)loadAudioForSceneWithID:(NSNumber *)sceneIDNumber
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    
    if (managerSoundState_ == kAudioManagerInitializing) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if (managerSoundState_ == kAudioManagerReady || managerSoundState_ == kAudioManagerFailed) {
                break;
            }
            waitCycles++;
        }
    }
    
    if (managerSoundState_ == kAudioManagerFailed) {
        return; // Nothing to load, CocosDenshion not ready
    }
    
    NSDictionary *soundEffectsToLoad = [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToLoad == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    
    for (NSString *keyString in soundEffectsToLoad) {
        CCLOG(@"\nLoading Audio Key: %@ File: %@", keyString, [soundEffectsToLoad objectForKey:keyString]);
        [soundEngine_ preloadEffect:[soundEffectsToLoad objectForKey:keyString]];
        [soundEffectsState_ setObject:[NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
    }
    [pool release];
}

- (void)unloadAudioForSceneWithID:(NSNumber *)sceneIDNumber
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if (sceneID == kNoSceneUninitialized) {
        return; // Nothing to unload
    }
    
    NSDictionary *soundEffectsToUnload = [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToUnload == nil) {
        CCLOG(@"GameManager: Error reading SoundEffects.plist");
        return;
    }
    
    if (managerSoundState_ == kAudioManagerReady) {
        for (NSString *keyString in soundEffectsToUnload) {
            [soundEffectsState_ setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:keyString];
            [soundEngine_ unloadEffect:keyString];
            CCLOG(@"\nGameManager: Unloading Audio Key: %@ File: %@", keyString, [soundEffectsToUnload objectForKey:keyString]);
        }
    }
    [pool release];
}

#pragma mark - Selector Methods

- (void)initAudioAsync
{
    // Initializes the audio engine asynchronously
    managerSoundState_ = kAudioManagerInitializing;
    
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    // Init audio manager asynchronously as it can take a few seconds
    // the FXPlusMusicIfNoOtherAudio mode will check if user is playing music and disable background music playback
    // if that is the case.
    
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    
    // Wait for the audio manager to initialize
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
        [NSThread sleepForTimeInterval:0.1];
    }
    
    // At this point CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil || audioManager.soundEngine.functioning == NO) {
        CCLOG(@"GameManager: CocosDenshion failed to init, no audio will play.");
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine_ = [SimpleAudioEngine sharedEngine];
        managerSoundState_ = kAudioManagerReady;
        CCLOG(@"GameManager: CocosDenshion is ready");
    }
}

#pragma mark - Singleton Methods

+ (GameManager *)sharedGameManager
{
    @synchronized([GameManager class])
    {
        if (!sharedGameManager_) {
            [[self alloc] init];
        }
        return sharedGameManager_;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized ([GameManager class])
    {
        NSAssert(sharedGameManager_ == nil, @"Attempted to allocate a second instance of the Game Manager Singleton");
        sharedGameManager_ = [super alloc];
        return sharedGameManager_;
    }
    return nil;
}

@end
