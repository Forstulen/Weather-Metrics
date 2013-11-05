//
//  WeatherLocationsManager.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherUserLocationManager.h"

@class WeatherLocation;
@class OWMWeatherAPI;

@interface WeatherLocationsManager : NSObject <WeatherUserLocationDelegate> {
    OWMWeatherAPI   *_weatherAPI;
    WeatherLocation *_weatherLocationCurrent;
    NSMutableArray  *_weatherLocations;
    BOOL            _weatherLocationsAreLoad;
    BOOL            _weatherLocationsWaitingForCurrentLocation;
    NSUInteger      _weatherLocationsPendingNumber;
    NSUInteger      _weatherLocationsDownloadingNumber;
    NSUInteger      _weatherLocationsMaxHourForecast;
    NSUInteger      _weatherLocationsMaxDailyForecast;
    NSDateFormatter *_weatherLocationsDateFormatter;
}

+ (id)sharedWeatherLocationsManager;

- (void)loadRegistredLocations;
- (void)saveRegistredLocations;

- (void)addNewLocationWithLocation:(WeatherLocation *)city;
- (void)addNewLocationWithName:(NSString *)city;
- (void)delNewLocation:(WeatherLocation *)city;
- (BOOL)updateLocation:(WeatherLocation *)city;
- (void)updateAllLocations;

- (UIColor *)getWeatherColorWithLocation:(WeatherLocation *)loc;
- (NSString *)getFormattedDate:(NSDate *)date WithFormat:(NSString *)format;

@property (nonatomic, readwrite)    NSMutableArray *weatherLocations;
@property (nonatomic, readwrite)    NSUInteger  weatherLocationsForecastCount;
@property (nonatomic, readonly)     BOOL    weatherLocationsAreLoad;
@property (nonatomic, readonly)     WeatherLocation *weatherLocationCurrent;
@property (nonatomic) NSUInteger    weatherLocationsMaxHourForecast;
@property (nonatomic) NSUInteger    weatherLocationsMaxDailyForecast;

@end
