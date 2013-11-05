//
//  WeatherLocationTableViewController.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLocationsManager;

@interface WeatherLocationTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    UIRefreshControl    *_weatherLocationTableRefresh;
    UIAlertView         *_weatherLocationAddLocation;
    
}

- (void)handleRefresh;
- (void)changeTemperatureType;

@end
