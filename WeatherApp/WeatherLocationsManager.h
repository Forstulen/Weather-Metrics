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

typedef enum {
    WeatherLocationTemperatureTypeCelsius = 0,
    WeatherLocationTemperatureTypeFarenheit,
    WeatherLocationTemperatureTypeKelvin,
    WeatherLocationTemperatureTypeUnknown
}WeatherLocationsTemperatureType;

typedef enum {
    WeatherLocationFolderTypeBig = 0,
    WeatherLocationFolderTypeForecast
}WeatherLocationFolderType;

@interface WeatherLocationsManager : NSObject <WeatherUserLocationDelegate> {
    OWMWeatherAPI   *_weatherAPI;
    WeatherLocation *_weatherLocationCurrent;
    WeatherLocationsTemperatureType  _weatherLocationsTemperatureType;
    NSMutableArray  *_weatherLocations;
    BOOL            _weatherLocationsAreLoad;
    BOOL            _weatherLocationsAlreadyDisplayCurrentLocation;
    BOOL            _weatherLocationsWaitingForCurrentLocation;
    NSUInteger      _weatherLocationsPendingNumber;
    NSUInteger      _weatherLocationsDownloadingNumber;
    NSUInteger      _weatherLocationsMaxHourForecast;
    NSUInteger      _weatherLocationsMaxDailyForecast;
    NSDateFormatter *_weatherLocationsDateFormatter;
}

+ (id)sharedWeatherLocationsManager;

- (void)loadRegisteredLocations;
- (void)saveRegisteredLocations;

- (void)addLocationWithLocation:(WeatherLocation *)city;
- (void)addLocationWithName:(NSString *)city;
- (void)delLocation:(WeatherLocation *)city;
- (BOOL)updateLocation:(WeatherLocation *)city;
- (void)updateAllLocations;

- (UIColor *)getWeatherColorWithLocation:(WeatherLocation *)loc;
- (NSString *)getFormattedDate:(NSDate *)date WithFormat:(NSString *)format;
- (NSInteger)getConvertedTemperature:(NSInteger)temp;
- (NSString *)getIconFolder:(WeatherLocation *)loc withFolderType:(WeatherLocationFolderType)type;

@property (nonatomic, readwrite)    NSMutableArray *weatherLocations;
@property (nonatomic, readwrite)    NSUInteger  weatherLocationsForecastCount;
@property (nonatomic, readonly)     BOOL    weatherLocationsAreLoad;
@property (nonatomic, readonly)     WeatherLocation *weatherLocationCurrent;
@property (nonatomic) NSUInteger    weatherLocationsMaxHourForecast;
@property (nonatomic) NSUInteger    weatherLocationsMaxDailyForecast;
@property (nonatomic, readwrite)    WeatherLocationsTemperatureType    weatherLocationsTemperatureType;

@end
