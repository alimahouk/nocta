//
//  SHMainViewController.m
//  Nocta
//
//  Created by Ali.cpp on 4/9/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import "SHMainViewController.h"

#import "AppDelegate.h"
#import "SHDot.h"
#import "SHSound.h"
#import "SHState.h"
#import "SHVector.h"

@implementation SHMainViewController

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        dots = [NSMutableArray array];
        
        dotSize = DOT_STANDARD_SIZE + 5;
        fingerDetectionRange = FINGER_ATTRACTION_RANGE + 10;
        playDuration = 0;
        ticksTillConditionChange = 0;
        level = 0;
        popLimit = 15;
        dotsCreated = 2;
        dotsLost = 0;
        userWon = 0;
        paused = NO;
        unleashHell = NO;
        userFingerDown = NO;
    }
    
    return self;
}

- (void)loadView
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    UIView *contentView = [[UIView alloc] initWithFrame:appDelegate.screenBounds];
    contentView.backgroundColor = [UIColor whiteColor];
    
    dotLayer = [[UIView alloc] initWithFrame:appDelegate.screenBounds];
    HUDLayer = [[UIView alloc] initWithFrame:appDelegate.screenBounds];
    
    menu = [[UIView alloc] initWithFrame:appDelegate.screenBounds];
    menu.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    menu.alpha = 0.0;
    menu.hidden = YES;
    
    UIView *menuStrip = [[UIView alloc] initWithFrame:CGRectMake(0, appDelegate.screenBounds.size.height / 2 - 100, appDelegate.screenBounds.size.width, 200)];
    menuStrip.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(appDelegate.screenBounds.size.width / 2 - 35, 20, 70, 20)];
    scoreLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    scoreLabel.textColor = [UIColor grayColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, appDelegate.screenBounds.size.height / 2 - 180, appDelegate.screenBounds.size.width - 40, 32)];
    menuTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    menuTitleLabel.textColor = [UIColor orangeColor];
    menuTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    menuScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(appDelegate.screenBounds.size.width / 2 - 35, 70, 70, 20)];
    menuScoreLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    menuScoreLabel.textColor = [UIColor grayColor];
    menuScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    menuGameplayDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(appDelegate.screenBounds.size.width / 2, appDelegate.screenBounds.size.height - 40, appDelegate.screenBounds.size.width / 2 - 20, 20)];
    menuGameplayDurationLabel.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    menuGameplayDurationLabel.textColor = [UIColor grayColor];
    menuGameplayDurationLabel.textAlignment = NSTextAlignmentRight;
    
    menuTotalDotsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, appDelegate.screenBounds.size.height - 80, appDelegate.screenBounds.size.width / 2, 20)];
    menuTotalDotsLabel.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    menuTotalDotsLabel.textColor = [UIColor grayColor];
    
    menuDotsLostLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, appDelegate.screenBounds.size.height - 40, appDelegate.screenBounds.size.width / 2, 20)];
    menuDotsLostLabel.font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    menuDotsLostLabel.textColor = [UIColor grayColor];
    
    replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replayButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [replayButton setTitle:NSLocalizedString(@"REPLAY", nil) forState:UIControlStateNormal];
    [replayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [replayButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    replayButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    replayButton.frame = CGRectMake(20, appDelegate.screenBounds.size.height / 2 - DOT_STANDARD_SIZE - 20, appDelegate.screenBounds.size.width - 40, DOT_STANDARD_SIZE);
    replayButton.alpha = 0.0;
    
    nextLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextLevelButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [nextLevelButton setTitle:NSLocalizedString(@"NEXT_LEVEL", nil) forState:UIControlStateNormal];
    [nextLevelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextLevelButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    nextLevelButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    nextLevelButton.frame = CGRectMake(20, appDelegate.screenBounds.size.height / 2 + 20, appDelegate.screenBounds.size.width - 40, DOT_STANDARD_SIZE);
    nextLevelButton.alpha = 0.0;
    
    menuBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBackButton addTarget:self action:@selector(dismissMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuBackButton setTitle:NSLocalizedString(@"BACK_TO_GAME", nil) forState:UIControlStateNormal];
    [menuBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    menuBackButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    menuBackButton.frame = CGRectMake(20, appDelegate.screenBounds.size.height / 2 + 20, appDelegate.screenBounds.size.width - 40, DOT_STANDARD_SIZE);
    menuBackButton.alpha = 0.0;
    
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton addTarget:self action:@selector(pauseGame) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setTitle:@"II" forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    pauseButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    pauseButton.frame = CGRectMake(appDelegate.screenBounds.size.width - DOT_STANDARD_SIZE - 20, 20, DOT_STANDARD_SIZE, DOT_STANDARD_SIZE);
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    adView.delegate = self;
    adView.alpha = 0.0;
    adView.hidden = YES;
    
    [menu addSubview:menuStrip];
    [menu addSubview:menuTitleLabel];
    [menu addSubview:menuScoreLabel];
    [menu addSubview:menuGameplayDurationLabel];
    [menu addSubview:menuTotalDotsLabel];
    [menu addSubview:menuDotsLostLabel];
    [menu addSubview:replayButton];
    [menu addSubview:nextLevelButton];
    [menu addSubview:menuBackButton];
    [menu addSubview:adView];
    [HUDLayer addSubview:scoreLabel];
    [HUDLayer addSubview:pauseButton];
    [HUDLayer addSubview:menu];
    [contentView addSubview:dotLayer];
    [contentView addSubview:HUDLayer];
    
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    longPressGesture.minimumPressDuration = 0.001;
    longPressGesture.delegate = self;
    [contentView addGestureRecognizer:longPressGesture];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self startGame];
}

#pragma mark -
#pragma mark Main game loop

- (void)gameLoop
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for ( int i = 0; i < dots.count; i++ )
        {
            SHDot *dot = [dots objectAtIndex:i];
            SHVector *conditionVector = [[SHVector alloc] init];
            SHVector *moveVector = [[SHVector alloc] init];
            
            SHState *oldMoveState = dot.moveStates[0];
            SHState *lastMoveState = dot.moveStates[1];
            BOOL useMoveBias = YES;
            
            SHState *oldConditionState = dot.conditionStates[0];
            SHState *lastConditionState = dot.conditionStates[1];
            BOOL useConditionBias = YES;
            
            SHCondition currentCondition = dot.condition;
            int steps = 1;
            int stepSize = arc4random_uniform(10) + 5;
            int distance = stepSize * steps;
            int x = dot.frame.origin.x;
            int y = dot.frame.origin.y;
            int newX = 0;
            int newY = 0;
            
            SHVector *lastConditionV = (SHVector *)lastConditionState.value;
            SHVector *oldConditionV;
            
            dot.age++;
            dot.ticksTillConditionChange--;
            
            if ( currentCondition == SHConditionSick || currentCondition == SHConditionSickContagious )
            {
                dot.health -= lastConditionV.magnitude / 10; // Take some damage.
            }
            
            if ( dot.health <= 0 ) // The dot is dead.
            {
                [dots removeObjectAtIndex:i];
                i--;
                dotsLost++;
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [dot die];
                    [self updatePopCounter];
                });
                
                continue;
            }
            
            if ( dot.ticksTillConditionChange <= 0 &&
                unleashHell &&
                !dot.hooked &&
                dot.age > 13 )
            {
                if ( (lastConditionState.state == SHConditionSick || lastConditionState.state == SHConditionSickContagious) &&
                    ticksTillConditionChange <= 0 )
                {
                    if ( (oldConditionState.state == SHConditionSick || oldConditionState.state == SHConditionSickContagious) &&
                        (lastConditionState.state == SHConditionSick || lastConditionState.state == SHConditionSickContagious) )
                    {
                        // After being ill twice, it's likely for a dot to go rogue.
                        int decision = arc4random_uniform(4);
                        
                        if ( decision == 0 )
                        {
                            dot.condition = SHConditionSick;
                        }
                        else if ( decision == 1 )
                        {
                            dot.condition = SHConditionSickContagious;
                        }
                        else
                        {
                            dot.condition = SHConditionNormal;
                        }
                    }
                    else if ( oldConditionState.state == SHConditionSick || lastConditionState.state == SHConditionSickContagious )
                    {
                        oldConditionV = (SHVector *)lastConditionState.value;
                        
                        if ( oldConditionState.biased && lastConditionState.biased )
                        {
                            useConditionBias = NO;
                        }
                        else if ( oldConditionState.biased || lastConditionState.biased )
                        {
                            useConditionBias = arc4random_uniform(1);
                        }
                    }
                    else if ( lastConditionState.state == SHConditionSick || lastConditionState.state == SHConditionSickContagious )
                    {
                        if ( lastConditionState.biased )
                        {
                            useConditionBias = NO;
                        }
                        else
                        {
                            useConditionBias = arc4random_uniform(1);
                        }
                    }
                    else
                    {
                        useConditionBias = arc4random_uniform(1);
                    }
                }
                else if ( lastConditionState.state == SHConditionRogue && ticksTillConditionChange <= 0 )
                {
                    if ( oldConditionState.state == SHConditionRogue && lastConditionState.state == SHConditionRogue )
                    {
                        dot.condition = SHConditionNormal;
                    }
                    else if ( oldConditionState.state == SHConditionRogue )
                    {
                        oldConditionV = (SHVector *)lastConditionState.value;
                        
                        if ( oldConditionState.biased && lastConditionState.biased )
                        {
                            useConditionBias = NO;
                        }
                        else if ( oldConditionState.biased || lastConditionState.biased )
                        {
                            useConditionBias = arc4random_uniform(1);
                        }
                    }
                    else if ( lastConditionState.state == SHConditionRogue )
                    {
                        if ( lastConditionState.biased )
                        {
                            useConditionBias = NO;
                        }
                        else
                        {
                            useConditionBias = arc4random_uniform(1);
                        }
                    }
                    else
                    {
                        useConditionBias = arc4random_uniform(1);
                    }
                }
                else // Dot's been normal for a while.
                {
                    dot.condition = arc4random_uniform(3) + 1;
                }
            }
            else
            {
                if ( !unleashHell && dot.ticksTillConditionChange <= 0 ) // Below the hell limit. Return dots to normal.
                {
                    dot.condition = SHConditionNormal;
                }
            }
            
            if ( dot.condition != currentCondition &&
                dot.condition != SHConditionNormal &&
                dot.condition != SHConditionStubborn )
            {
                ticksTillConditionChange = arc4random_uniform(20) + 20;
                
                if ( useConditionBias )
                {
                    int lastConditionSeverity = lastConditionV.magnitude;
                    int lastVBias = 0;
                    
                    if ( lastConditionSeverity > 50 )
                    {
                        lastVBias = 1;
                    }
                    else
                    {
                        lastVBias = -1;
                    }
                    
                    if ( oldConditionV )
                    {
                        int oldConditionSeverity = oldConditionV.magnitude;
                        int oldVBias = 0;
                        
                        if ( oldConditionSeverity > DOT_FULL_HEALTH / 2 )
                        {
                            oldVBias = 1;
                        }
                        else
                        {
                            oldVBias = -1;
                        }
                        
                        int oldVBiasMagnitude = abs((DOT_FULL_HEALTH / 2) - oldConditionSeverity);
                        int lastVBiasMagnitude = abs((DOT_FULL_HEALTH / 2) - lastConditionSeverity);
                        
                        if ( oldVBiasMagnitude > lastVBiasMagnitude )
                        {
                            if ( oldVBias == -1 )
                            {
                                conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH / 2) + 10;
                            }
                            else if ( oldVBias == 1 )
                            {
                                conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH - 30) + (DOT_FULL_HEALTH / 2);
                            }
                        }
                        else
                        {
                            if ( lastVBias == -1 )
                            {
                                conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH / 2) + 10;
                            }
                            else if ( lastVBias == 1 )
                            {
                                conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH - 30) + (DOT_FULL_HEALTH / 2);
                            }
                        }
                    }
                    else
                    {
                        if ( lastVBias == -1 )
                        {
                            conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH / 2) + 10;
                        }
                        else if ( lastVBias == 1 )
                        {
                            conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH - 30) + (DOT_FULL_HEALTH / 2);
                        }
                    }
                }
                else
                {
                    conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH - 30) + 10;
                }
            }
            else
            {
                conditionVector.magnitude = arc4random_uniform(DOT_FULL_HEALTH - 30) + 10; // Normal dot. This value doesn't matter.
            }
            
            if ( userFingerDown &&
                dot.condition == SHConditionNormal )
            {
                // Find the distance between the dot & the finger.
                float deltaX =  (userFingerPosition.x + (dotSize / 2)) - (dot.frame.origin.x + (dotSize / 2));
                float deltaY =  (userFingerPosition.y + (dotSize / 2)) - (dot.frame.origin.y + (dotSize / 2));
                float range = sqrtf((deltaX * deltaX) + (deltaY * deltaY));
                
                if ( range <= fingerDetectionRange )
                {
                    int FOV = arc4random_uniform(20) + 5;
                    
                    dot.orientation = -1 * RADIANS_TO_DEGREES(atan2f(deltaY, deltaX)); // atan2 reverses the quadrants. Times -1 to fix it.
                    dot.orientation = (dot.orientation > 0.0 ? dot.orientation : (360.0 + dot.orientation)); // Correct discontinuity from -180 to 180 into 0 to 360.
                    dot.ticksSinceOrientationChange++;
                    dot.hooked = YES;
                    
                    moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
                    stepSize = 70; // Large step size.
                    distance = stepSize * steps; // Update distance.
                    
                    newX = fabs(floor(distance * cos(DEGREES_TO_RADIANS(dot.orientation))));
                    newY = fabs(floor(distance * sin(DEGREES_TO_RADIANS(dot.orientation))));
                    
                    useMoveBias = NO;
                }
                else
                {
                    dot.hooked = NO;
                }
            }
            else
            {
                dot.hooked = NO;
            }
            
            if ( !dot.hooked )
            {
                if ( dot.ticksSinceOrientationChange > 10 )
                {
                    int FOV = arc4random_uniform(20) + 5;
                    
                    int newOrientationMin = abs(dot.orientation - FOV);
                    int newOrientationMax = abs(dot.orientation + FOV);
                    
                    if ( lastMoveState.state == SHActionMove )
                    {
                        SHVector *lastMoveV = (SHVector *)lastMoveState.value;
                        SHVector *oldMoveV;
                        
                        if ( oldMoveState.state == SHActionMove )
                        {
                            oldMoveV = (SHVector *)lastMoveState.value;
                            
                            if ( oldMoveState.biased && lastMoveState.biased )
                            {
                                useMoveBias = NO;
                            }
                            else if ( oldMoveState.biased || lastMoveState.biased )
                            {
                                useMoveBias = arc4random_uniform(1);
                            }
                        }
                        else
                        {
                            useMoveBias = arc4random_uniform(1);
                        }
                        
                        if ( useMoveBias )
                        {
                            int lastVCenter = fabs(lastMoveV.FOV.x - lastMoveV.FOV.y) / 2;
                            int lastVBias = 0;
                            
                            if ( lastMoveV.angle > lastVCenter )
                            {
                                lastVBias = 1;
                            }
                            else if ( lastMoveV.angle < lastVCenter )
                            {
                                lastVBias = -1;
                            }
                            
                            if ( oldMoveV )
                            {
                                int oldVCenter = fabs(oldMoveV.FOV.x - oldMoveV.FOV.y) / 2;
                                int oldVBias = 0;
                                
                                if ( oldMoveV.angle > oldVCenter )
                                {
                                    oldVBias = 1;
                                }
                                else if ( oldMoveV.angle < oldVCenter )
                                {
                                    oldVBias = -1;
                                }
                                
                                int oldVBiasMagnitude = fabs(oldVCenter - oldMoveV.angle);
                                int lastVBiasMagnitude = fabs(lastVCenter - lastMoveV.angle);
                                
                                if ( oldVBiasMagnitude > lastVBiasMagnitude )
                                {
                                    if ( oldVBias == -1 )
                                    {
                                        FOV = arc4random_uniform(oldVCenter) + oldMoveV.FOV.x;
                                        
                                        newOrientationMin = abs(dot.orientation - FOV);
                                        newOrientationMax = abs(dot.orientation + FOV);
                                    }
                                    else if ( oldVBias == 1 )
                                    {
                                        FOV = arc4random_uniform(oldMoveV.FOV.y) + oldVCenter;
                                        
                                        newOrientationMin = abs(dot.orientation - FOV);
                                        newOrientationMax = abs(dot.orientation + FOV);
                                    }
                                }
                                else
                                {
                                    if ( lastVBias == -1 )
                                    {
                                        FOV = arc4random_uniform(lastVCenter) + lastMoveV.FOV.x;
                                        
                                        newOrientationMin = abs(dot.orientation - FOV);
                                        newOrientationMax = abs(dot.orientation + FOV);
                                    }
                                    else if ( lastVBias == 1 )
                                    {
                                        FOV = arc4random_uniform(lastMoveV.FOV.y) + lastVCenter;
                                        
                                        newOrientationMin = abs(dot.orientation - FOV);
                                        newOrientationMax = abs(dot.orientation + FOV);
                                    }
                                }
                            }
                            else
                            {
                                if ( lastVBias == -1 )
                                {
                                    FOV = arc4random_uniform(lastVCenter) + lastMoveV.FOV.x;
                                    
                                    newOrientationMin = abs(dot.orientation - FOV);
                                    newOrientationMax = abs(dot.orientation + FOV);
                                }
                                else if ( lastVBias == 1 )
                                {
                                    FOV = arc4random_uniform(lastMoveV.FOV.y) + lastVCenter;
                                    
                                    newOrientationMin = abs(dot.orientation - FOV);
                                    newOrientationMax = abs(dot.orientation + FOV);
                                }
                            }
                        }
                    }
                    
                    dot.orientation = arc4random_uniform(newOrientationMax - newOrientationMin) + newOrientationMin;
                    dot.ticksSinceOrientationChange = 0;
                    moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
                    
                    newX = floor(distance * cos(DEGREES_TO_RADIANS(dot.orientation)));
                    newY = floor(distance * sin(DEGREES_TO_RADIANS(dot.orientation)));
                }
                else
                {
                    newX = ceil(distance * cos(DEGREES_TO_RADIANS(dot.orientation))) + arc4random_uniform(20) + 10;
                    newY = ceil(distance * sin(DEGREES_TO_RADIANS(dot.orientation))) + arc4random_uniform(20) + 10;
                    
                    dot.ticksSinceOrientationChange++;
                }
            }
            
            int actualOrientation = dot.orientation;
            
            while ( actualOrientation > 360 )
            {
                actualOrientation -= 360;
            }
            
            if ( actualOrientation < 90 || actualOrientation > 270 )
            {
                x += newX;
            }
            else
            {
                x -= newX;
            }
            
            if ( actualOrientation < 180 && actualOrientation > 0 )
            {
                y -= newY;
            }
            else
            {
                y += newY;
            }
            
            // Don't let the dot go outside the screen edges.
            if ( x >= appDelegate.screenBounds.size.width - dot.frame.size.width ||
                   x <= 0 ||
                   y >= appDelegate.screenBounds.size.height - dot.frame.size.height ||
                   y <= 0)
            {
                // Backtrack.
                if ( actualOrientation < 90 || actualOrientation > 270 )
                {
                    x -= newX + arc4random_uniform(20);
                }
                else
                {
                    x += newX + arc4random_uniform(20);
                }
                
                if ( actualOrientation < 180 && actualOrientation > 0 )
                {
                    y += newY + arc4random_uniform(20);
                }
                else
                {
                    y -= newY + arc4random_uniform(20);
                }
                
                // Reverse direction.
                dot.orientation += 150;
                dot.ticksSinceOrientationChange = 0;
                
                int FOV = arc4random_uniform(20) + 5;
                
                moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
            }
            
            for ( int j = 0; j < dots.count; j++ )
            {
                if ( j != i )
                {
                    SHDot *otherDot = [dots objectAtIndex:j];
                    
                    int x_target = otherDot.frame.origin.x;
                    int y_target = otherDot.frame.origin.y;
                    
                    // Find the distance between the centers of the dots & the finger.
                    float otherDotDeltaX =  (dot.frame.origin.x + (dotSize / 2)) - (x_target + (dotSize / 2));
                    float otherDotDeltaY =  (dot.frame.origin.y + (dotSize / 2)) - (y_target + (dotSize / 2));
                    float otherDotRange = sqrtf((otherDotDeltaX * otherDotDeltaX) + (otherDotDeltaY * otherDotDeltaY));
                    
                    // COLLISION DETECTION
                    if ( x_target < (x + dot.frame.size.width) && (x_target + dot.frame.size.width) > x &&
                           y_target < (y + dot.frame.size.height) && (y_target + dot.frame.size.height) > y ) // Note: The condition inside the brackets checks for interlaps.
                    {
                        // Reverse direction.
                        dot.orientation += 150;
                        dot.ticksSinceOrientationChange = 0;
                        
                        int FOV = arc4random_uniform(20) + 5;
                        
                        moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
                        
                        if ( !(dot.hooked &&
                            dot.condition == SHConditionNormal &&
                            otherDot.condition == SHConditionNormal &&
                            ((dot.type == SHDotTypeDad && otherDot.type == SHDotTypeMom) ||
                             (dot.type == SHDotTypeMom && otherDot.type == SHDotTypeDad))) )
                        {
                            if ( (dot.type == SHDotTypeDad && otherDot.type == SHDotTypeDad) ||
                                (dot.type == SHDotTypeMom && otherDot.type == SHDotTypeMom) ) // Dots of the same gender might attack one another.
                            {
                                
                            }
                            
                            if ( dot.condition == SHConditionRogue )
                            {
                                otherDot.health -= conditionVector.magnitude / 10; // Take some damage.
                            }
                            else if ( dot.condition == SHConditionSickContagious )
                            {
                                // Dot gets infected.
                                SHState *newConditionState = [[SHState alloc] initWithState:dot.condition value:conditionVector];
                                newConditionState.biased = useConditionBias;
                                
                                otherDot.condition = dot.condition;
                                otherDot.conditionStates[0] = lastConditionState;
                                otherDot.conditionStates[1] = newConditionState;
                            }
                        }
                    }
                    else
                    {
                        if ( dot.condition == SHConditionRogue && otherDotRange <= FINGER_ATTRACTION_RANGE ) // Rogue dots will chase the nearby dots.
                        {
                            otherDotDeltaX = (x_target + (dotSize / 2)) - (dot.frame.origin.x + (dotSize / 2));
                            otherDotDeltaY = (y_target + (dotSize / 2)) - (dot.frame.origin.y + (dotSize / 2));
                            
                            int FOV = arc4random_uniform(20) + 5;
                            
                            dot.orientation = -1 * RADIANS_TO_DEGREES(atan2f(otherDotDeltaY, otherDotDeltaX)); // atan2 reverses the quadrants. Times -1 to fix it.
                            dot.orientation = (dot.orientation > 0.0 ? dot.orientation : (360.0 + dot.orientation)); // Correct discontinuity from -180 to 180 into 0 to 360.
                            
                            moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
                            
                            newX = fabs(floor(distance * cos(DEGREES_TO_RADIANS(dot.orientation))));
                            newY = fabs(floor(distance * sin(DEGREES_TO_RADIANS(dot.orientation))));
                            
                            int actualOrientation = dot.orientation;
                            
                            while ( actualOrientation > 360 )
                            {
                                actualOrientation -= 360;
                            }
                            
                            if ( actualOrientation < 90 || actualOrientation > 270 )
                            {
                                x += newX;
                            }
                            else
                            {
                                x -= newX;
                            }
                            
                            if ( actualOrientation < 180 && actualOrientation > 0 )
                            {
                                y -= newY;
                            }
                            else
                            {
                                y += newY;
                            }
                            
                            // Don't let the dot go outside the screen edges.
                            if ( x >= appDelegate.screenBounds.size.width - dot.frame.size.width ||
                                x <= 0 ||
                                y >= appDelegate.screenBounds.size.height - dot.frame.size.height ||
                                y <= 0)
                            {
                                // Backtrack.
                                if ( actualOrientation < 90 || actualOrientation > 270 )
                                {
                                    x -= newX + arc4random_uniform(20);
                                }
                                else
                                {
                                    x += newX + arc4random_uniform(20);
                                }
                                
                                if ( actualOrientation < 180 && actualOrientation > 0 )
                                {
                                    y += newY + arc4random_uniform(20);
                                }
                                else
                                {
                                    y -= newY + arc4random_uniform(20);
                                }
                                
                                // Reverse direction.
                                dot.orientation += 150;
                                dot.ticksSinceOrientationChange = 0;
                                
                                int FOV = arc4random_uniform(20) + 5;
                                
                                moveVector.FOV = CGPointMake(abs(dot.orientation - FOV), abs(dot.orientation + FOV));
                            }
                        }
                    }
                    
                    if ( dot.hooked && otherDot.hooked &&
                        ((dot.type == SHDotTypeDad && otherDot.type == SHDotTypeMom) ||
                         (dot.type == SHDotTypeMom && otherDot.type == SHDotTypeDad)) )
                    {
                        if ( otherDotRange <= 40 ) // They're close enough.
                        {
                            if ( otherDot.collidedDotID == -1 ) // To prevent 2 dots from spawning.
                            {
                                otherDot.collidedDotID = i; // Bind them together.
                                dot.collidedDotID = i;
                                
                                // Disperse the parents to make things more challenging.
                                NSMutableArray *temp = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:dot.frame.origin],
                                                        [NSValue valueWithCGPoint:otherDot.frame.origin], nil];
                                
                                [self disperse:temp];
                                
                                CGPoint final_1 = [temp[0] CGPointValue];
                                CGPoint final_2 = [temp[1] CGPointValue];
                                
                                x = final_1.x;
                                y = final_1.y;
                                
                                dotsCreated++;
                                
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                    [UIView animateWithDuration:GAME_LOOP_INTERVAL delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                        otherDot.frame = CGRectMake(final_2.x, final_2.y, dotSize, dotSize);
                                    } completion:^(BOOL finished){
                                        
                                    }];
                                    
                                    [self spawnDotAtPoint:dot.frame.origin];
                                });
                                
                                otherDot.condition = SHConditionStubborn;
                                dot.condition = SHConditionStubborn;
                            }
                        }
                    }
                    
                    [dots setObject:otherDot atIndexedSubscript:j];
                }
            }
            
            moveVector.origin = CGPointMake(x, y);
            moveVector.magnitude = distance;
            moveVector.angle = dot.orientation;
            
            SHState *newMoveState = [[SHState alloc] initWithState:SHActionMove value:moveVector];
            newMoveState.biased = useMoveBias;
            
            dot.moveStates[0] = lastMoveState;
            dot.moveStates[1] = newMoveState;
            
            if ( dot.ticksTillConditionChange <= 0 )
            {
                SHVector *lastV = (SHVector *)lastConditionState.value;
                int lastSeverity = lastV.magnitude;
                
                if ( dot.condition == SHConditionNormal ) // Normal dots maintain state for a longer time.
                {
                    dot.ticksTillConditionChange = arc4random_uniform(23) + 20;
                }
                else
                {
                    dot.ticksTillConditionChange = arc4random_uniform(23) + 12;
                    
                    if ( dot.condition == SHConditionSick || dot.condition == SHConditionSickContagious )
                    {
                        [self playDiseaseAlert];
                    }
                }
                
                if ( currentCondition != dot.condition ||
                    (currentCondition == dot.condition && lastSeverity != conditionVector.magnitude) ) // Dot condition changed.
                {
                    SHState *newConditionState = [[SHState alloc] initWithState:dot.condition value:conditionVector];
                    newConditionState.biased = useConditionBias;
                    
                    dot.conditionStates[0] = lastConditionState;
                    dot.conditionStates[1] = newConditionState;
                }
            }
            
            [dots setObject:dot atIndexedSubscript:i];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:GAME_LOOP_INTERVAL delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    dot.frame = CGRectMake(x, y, dotSize, dotSize);
                } completion:^(BOOL finished){
                    
                }];
            });
        }
        
        ticksTillConditionChange--;
    });
}

