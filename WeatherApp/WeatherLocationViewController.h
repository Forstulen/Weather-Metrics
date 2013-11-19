//
//  WeatherLocationViewController.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLocation;
@class WeatherLocationsManager;
@class WeatherAnimatedIcon;

@interface WeatherLocationViewController : UIViewController {
    WeatherLocationsManager *_weatherLocationsManager;
    WeatherLocation         *_weatherLocation;

}

@property (nonatomic, readwrite) NSUInteger weatherLocationViewIndex;

@end
