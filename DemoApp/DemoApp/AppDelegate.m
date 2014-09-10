//
//  AppDelegate.m
//  DemoApp
//
//  Created by user on 9/6/14.
//  Copyright (c) 2014 VolarVideo. All rights reserved.
//

#import "AppDelegate.h"
#import "VVMediaListViewController.h"

@implementation AppDelegate {
    VVMediaListViewController * listViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    listViewController = [[VVMediaListViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[UINavigationController alloc]initWithRootViewController:(UIViewController*)listViewController];
    self.navController.navigationBar.barStyle = UIBarStyleBlack;
    self.navController.navigationBar.translucent = NO;
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
