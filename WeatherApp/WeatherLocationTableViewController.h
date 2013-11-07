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
    UIActivityIndicatorView *_weatherLocationIndicator;
    UIAlertView         *_weatherLocationAddLocation;
    NSIndexPath         *_weatherLocationLastSelectedCell;
    
}

- (void)handleRefresh;
- (void)changeTemperatureType;
- (void)focusLastSelectedCell;

@end
