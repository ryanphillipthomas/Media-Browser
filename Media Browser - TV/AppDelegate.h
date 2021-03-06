//
//  AppDelegate.h
//  Media Browser - TV
//

//  Copyright (c) 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TVMLKit/TVMLKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TVApplicationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TVApplicationController *appController;

@end

