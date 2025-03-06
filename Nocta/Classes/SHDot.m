//
//  SHDot.m
//  Nocta
//
//  Created by Ali.cpp on 4/9/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import "SHDot.h"

#import "SHState.h"
#import "SHSound.h"

@implementation SHDot

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        [self setupView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    isAnimating = NO;
    self.type = SHDotTypeDad;
    self.condition = SHConditionNormal;
    _health = 70.0;
    _ticksSinceOrientationChange = 0;
    _ticksTillConditionChange = 0;
    _collidedDotID = -1;
    _hooked = NO;
    
    _moveStates = [[NSMutableArray alloc] initWithObjects:[[SHState alloc] initWithState:SHActionNone value:0],
                   [[SHState alloc] initWithState:SHActionNone value:0], nil];
    _conditionStates = [[NSMutableArray alloc] initWithObjects:[[SHState alloc] initWithState:SHConditionNormal value:0],
                        [[SHState alloc] initWithState:SHConditionNormal value:0], nil];
}

- (void)setType:(SHDotType)type
{
    
    if ( type == SHDotTypeDad )
    {
        dotType = type;
        
        // In case the setter gets called from a different thread.
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.backgroundColor = [UIColor blackColor];
        });
    }
    else
    {
        dotType = SHDotTypeMom;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.backgroundColor = [UIColor colorWithRed:255/255.0 green:209/255.0 blue:239/255.0 alpha:1.0];
        });
    }
}

- (SHDotType)type
{
    return dotType;
}

- (void)setCondition:(SHCondition)condition
{
    
    if ( (condition == SHConditionRogue || condition == SHConditionSick || condition == SHConditionSickContagious) &&
        dotCondition != condition )
    {
        dotCondition = condition;
        
        // In case the setter gets called from a different thread.
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self animateColor];
        });
    }
    
    dotCondition = condition;
}

- (SHCondition)condition
{
    return dotCondition;
}

- (void)animateColor
{
    if ( (dotCondition == SHConditionRogue || dotCondition == SHConditionSick || dotCondition == SHConditionSickContagious) &&
        !isAnimating )
    {
        isAnimating = YES;
        
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
           if ( dotCondition == SHConditionRogue )
           {
               self.backgroundColor = [UIColor redColor];
           }
           else
           {
                self.backgroundColor = [UIColor greenColor];
           }
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                if ( dotType == SHDotTypeDad )
                {
                    self.backgroundColor = [UIColor blackColor];
                }
                else
                {
                    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:209/255.0 blue:239/255.0 alpha:1.0];
                }
            } completion:^(BOOL finished){
                isAnimating = NO;
                
                [self animateColor];
            }];
        }];
    }
}

- (void)die
{
    [SHSound playSoundEffect:arc4random_uniform(2) + 4];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished){
        
    }];
}

@end
