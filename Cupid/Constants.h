//
//  Constants.h
//  Cupid
//
//  Created by arn on 10/9/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#define PTM_RATIO 100.0

#define kFPS 60

#define kCupidSpriteZValue 500
#define kCupidSpriteTagValue 0

#define kCupidDefaultXPosition 100.0
#define kCupidDefaultYPosition 150.0

#define kCupidFlyAcceleration 225.0
#define kCupidFallAcceleration 150.0

#define kCupidInvincibleMultiplier 2

#define kCategoryCupid 0x1
#define kCategoryCupidArrow 0x2
#define kCategoryEnemy 0x4
#define kCategoryPowerUp 0x8

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

#define kMaxCloudMoveDuration 10
#define kMinCloudMoveDuration 1

#define kMonsterGreySmallScale 0.75
#define kMonsterGreyMediumScale 1.0
#define kMonsterGreyLargeScale 1.25

#define kMonsterGreySmallMaxHp 1
#define kMonsterGreyMediumMaxHp 2
#define kMonsterGreyLargeMaxHp 3
#define kMonsterBlueMaxHp 4

#define kMonsterSingleHitPoint 2
#define kMonsterGreySmallKillPoints 5
#define kMonsterGreyMediumKillPoints 10
#define kMonsterGreyLargeKillPoints 15
#define kMonsterBlueKillPoints 25

typedef enum {
    kNoSceneUninitialized = 0,
	kMainMenuScene = 1,
    kLevelCompleteScene = 3,
    kGameLevel1 = 101,
} SceneTypes;

typedef enum {
    kLinkTypeDeveloperSiteRiveraLabs,
    kLinkTypeArtistSite,
    kLinkBookSite
} LinkTypes;

#define kCupidShapeName @"cupid_1"
#define kMonsterBlueShapeName @"monster_blue"
#define kMonsterGreyShapeName @"monster_grey_1"
#define kArrowShapeName @"arrow_1"
#define kBeamShapeName @"laserbeam_red"

// Debut Enemy States with Labels (0 = OFF, 1 = ON)
#define ENEMY_STATE_DEBUG 0

/*
 *  Audio Constants
 *
 */

#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized = 0,
    kAudioManagerFailed = 1,
    kAudioManagerInitializing = 2,
    kAudioManagerInitialized = 100,
    kAudioManagerLoading = 200,
    kAudioManagerReady = 300
} GameManagerSoundState;

#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:@#__VA_ARGS__]

// Background Music

// Menu Scenes
//#define BACKGROUND_TRACK_MAIN_MENU @"file1.mp3"

