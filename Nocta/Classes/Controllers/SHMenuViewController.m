//
//  SHMenuViewController.m
//  Nocta
//
//  Created by Ali.cpp on 4/17/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import "SHMenuViewController.h"

#import "AppDelegate.h"
#import "SHSound.h"

@implementation SHMenuViewController

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        randomQuotes = @[@"Bazinga!",
                         @"I don't even know what a quail looks like.",
                         @"Too close for missiles, I'm switching to guns.",
                         @"That’s a negative, Ghostrider. The pattern is full.",
                         @"When life gives you lemons, make lemonade.",
                         @"The cake is a lie.",
                         @"Sarcasm Self Test complete.",
                         @"Now you know who you're fighting.",
                         @"an Ali Razzouk production",
                         @"We'll send you a Hogwarts toilet seat.",
                         @"Get the Snitch or die trying.",
                         @"I solemnly swear that I am up to no good.",
                         @"When 900 years old, you reach…Look as good, you will not.",
                         @"He’s holding a thermal detonator!",
                         @"It's a trap!",
                         @"Aren't you a little short for a stormtrooper?",
                         @"These aren’t the droids you’re looking for…",
                         @"I find your lack of faith disturbing.",
                         @"There's always a bigger fish.",
                         @"I am the one who knocks.",
                         @"Only a Sith deals in absolutes.",
                         @"Manners maketh man.",
                         @"A wizard is never late."];
    }
    
    return self;
}

- (void)loadView
{
    AppDelegate *appDelegate = [AppDelegate sharedDelegate];
    
    UIView *contentView = [[UIView alloc] initWithFrame:appDelegate.screenBounds];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, appDelegate.screenBounds.size.height / 2 - 180, appDelegate.screenBounds.size.width - 40, 32)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"nocta.";
    
    int rand = arc4random_uniform((int)randomQuotes.count);
    
    quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, appDelegate.screenBounds.size.height - 58, appDelegate.screenBounds.size.width - 40, 18)];
    quoteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:MIN_MAIN_FONT_SIZE];
    quoteLabel.minimumScaleFactor = 8.0 / MIN_MAIN_FONT_SIZE;
    quoteLabel.adjustsFontSizeToFitWidth = YES;
    quoteLabel.numberOfLines = 1;
    quoteLabel.textAlignment = NSTextAlignmentCenter;
    quoteLabel.textColor = [UIColor grayColor];
    quoteLabel.text = [randomQuotes objectAtIndex:rand];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self action:@selector(enterGame) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:NSLocalizedString(@"PLAY", nil) forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    playButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    playButton.frame = CGRectMake(20, appDelegate.screenBounds.size.height / 2 - DOT_STANDARD_SIZE - 20, appDelegate.screenBounds.size.width - 40, DOT_STANDARD_SIZE);
    
    rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rateButton addTarget:self action:@selector(rateGame) forControlEvents:UIControlEventTouchUpInside];
    [rateButton setTitle:NSLocalizedString(@"RATE", nil) forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    rateButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
    rateButton.frame = CGRectMake(20, appDelegate.screenBounds.size.height / 2 + 20, appDelegate.screenBounds.size.width - 40, DOT_STANDARD_SIZE);
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenBounds.size.width, 50)];
    [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    adView.delegate = self;
    adView.alpha = 0.0;
    adView.hidden = YES;
    
    dot1 = [[SHDot alloc] initWithFrame:CGRectMake(40, 0, DOT_STANDARD_SIZE, DOT_STANDARD_SIZE)];
    dot1.type = arc4random_uniform(2) + 1;
    dot1.enabled = NO;
    
    dot2 = [[SHDot alloc] initWithFrame:CGRectMake(40, 0, DOT_STANDARD_SIZE, DOT_STANDARD_SIZE)];
    dot2.enabled = NO;
    
    if ( dot1.type == SHDotTypeDad )
    {
        dot2.type = SHDotTypeMom;
    }
    else
    {
        dot2.type = SHDotTypeDad;
    }
    
    [playButton addSubview:dot1];
    [rateButton addSubview:dot2];
    [contentView addSubview:title];
    [contentView addSubview:playButton];
    [contentView addSubview:rateButton];
    [contentView addSubview:quoteLabel];
    [contentView addSubview:adView];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self animateDots];
}

- (void)animateDots
{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        dot1.frame = CGRectMake(90, dot1.frame.origin.y, dot1.frame.size.width, dot1.frame.size.height);
        dot2.frame = CGRectMake(40, dot2.frame.origin.y, dot2.frame.size.width, dot2.frame.size.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            dot1.frame = CGRectMake(40, dot1.frame.origin.y, dot1.frame.size.width, dot1.frame.size.height);
            dot2.frame = CGRectMake(90, dot2.frame.origin.y, dot2.frame.size.width, dot2.frame.size.height);
        } completion:^(BOOL finished){
            [self animateDots];
        }];
    }];
}

- (void)pause
{
    if ( _mainView )
    {
        [_mainView pauseLoop];
    }
}

- (void)start
{
    if ( _mainView )
    {
        [_mainView startLoop];
    }
}

- (void)enterGame
{
    _mainView = [[SHMainViewController alloc] init];
    
    [SHSound playSoundEffect:arc4random_uniform(3) + 1];
    [self.navigationController pushViewController:_mainView animated:YES];
}

- (void)rateGame
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/nocta/id986640544?ls=1&mt=8"];
    
    [[UIApplication sharedApplication] openURL:url];
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
