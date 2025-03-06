//
//  SHMenuViewController.h
//  Nocta
//
//  Created by Ali.cpp on 4/17/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "SHMainViewController.h"
#import "SHDot.h"

@interface SHMenuViewController : UIViewController <ADBannerViewDelegate>
{
    UIButton *playButton;
    UIButton *rateButton;
    UILabel *quoteLabel;
    ADBannerView *adView;
    SHDot *dot1;
    SHDot *dot2;
    NSArray *randomQuotes;
}

@property (nonatomic) SHMainViewController *mainView;

- (void)animateDots;
- (void)pause;
- (void)start;
- (void)enterGame;
- (void)rateGame;

@end