- (void)pauseLoop
{
    [durationTimer invalidate];
    [gameLoopTimer invalidate];
    
    durationTimer = nil;
    gameLoopTimer = nil;
}

- (void)startLoop
{
    if ( paused )
    {
        return;
    }
    
    if ( durationTimer )
    {
        [durationTimer invalidate];
    }
    
    if ( gameLoopTimer )
    {
        [gameLoopTimer invalidate];
    }
    
    gameLoopTimer = [NSTimer timerWithTimeInterval:GAME_LOOP_INTERVAL target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:gameLoopTimer forMode:NSRunLoopCommonModes];
    
    durationTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(incrementDuration) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:durationTimer forMode:NSRunLoopCommonModes];
}

#pragma mark -
#pragma mark Game mechanics

- (void)startGame
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    playDuration = 0;
    ticksTillConditionChange = 0;
    level++;
    popLimit += 5;
    dotsCreated = 2;
    dotsLost = 0;
    paused = NO;
    userWon = NO;
    unleashHell = NO;
    userFingerDown = NO;
    fingerDetectionRange -= 10;
    dotSize -= 5;
    
    [[dotLayer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [dots removeAllObjects];
    
    [self dismissMenu];
    
    SHDot *dot1 = [[SHDot alloc] initWithFrame:CGRectMake(appDelegate.screenBounds.size.width / 2 - 40, appDelegate.screenBounds.size.height / 2, dotSize, dotSize)];
    dot1.type = SHDotTypeDad;
    dot1.orientation = arc4random_uniform(360);
    dot1.enabled = NO;
    
    SHDot *dot2 = [[SHDot alloc] initWithFrame:CGRectMake(appDelegate.screenBounds.size.width / 2 + 40, appDelegate.screenBounds.size.height / 2, dotSize, dotSize)];
    dot2.type = SHDotTypeMom;
    dot2.orientation = arc4random_uniform(360);
    dot2.enabled = NO;
    
    [dots addObject:dot1];
    [dots addObject:dot2];
    
    [dotLayer addSubview:dot1];
    [dotLayer addSubview:dot2];
    
    popCount = (int)dots.count;
    
    [self updatePopCounter];
    [self startLoop];
}

- (void)pauseGame
{
    userWon = 0;
    
    [self showMenu];
}

- (void)replay
{
    level--;
    popLimit -= 5;
    dotSize += 5;
    fingerDetectionRange += 10;
    
    [self dismissMenu];
    [self startGame];
}

- (void)incrementDuration
{
    playDuration++;
}

- (void)resetStubbornDots
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for ( int i = 0; i < dots.count; i++ )
        {
            SHDot *dot = [dots objectAtIndex:i];
            dot.hooked = NO;
            dot.collidedDotID = -1;
            
            if ( dot.condition == SHConditionStubborn )
            {
                dot.condition = SHConditionNormal;
            }
            
            [dots setObject:dot atIndexedSubscript:i];
        }
    });
}

