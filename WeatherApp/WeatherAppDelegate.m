//
//  WeatherAppDelegate.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/8/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherAppDelegate.h"
#import "WeatherRootViewController.h"
#import "WeatherLocationsManager.h"

@implementation WeatherAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    WeatherRootViewController   *rootController = [[WeatherRootViewController alloc] initWithNibName:@"WeatherRootViewController" bundle:nil];
    
    UINavigationController  *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    [navController setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[WeatherLocationsManager sharedWeatherLocationsManager] saveRegistredLocations];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[WeatherLocationsManager sharedWeatherLocationsManager] updateAllLocations];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[WeatherLocationsManager sharedWeatherLocationsManager] updateAllLocations];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[WeatherLocationsManager sharedWeatherLocationsManager] saveRegistredLocations];
}



@end
