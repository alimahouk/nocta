//
//  AppDelegate.h
//  Nocta
//
//  Created by Ali.cpp on 4/9/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGRect screenBounds;
@property (nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic) SHMenuViewController *menuView;

+ (AppDelegate *)sharedDelegate;

@end

