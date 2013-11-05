//
//  WeatherRootViewController.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLocationTableViewController;
@class WeatherLocationPageViewController;

typedef enum {
    WeatherPageViewController = 0,
    WeatherTableViewController
}WeatherStartingView;

@interface WeatherRootViewController : UIViewController {
    WeatherLocationPageViewController   *_weatherLocationPageViewController;
    WeatherLocationTableViewController  *_weatherLocationTableViewController;
    WeatherStartingView                 _weatherStartingViewType;
}

- (void)presentPageViewController:(NSDictionary *)userInfo;
- (void)presentTableViewController;

@end