- (void)spawnDotAtPoint:(CGPoint)point
{
    SHDot *dot = [[SHDot alloc] initWithFrame:CGRectMake(point.x, point.y, dotSize, dotSize)];
    dot.type = arc4random_uniform(2) + 1;
    dot.orientation = arc4random_uniform(360);
    dot.condition = SHConditionStubborn; // Spawn as stubborn so it moves away while the user's finger is still down.
    dot.enabled = NO;
    
    [dots addObject:dot];
    [dotLayer addSubview:dot];
    [SHSound playSoundEffect:arc4random_uniform(3) + 1];
    [self updatePopCounter];
    
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        scoreLabel.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            scoreLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                scoreLabel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
    
    NSMutableArray *temp = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:dot.frame.origin]];
    
    [self disperse:temp];
    [self showPlusOne];
    
    CGPoint final = [temp[0] CGPointValue];
    
    [UIView animateWithDuration:GAME_LOOP_INTERVAL delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        dot.frame = CGRectMake(final.x, final.y, dotSize, dotSize);
    } completion:^(BOOL finished){
        
    }];
}

- (void)disperse:(NSMutableArray *)dotCoords
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    for ( int i = 0; i < dotCoords.count; i++ )
    {
        CGPoint coord = [[dotCoords objectAtIndex:i] CGPointValue];
        
        int burstX = (int)arc4random_uniform(201) + 100;
        int burstY = (int)arc4random_uniform(201) + 100;
        int negativeX = arc4random_uniform(2);
        int negativeY = arc4random_uniform(2);
        
        if ( negativeX )
        {
            burstX *= -1;
        }
        
        if ( negativeY )
        {
            burstY *= -1;
        }
        
        int finalX = coord.x + burstX;
        int finalY = coord.y + burstY;
        
        // Make sure it doesn't go off screen.
        if ( finalX > appDelegate.screenBounds.size.width - dotSize )
        {
            finalX -= 200;
        }
        
        if ( finalX < 0 )
        {
            finalX += 200;
        }
        
        if ( finalY > appDelegate.screenBounds.size.height - dotSize )
        {
            finalY -= 200;
        }
        
        if ( finalY < 0 )
        {
            finalY += 200;
        }
        
        coord = CGPointMake(finalX, finalY);
        
        [dotCoords setObject:[NSValue valueWithCGPoint:coord] atIndexedSubscript:i];
    }
}

