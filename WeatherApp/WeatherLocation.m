//
//  WeatherLocation.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/9/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "WeatherUserLocationManager.h"
#import "WeatherLocation.h"
#import "defines.h"
#import "NSDictionaryAdditions.h"

@interface WeatherLocation (Private)

- (void) buildWeatherLocationWithDictionary:(NSDictionary *)dict;
- (void) buildWeatherLocationCurrentWeather:(NSDictionary *)dict;
- (void) buildWeatherLocationDailyForecasts:(NSDictionary *)dict;
- (void) buildWeatherLocationDailyForecast:(NSDictionary *)dict;
- (void) buildWeatherLocation3HoursForecasts:(NSDictionary *)dict;
- (void) buildWeatherLocation3HoursForecast:(NSDictionary *)dict;

@end

@implementation WeatherLocation

- (id) initWithDictionary:(NSDictionary *)dict withType:(WeatherLocationInformationType)type {
    if (self = [super init]) {
        _weatherLocationInformationType = type;
        _weatherLocationCurrent = NO;
        _weatherLocationDailyForecasts = [[NSMutableArray alloc] init];
        _weatherLocationForecasts = [[NSMutableArray alloc] init];
        [self buildWeatherLocationWithDictionary:dict];
    }
    return self;
}

- (void) updateWeatherLocation:(NSDictionary *)dict withType:(WeatherLocationInformationType)type {
    _weatherLocationInformationType = type;
    _weatherLocationDailyForecasts = [[NSMutableArray alloc] init];
    _weatherLocationForecasts = [[NSMutableArray alloc] init];
    [self buildWeatherLocationWithDictionary:dict];
}

- (void) buildWeatherLocationWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    switch (_weatherLocationInformationType) {
        case WeatherLocationInformationTypeCurrentWeather:
            [self buildWeatherLocationCurrentWeather:dict];
            break;
        case WeatherLocationInformationTypeDailyForecasts:
            [self buildWeatherLocationDailyForecasts:dict];
            break;
        case WeatherLocationInformationTypeDailyForecast:
            [self buildWeatherLocationDailyForecast:dict];
            break;
        case WeatherLocationInformationType3HoursForecasts:
            [self buildWeatherLocation3HoursForecasts:dict];
            break;
        case WeatherLocationInformationType3HoursForecast:
            [self buildWeatherLocation3HoursForecast:dict];
            break;
        case WeatherLocationInformationTypeUnknown:
            NSLog(@"Error Weather Location Type");
            break;
        default:
            break;
    }
   // [self registerCurrentLocation:self];
}

- (void) buildWeatherLocationCurrentWeather:(NSDictionary *)dict {
    NSNumber    *lon = dict[@"coord"][@"lon"];
    NSNumber    *lat = dict[@"coord"][@"lat"];
    NSArray         *weatherList = dict[@"weather"];
    NSDictionary    *weather = [weatherList firstObject];
    
    _weatherLocationCoord.longitude = [lon floatValue];
    _weatherLocationCoord.latitude = [lat floatValue];
    
    _weatherLocationCountry = dict[@"sys"][@"country"];
    _weatherLocationSunrise = dict[@"sys"][@"sunrise"];
    _weatherLocationSunset = dict[@"sys"][@"sunset"];
    
    _weatherLocationDescription = weather[@"description"];
    _weatherLocationMain = weather[@"main"];
    _weatherLocationIcon = weather[@"icon"];
    
    _weatherLocationNightTime = NO;
    if (_weatherLocationIcon && [_weatherLocationIcon characterAtIndex:_weatherLocationIcon.length - 1] == 'n') {
        _weatherLocationNightTime = YES;
    }

    _weatherLocationTemp = dict[@"main"][@"temp"];
    _weatherLocationTempMin = dict[@"main"][@"temp_min"];
    _weatherLocationTempMax = dict[@"main"][@"temp_max"];
    _weatherLocationHumidity = dict[@"main"][@"humidity"];
    
    _weatherLocationTime = dict[@"dt"];
    _weatherLocationName = dict[@"name"];
    _weatherLocationID = dict[@"id"];
    
    _weatherLocationWindSpeed = dict[@"wind"][@"speed"];
    _weatherLocationWindDeg = dict[@"wind"][@"deg"];
    
    if ([dict safeObjectForKey:@"rain"])
        _weatherLocationRain = dict[@"rain"];
    if ([dict safeObjectForKey:@"clouds"])
        _weatherLocationClouds = dict[@"clouds"][@"all"];
}

