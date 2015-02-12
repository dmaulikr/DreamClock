//
//  AppDelegate.m
//  DreamClock
//
//  Created by Thomas Thornton on 12/1/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "AppDelegate.h"
#import "DreamStore.h"
#import "DreamsTableViewController.h"
#import "RecordViewController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // Switch to record view controller if the local notif/alarm went off
    // If notif not set far enough in advance it automatically switches
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedViewController = [tabBarController.viewControllers objectAtIndex:1];
    
//    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[DreamStore sharedStore]saveChanges];
    
    if (success) {
        NSLog(@"Saved all of the Dreams");
    } else {
        NSLog(@"Could not save any Dreams");
    }
    
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
