//
//  SHDot.h
//  Nocta
//
//  Created by Ali.cpp on 4/9/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface SHDot : UIButton
{
    SHDotType dotType;
    SHCondition dotCondition;
    BOOL isAnimating;
}

@property (nonatomic) NSMutableArray *moveStates;
@property (nonatomic) NSMutableArray *conditionStates;
@property (nonatomic) SHDotType type;
@property (nonatomic) SHCondition condition;
@property (nonatomic) float health;
@property (nonatomic) int64_t age;
@property (nonatomic) int orientation;
@property (nonatomic) int ticksSinceOrientationChange;
@property (nonatomic) int ticksTillConditionChange;
@property (nonatomic) int collidedDotID;
@property (nonatomic) BOOL hooked;

- (void)setupView;
- (void)animateColor;
- (void)die;

@end