- (void) buildWeatherLocationDailyForecasts:(NSDictionary *)dict {
    NSDictionary    *city = dict[@"city"];
    NSNumber        *lon = city[@"coord"][@"lon"];
    NSNumber        *lat = city[@"coord"][@"lat"];
    
    _weatherLocationCoord.longitude = [lon floatValue];
    _weatherLocationCoord.latitude = [lat floatValue];
    
    _weatherLocationCountry = city[@"country"];
    _weatherLocationName = city[@"name"];
    _weatherLocationID = city[@"id"];
    
    //-------------------------------------------------------
    NSArray         *forecastsList = dict[@"list"];
    
    for (NSDictionary *dailyForecastDict in forecastsList) {
        WeatherLocation *dailyForecast = [[WeatherLocation alloc] initWithDictionary:dailyForecastDict withType:WeatherLocationInformationTypeDailyForecast];
        
        [_weatherLocationDailyForecasts addObject:dailyForecast];
    }
}

- (void) buildWeatherLocationDailyForecast:(NSDictionary *)dict {
    NSArray         *weatherList = dict[@"weather"];
    NSDictionary    *weather = [weatherList firstObject];
    
    _weatherLocationDescription = weather[@"description"];
    _weatherLocationMain = weather[@"main"];
    _weatherLocationIcon = weather[@"icon"];
    
    _weatherLocationNightTime = NO;
    if (_weatherLocationIcon && [_weatherLocationIcon characterAtIndex:_weatherLocationIcon.length - 1] == 'n') {
        _weatherLocationNightTime = YES;
    }
    
    _weatherLocationTemp = dict[@"temp"][@"day"];
    _weatherLocationTempMin = dict[@"temp"][@"min"];
    _weatherLocationTempMax = dict[@"temp"][@"max"];
    _weatherLocationHumidity = dict[@"temp"][@"humidity"];
    
    _weatherLocationTime = dict[@"dt"];

    _weatherLocationWindSpeed = dict[@"speed"];
    _weatherLocationWindDeg = dict[@"deg"];
    
    if ([dict safeObjectForKey:@"rain"])
        _weatherLocationRain = dict[@"rain"];
    if ([dict safeObjectForKey:@"clouds"])
        _weatherLocationClouds = dict[@"clouds"];
}

- (void) buildWeatherLocation3HoursForecasts:(NSDictionary *)dict {
    NSDictionary    *city = dict[@"city"];
    NSNumber        *lon = city[@"coord"][@"lon"];
    NSNumber        *lat = city[@"coord"][@"lat"];
    
    _weatherLocationCoord.longitude = [lon floatValue];
    _weatherLocationCoord.latitude = [lat floatValue];
    
    _weatherLocationCountry = city[@"country"];
    _weatherLocationName = city[@"name"];
    _weatherLocationID = city[@"id"];
    
    //-------------------------------------------------------
    NSArray         *forecastsList = dict[@"list"];
    
    for (NSDictionary *forecastDict in forecastsList) {
        WeatherLocation *forecast = [[WeatherLocation alloc] initWithDictionary:forecastDict withType:WeatherLocationInformationType3HoursForecast];
        
        [_weatherLocationForecasts addObject:forecast];
    }
}

- (void) buildWeatherLocation3HoursForecast:(NSDictionary *)dict {
    NSArray         *weatherList = dict[@"weather"];
    NSDictionary    *weather = [weatherList firstObject];
    
    _weatherLocationDescription = weather[@"description"];
    _weatherLocationMain = weather[@"main"];
    _weatherLocationIcon = weather[@"icon"];
    
    _weatherLocationNightTime = NO;
    if (_weatherLocationIcon && [_weatherLocationIcon characterAtIndex:_weatherLocationIcon.length - 1] == 'n') {
        _weatherLocationNightTime = YES;
    }
    
    _weatherLocationTemp = dict[@"main"][@"temp"];
    _weatherLocationTempMin = dict[@"main"][@"temp_min"];
    _weatherLocationTempMax = dict[@"main"][@"temp_max"];
    _weatherLocationHumidity = dict[@"main"][@"humidity"];
    
    _weatherLocationTime = dict[@"dt"];
    
    if ([dict safeObjectForKey:@"wind"]) {
        _weatherLocationWindSpeed = dict[@"wind"][@"speed"];
        _weatherLocationWindDeg = dict[@"wind"][@"deg"];
    }
    
    if ([dict safeObjectForKey:@"rain"])
        _weatherLocationRain = dict[@"rain"];
    if ([dict safeObjectForKey:@"clouds"])
        _weatherLocationClouds = dict[@"clouds"][@"all"];
}

- (void)registerCurrentLocation:(WeatherLocation *)city {
    CLLocationCoordinate2D  coord = [[WeatherUserLocationManager sharedWeatherUserLocationManager] weatherUserCurrentLocation].coordinate;
    
    if (coord.latitude == city.weatherLocationCoord.latitude && coord.longitude == city.weatherLocationCoord.longitude) {
        city.weatherLocationCurrent = YES;
    } else {
        city.weatherLocationCurrent = NO;
    }
}

@end
