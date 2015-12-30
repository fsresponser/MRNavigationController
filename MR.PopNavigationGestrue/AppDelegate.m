//
//  AppDelegate.m
//  MR.PopNavigationGestrue
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 MR. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MRNavigitionController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UITabBar appearance] setTintColor:[UIColor purpleColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    ViewController *vc = [[ViewController alloc]init];
    vc.title= @"scale";
    vc.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1] ;
    MRNavigitionController *nacVC = [[MRNavigitionController alloc]initWithRootViewController:vc] ;
    nacVC.transformStyle = horizTranform;
    
    
    ViewController *vc2 = [[ViewController alloc]init];
    vc2.title = @"horiz";
    vc2.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    MRNavigitionController *nacVC2 = [[MRNavigitionController alloc]initWithRootViewController:vc2];
    nacVC2.transformStyle = scaleTransform;

    UITabBarController *tabBarCtrl = [[UITabBarController alloc]init];
    tabBarCtrl.viewControllers = @[nacVC,nacVC2];
    
    
   //self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBarCtrl;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