- (void)updatePopCounter
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    scoreLabel.text = [NSString stringWithFormat:@"%d / %d", (int)dots.count, popLimit];
    menuScoreLabel.text = scoreLabel.text;
    menuTotalDotsLabel.text = [NSString stringWithFormat:@"dots born: %@", [formatter stringFromNumber:[NSNumber numberWithLong:dotsCreated]]];
    menuDotsLostLabel.text = [NSString stringWithFormat:@"dots lost: %@", [formatter stringFromNumber:[NSNumber numberWithLong:dotsLost]]];
    
    if ( dots.count > popCount ) // New dot was added.
    {
        scoreLabel.textColor = [UIColor greenColor];
    }
    else if ( dots.count < popCount ) // Dot was lost.
    {
        scoreLabel.textColor = [UIColor redColor];
    }
    
    long double delayInSeconds = 1.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        scoreLabel.textColor = [UIColor grayColor];
    });
    
    if ( dots.count >= HONEYMOON_PERIOD )
    {
        unleashHell = YES;
    }
    else
    {
        unleashHell = NO;
    }
    
    if ( dots.count <= 1 ) // Game over.
    {
        userWon = -1;
        
        [self showMenu];
        
        for ( int i = 0; i < dots.count; i++ )
        {
            SHDot *dot = [dots objectAtIndex:i];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                dot.alpha = 0.0;
            } completion:^(BOOL finished){
                
            }];
        }
    }
    else if ( dots.count >= popLimit ) // You win!
    {
        userWon = 1;
        
        [self showMenu];
    }
    
    popCount = (int)dots.count;
}

