//
//  WeatherLocation.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/9/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <Foundation/Foundation.h>

struct CLLocationCoordinate2D;

typedef enum  {
    WeatherLocationInformationTypeCurrentWeather = 0,
    WeatherLocationInformationTypeDailyForecasts,
    WeatherLocationInformationTypeDailyForecast,
    WeatherLocationInformationType3HoursForecasts,
    WeatherLocationInformationType3HoursForecast,
    WeatherLocationInformationTypeUnknown
}WeatherLocationInformationType;

@interface WeatherLocation : NSObject {
    WeatherLocationInformationType  _weatherLocationInformationType;
    
    NSNumber    *_weatherLocationID;
    NSNumber    *_weatherLocationTemp;
    NSNumber    *_weatherLocationTempMin;
    NSNumber    *_weatherLocationTempMax;
    NSNumber    *_weatherLocationHumidity;
    NSNumber    *_weatherLocationWindSpeed;
    NSNumber    *_weatherLocationWindDeg;
    NSNumber    *_weatherLocationClouds;
    NSNumber    *_weatherLocationRain;
    
    NSString    *_weatherLocationName;
    NSString    *_weatherLocationCountry;
    NSString    *_weatherLocationDescription;
    NSString    *_weatherLocationMain;
    
    NSDate      *_weatherLocationSunset;
    NSDate      *_weatherLocationSunrise;
    NSDate      *_weatherLocationTime;
    
    NSMutableArray     *_weatherLocationDailyForecasts;
    NSMutableArray     *_weatherLocationForecasts;
    
    CLLocationCoordinate2D  _weatherLocationCoord;
    
    BOOL        _weatherLocationCurrent;
    BOOL        _weatherLocationError;
}

- (id) initWithDictionary:(NSDictionary *)dict withType:(WeatherLocationInformationType)type ;
- (void) updateWeatherLocation:(NSDictionary *)dict withType:(WeatherLocationInformationType)type;

@property (nonatomic, readonly) NSNumber    *weatherLocationID;
@property (nonatomic, readonly) NSNumber    *weatherLocationTemp;
@property (nonatomic, readonly) NSNumber    *weatherLocationTempMin;
@property (nonatomic, readonly) NSNumber    *weatherLocationTempMax;
@property (nonatomic, readonly) NSNumber    *weatherLocationHumidity;
@property (nonatomic, readonly) NSNumber    *weatherLocationWindSpeed;
@property (nonatomic, readonly) NSNumber    *weatherLocationWindDeg;
@property (nonatomic, readonly) NSNumber    *weatherLocationClouds;
@property (nonatomic, readonly) NSNumber    *weatherLocationRain;

@property (nonatomic, readwrite) NSString   *weatherLocationName;
@property (nonatomic, readonly) NSString    *weatherLocationCountry;
@property (nonatomic, readonly) NSString    *weatherLocationDescription;
@property (nonatomic, readonly) NSString    *weatherLocationMain;
@property (nonatomic, readonly) NSString    *weatherLocationIcon;

@property (nonatomic, readonly) NSDate      *weatherLocationTime;
@property (nonatomic, readonly) NSDate      *weatherLocationSunset;
@property (nonatomic, readonly) NSDate      *weatherLocationSunrise;

@property (nonatomic, readonly) CLLocationCoordinate2D  weatherLocationCoord;

@property (nonatomic, readonly) NSMutableArray *weatherLocationDailyForecasts;
@property (nonatomic, readonly) NSMutableArray *weatherLocationForecasts;

@property (nonatomic, readonly) BOOL        weatherLocationNightTime;
@property (nonatomic, readwrite) BOOL       weatherLocationCurrent;
@property (nonatomic, readwrite) BOOL       weatherLocationError;

@end
