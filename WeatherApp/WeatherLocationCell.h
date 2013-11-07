//
//  WeatherLocationCell.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/25/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLocation;
@class WeatherAnimatedIcon;

@interface WeatherLocationCell : UITableViewCell {
    WeatherLocation         *_weatherLocation;
    WeatherAnimatedIcon     *_weatherLocationIcon;
    UIView                  *_weatherLocationColorTemp;
    UILabel                 *_weatherLocationCityName;
    UILabel                 *_weatherLocationTemp;
    UIImageView             *_weatherLocationCurrentLocation;
}

- (void)buildWeatherCell:(WeatherLocation *)location;

@end