- (void)showPlusOne
{
    UILabel *oldLabel = (UILabel *)[HUDLayer viewWithTag:2];
    
    if ( oldLabel )
    {
        [oldLabel removeFromSuperview];
    }
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(userFingerPosition.x, userFingerPosition.y, 50, 20)];
    temp.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    temp.textColor = [UIColor greenColor];
    temp.text = @"+1";
    temp.alpha = 0.0;
    temp.tag = 2;
    
    [HUDLayer addSubview:temp];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        temp.alpha = 1.0;
        temp.frame = CGRectMake(userFingerPosition.x, userFingerPosition.y - 70, temp.frame.size.width, temp.frame.size.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            temp.alpha = 0.0;
            temp.frame = CGRectMake(userFingerPosition.x, userFingerPosition.y - 100, temp.frame.size.width, temp.frame.size.height);
        } completion:^(BOOL finished){
            [temp removeFromSuperview];
        }];
    }];
}

- (void)playDiseaseAlert
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        int count  = 0;
        
        for ( int i = 0; i < dots.count; i++ )
        {
            SHDot *dot = [dots objectAtIndex:i];
            
            if ( dot.condition == SHConditionSick || dot.condition == SHConditionSickContagious )
            {
                count++;
            }
            
            if ( count > 1 )
            {
                break;
            }
        }
        
        if ( count <= 1 )
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [SHSound playSoundEffect:6];
            });
        }
    });
}

