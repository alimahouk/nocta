//
//  Constants.h
//  Nocta
//
//  Created by Ali Razzouk on 9/4/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#ifndef SHConstants_h
#define SHConstants_h

/*  --------------------------------------------
    ---------- Runtime Environment -------------
    --------------------------------------------
 */

#define SH_DEVELOPMENT_ENVIRONMENT      NO
#define IS_IOS7                         kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1

/*  ---------------------------------------------
    ------------------- API ---------------------
    ---------------------------------------------
 */

#define SH_DOMAIN                               @"alimahouk.com"

/*  ---------------------------------------------
    ---------- Application Interface ------------
    ---------------------------------------------
 */

#define IS_IPHONE_5                             ( fabs( (double)[ [UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON )

#define RADIANS_TO_DEGREES(radians)             ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle)               ((angle) / 180.0 * M_PI)

#define GAME_LOOP_INTERVAL                      0.35
#define DOT_STANDARD_SIZE                       30
#define DOT_FULL_HEALTH                         100
#define FINGER_ATTRACTION_RANGE                 140
#define HONEYMOON_PERIOD                        7

// Fonts
#define MAIN_FONT_SIZE                          18
#define MIN_MAIN_FONT_SIZE                      15
#define SECONDARY_FONT_SIZE                     12
#define MIN_SECONDARY_FONT_SIZE                 10

typedef enum {
    SHStrobeLightPositionFullScreen = 1,
    SHStrobeLightPositionStatusBar,
    SHStrobeLightPositionNavigationBar
} SHStrobeLightPosition;

typedef enum {
    SHActionMove = 1,
    SHActionAttack,
    SHActionMate,
    SHActionNone
} SHAction;

typedef enum {
    SHConditionSick = 1,
    SHConditionSickContagious,
    SHConditionRogue,
    SHConditionNormal,
    SHConditionStubborn
} SHCondition;

typedef enum {
    SHDotTypeMom = 1,
    SHDotTypeDad
} SHDotType;

#endif