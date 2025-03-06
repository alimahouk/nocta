//
//  SHMainViewController.h
//  Nocta
//
//  Created by Ali.cpp on 4/9/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SHMainViewController : UIViewController <ADBannerViewDelegate, UIGestureRecognizerDelegate>
{
    ADBannerView *adView;
    UIView *dotLayer;
    UIView *HUDLayer;
    UIView *menu;
    UILabel *scoreLabel;
    UILabel *menuTitleLabel;
    UILabel *menuScoreLabel;
    UILabel *menuGameplayDurationLabel;
    UILabel *menuTotalDotsLabel;
    UILabel *menuDotsLostLabel;
    UIButton *pauseButton;
    UIButton *replayButton;
    UIButton *nextLevelButton;
    UIButton *menuBackButton;
    UILongPressGestureRecognizer *longPressGesture;
    NSMutableArray *dots;
    NSTimer *gameLoopTimer;
    NSTimer *durationTimer;
    CGPoint userFingerPosition;
    int dotSize;
    int fingerDetectionRange;
    int playDuration;
    int ticksTillConditionChange;
    int level;
    int popLimit;
    int popCount;
    int dotsCreated;
    int dotsLost;
    int userWon;
    BOOL paused;
    BOOL unleashHell;
    BOOL userFingerDown;
}

// Main game loop
- (void)gameLoop;
- (void)pauseLoop;
- (void)startLoop;

// Game mechanics
- (void)startGame;
- (void)pauseGame;
- (void)replay;
- (void)incrementDuration;
- (void)resetStubbornDots;
- (void)spawnDotAtPoint:(CGPoint)point;
- (void)disperse:(NSMutableArray *)dotCoords;
- (void)updatePopCounter;
- (void)showPlusOne;
- (void)playDiseaseAlert;
- (NSString *)gameplayDurationString;

// UI
- (void)showMenu;
- (void)dismissMenu;

// Gestures
- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