- (NSString *)gameplayDurationString
{
    int seconds = playDuration % 60;
    int minutes = (playDuration / 60) % 60;
    int hours = playDuration / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark -
#pragma mark UI

- (void)showMenu
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    longPressGesture.enabled = NO;
    menu.hidden = NO;
    paused = YES;
    
    [self pauseLoop];
    
    menuGameplayDurationLabel.text = [self gameplayDurationString];
    
    if ( userWon == 0 )
    {
        menuBackButton.hidden = NO;
        nextLevelButton.hidden = YES;
        
        menuTitleLabel.textColor = [UIColor blackColor];
        menuTitleLabel.text = @"nocta.";
        
        [SHSound playSoundEffect:7];
    }
    else
    {
        menuBackButton.hidden = YES;
        menuTitleLabel.textColor = [UIColor orangeColor];
        
        if ( userWon == 1 )
        {
            menuTitleLabel.text = NSLocalizedString(@"PLAYER_WON", nil);
            
            if ( level < 3 )
            {
                nextLevelButton.hidden = NO;
            }
            else
            {
                nextLevelButton.hidden = YES;
            }
            
            [SHSound playSoundEffect:9];
        }
        else if ( userWon == -1 )
        {
            nextLevelButton.hidden = YES;
            
            menuTitleLabel.text = NSLocalizedString(@"GAME_OVER", nil);
            
            [SHSound playSoundEffect:8];
        }
    }
    
    menuTitleLabel.frame = CGRectMake(menuTitleLabel.frame.origin.x, -menuTitleLabel.frame.size.height, menuTitleLabel.frame.size.width, menuTitleLabel.frame.size.height);
    replayButton.frame = CGRectMake(replayButton.frame.origin.x, appDelegate.screenBounds.size.height / 2, replayButton.frame.size.width, replayButton.frame.size.height);
    nextLevelButton.frame = CGRectMake(nextLevelButton.frame.origin.x, appDelegate.screenBounds.size.height / 2, nextLevelButton.frame.size.width, nextLevelButton.frame.size.height);
    menuBackButton.frame = CGRectMake(menuBackButton.frame.origin.x, appDelegate.screenBounds.size.height / 2, menuBackButton.frame.size.width, menuBackButton.frame.size.height);
    replayButton.alpha = 0.0;
    nextLevelButton.alpha = 0.0;
    menuBackButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        menu.alpha = 1.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            menuTitleLabel.frame = CGRectMake(menuTitleLabel.frame.origin.x, 180, menuTitleLabel.frame.size.width, menuTitleLabel.frame.size.height);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                replayButton.frame = CGRectMake(replayButton.frame.origin.x, appDelegate.screenBounds.size.height / 2 - replayButton.frame.size.height - 20, replayButton.frame.size.width, replayButton.frame.size.height);
                nextLevelButton.frame = CGRectMake(nextLevelButton.frame.origin.x, appDelegate.screenBounds.size.height / 2 + 20, nextLevelButton.frame.size.width, nextLevelButton.frame.size.height);
                menuBackButton.frame = CGRectMake(menuBackButton.frame.origin.x, appDelegate.screenBounds.size.height / 2 + 20, menuBackButton.frame.size.width, menuBackButton.frame.size.height);
                
                replayButton.alpha = 1.0;
                nextLevelButton.alpha = 1.0;
                menuBackButton.alpha = 1.0;
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
}

- (void)dismissMenu
{
    longPressGesture.enabled = YES;
    paused = NO;
    
    [self startLoop];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        menu.alpha = 0.0;
    } completion:^(BOOL finished){
        menu.hidden = YES;
    }];
}

#pragma mark -
#pragma mark Gestures

- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer.state == UIGestureRecognizerStateBegan )
    {
        userFingerDown = YES;
        
        userFingerPosition = [gestureRecognizer locationInView:gestureRecognizer.view];
    }
    else if ( gestureRecognizer.state == UIGestureRecognizerStateChanged )
    {
        userFingerPosition = [gestureRecognizer locationInView:gestureRecognizer.view];
    }
    else
    {
        userFingerDown = NO;
        
        [self resetStubbornDots];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ( touch.view == pauseButton )
    {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark iAds

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    adView.hidden = NO;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        adView.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
