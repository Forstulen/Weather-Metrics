    //
//  WeatherLocationsManager.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "defines.h"
#import "OWMWeatherAPI.h"
#import "WeatherLocation.h"
#import "WeatherLocationsManager.h"

@interface WeatherLocationsManager ()

- (id)init;

@end

@implementation WeatherLocationsManager

+ (id)sharedWeatherLocationsManager {
    static WeatherLocationsManager *shared = nil;
    @synchronized(self) {
        if (shared == nil)
            shared = [[self alloc] init];
    }
    return shared;
}

- (id)init {
    if (self = [super init]) {
        WeatherUserLocationManager  *locationManager = [WeatherUserLocationManager sharedWeatherUserLocationManager];
        
        locationManager.weatherUserLocationDelegate = self;
        [locationManager startUserLocation];
        _weatherLocationsAreLoad = NO;
        _weatherLocationsWaitingForCurrentLocation = YES;
        _weatherLocationsDownloadingNumber = 0;
        _weatherLocationsPendingNumber = 0;
        _weatherLocationsMaxHourForecast = 7;
        _weatherLocationsMaxDailyForecast = 7;
        _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:WEATHER_APP_ID];
        _weatherLocationsDateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[WeatherUserLocationManager sharedWeatherUserLocationManager] stopUserLocation];
    [self saveRegistredLocations];
}

#pragma mark -
#pragma mark Add / Del

- (void)addNewLocationWithLocation:(WeatherLocation *)city {
    
}

- (void)addNewLocationWithName:(NSString *)city {
    NSString    *encodedName = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self createWeatherLocationWithCurrentWithName:encodedName WithLocation:nil];
    [self createWeatherLocationWithForecastWithName:encodedName WithLocation:nil];
}

- (void)delNewLocation:(WeatherLocation *)city {
    [self.weatherLocations removeObject:city];
}

- (BOOL)updateLocation:(WeatherLocation *)city {
    if (fabs([city.weatherLocationTime timeIntervalSinceDate:[NSDate date]]) >= WEATHER_API_DELAY_REQUEST) {
        [self createWeatherLocationWithForecastWithName:city.weatherLocationName WithLocation:city];
        [self createWeatherLocationWithForecastWithName:city.weatherLocationName WithLocation:city];
        return YES;
    }
    return NO;
}

- (void)updateAllLocations {
    if (_weatherLocations.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    }
    
    for (WeatherLocation *loc in _weatherLocations) {
        [self createWeatherLocationWithForecastWithName:loc.weatherLocationName WithLocation:loc];
        [self createWeatherLocationWithForecastWithName:loc.weatherLocationName WithLocation:loc];
    }
}

- (UIColor *)getWeatherColorWithLocation:(WeatherLocation *)loc {
    NSInteger       temp = loc.weatherLocationTemp.integerValue;
    
    if (temp <= -46) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(115.f / 255.f) green:(99.f / 255.f) blue:(124.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(115.f / 255.f) green:(99.f / 255.f) blue:(124.f / 255.f) alpha:1.f];
    } else if (temp >= -45 && temp <= -41) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(125.f / 255.f) green:(111.f / 255.f) blue:(140.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(125.f / 255.f) green:(111.f / 255.f) blue:(140.f / 255.f) alpha:1.f];
    } else if (temp >= -40 && temp <= -36) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(121.f / 255.f) green:(120.f / 255.f) blue:(143.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(121.f / 255.f) green:(120.f / 255.f) blue:(143.f / 255.f) alpha:1.f];
    } else if (temp >= -35 && temp <= -31) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(118.f / 255.f) green:(128.f / 255.f) blue:(147.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(118.f / 255.f) green:(128.f / 255.f) blue:(147.f / 255.f) alpha:1.f];
    } else if (temp >= -30 && temp <= -26) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(114.f / 255.f) green:(137.f / 255.f) blue:(150.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(114.f / 255.f) green:(137.f / 255.f) blue:(150.f / 255.f) alpha:1.f];
    } else if (temp >= -25 && temp <= -21) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(119.f / 255.f) green:(157.f / 255.f) blue:(165.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(119.f / 255.f) green:(157.f / 255.f) blue:(165.f / 255.f) alpha:1.f];
    } else if (temp >= -20 && temp <= -16) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(124.f / 255.f) green:(176.f / 255.f) blue:(179.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(124.f / 255.f) green:(176.f / 255.f) blue:(179.f / 255.f) alpha:1.f];
    } else if (temp >= -15 && temp <= -11) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(104.f / 255.f) green:(193.f / 255.f) blue:(184.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(104.f / 255.f) green:(193.f / 255.f) blue:(184.f / 255.f) alpha:1.f];
    } else if (temp >= -10 && temp <= -6) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(80.f / 255.f) green:(191.f / 255.f) blue:(175.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(80.f / 255.f) green:(191.f / 255.f) blue:(175.f / 255.f) alpha:1.f];
    } else if (temp >= -5 && temp <= 0) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(55.f / 255.f) green:(188.f / 255.f) blue:(165.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(55.f / 255.f) green:(188.f / 255.f) blue:(165.f / 255.f) alpha:1.f];
    } else if (temp >= 1 && temp <= 5) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(94.f / 255.f) green:(189.f / 255.f) blue:(146.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(94.f / 255.f) green:(189.f / 255.f) blue:(146.f / 255.f) alpha:1.f];
    } else if (temp >= 6 && temp <= 10) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(137.f / 255.f) green:(189.f / 255.f) blue:(133.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(137.f / 255.f) green:(189.f / 255.f) blue:(133.f / 255.f) alpha:1.f];
    } else if (temp >= 11 && temp <= 15) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(174.f / 255.f) green:(190.f / 255.f) blue:(112.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(174.f / 255.f) green:(190.f / 255.f) blue:(112.f / 255.f) alpha:1.f];
    } else if (temp >= 16 && temp <= 20) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(226.f / 255.f) green:(188.f / 255.f) blue:(68.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(226.f / 255.f) green:(188.f / 255.f) blue:(68.f / 255.f) alpha:1.f];
    } else if (temp >= 21 && temp <= 25) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(254.f / 255.f) green:(180.f / 255.f) blue:(42.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(254.f / 255.f) green:(180.f / 255.f) blue:(42.f / 255.f) alpha:1.f];
    } else if (temp >= 26 && temp <= 30) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(254.f / 255.f) green:(154.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(254.f / 255.f) green:(154.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
    } else if (temp >= 31 && temp <= 35) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(254.f / 255.f) green:(129.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(254.f / 255.f) green:(129.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
    } else if (temp >= 36 && temp <= 40) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(254.f / 255.f) green:(105.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(254.f / 255.f) green:(105.f / 255.f) blue:(41.f / 255.f) alpha:1.f];
    } else if (temp >= 41 && temp <= 45) {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(254.f / 255.f) green:(87.f / 255.f) blue:(54.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(254.f / 255.f) green:(87.f / 255.f) blue:(54.f / 255.f) alpha:1.f];
    } else {
        if (loc.weatherLocationNightTime)
            return [UIColor colorWithRed:(153.f / 255.f) green:(38.f / 255.f) blue:(54.f / 255.f) alpha:1.f];
        return [UIColor colorWithRed:(255.f / 255.f) green:(75.f / 255.f) blue:(75.f / 255.f) alpha:1.f];
    }
}

- (NSString *)getFormattedDate:(NSDate *)date WithFormat:(NSString *)format {
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:[NSLocale systemLocale]];
    [_weatherLocationsDateFormatter setDateFormat:dateFormat];
    
    return [_weatherLocationsDateFormatter stringFromDate:date];
}

#pragma mark -
#pragma mark UserDefaults

- (void)loadRegistredLocations {
    if (!_weatherLocationsAreLoad) {
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];

        _weatherLocations = [[NSMutableArray alloc] init];
        if ([defaults arrayForKey:WEATHER_SAVE_NAME]) {
            NSArray  *cityNames = [defaults arrayForKey:WEATHER_SAVE_NAME];
            for (NSString *cityName in cityNames) {
                WeatherLocation *city = [[WeatherLocation alloc] initWithDictionary:nil withType:WeatherLocationInformationType3HoursForecasts];
                
                city.weatherLocationName = cityName;
                [_weatherLocations addObject:city];
                [self createWeatherLocationWithCurrentWithName:city.weatherLocationName WithLocation:city];
                [self createWeatherLocationWithForecastWithName:city.weatherLocationName WithLocation:city];
            }
            
        }
        _weatherLocationsAreLoad = YES;
    }
}

- (void)saveRegistredLocations {
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray  *cityNames = [[NSMutableArray alloc] initWithCapacity:_weatherLocations.count];

    for (WeatherLocation *city in _weatherLocations) {
        if (city.weatherLocationName.length) {
            [cityNames addObject:city.weatherLocationName];
        }
    }
    
    [defaults setObject:cityNames forKey:WEATHER_SAVE_NAME];
    [defaults synchronize];
}

- (void) createWeatherLocationWithForecastWithCoord:(CLLocationCoordinate2D)coord WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI forecastWeatherByCoordinate:coord withCallback:^(NSError *error, NSDictionary *result) {
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationType3HoursForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithDailyForecastWithCoord:(CLLocationCoordinate2D)coord WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI dailyForecastWeatherByCoordinate:coord withCount:7 andCallback:^(NSError *error, NSDictionary *result) {
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationTypeDailyForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithCurrentWithCoord:(CLLocationCoordinate2D)coord WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI currentWeatherByCoordinate:coord withCallback:^(NSError *error, NSDictionary *result) {
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationTypeCurrentWeather WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithForecastWithName:(NSString *)name WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI forecastWeatherByCityName:name withCallback:^(NSError *error, NSDictionary *result) {
        city.weatherLocationName = name;
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationType3HoursForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithDailyForecastWithName:(NSString *)name WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI dailyForecastWeatherByCityName:name withCount:_weatherLocationsMaxDailyForecast andCallback:^(NSError *error, NSDictionary *result) {
        city.weatherLocationName = name;
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationTypeDailyForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithCurrentWithName:(NSString *)name WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI currentWeatherByCityName:name withCallback:^(NSError *error, NSDictionary *result) {
        city.weatherLocationName = name;
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationTypeCurrentWeather WithError:error WithCity:city];
    }];
}

- (void)createOrUpdateWeatherLocationWithDict:(NSDictionary *)result WithType:(WeatherLocationInformationType)type WithError:(NSError *)error WithCity:(WeatherLocation *)city {
    ++_weatherLocationsDownloadingNumber;
    [self checkRequests];
    WeatherLocation *location;
    
    
    if (!city) {
        location = [[WeatherLocation alloc] initWithDictionary:result withType:type];
        
        if (location.weatherLocationName.length == 0) {
            return;
        }
        
        for (WeatherLocation *loc in _weatherLocations) {
            if ([location.weatherLocationName isEqualToString:loc.weatherLocationName]) {
                location = loc;
                [location updateWeatherLocation:result withType:type];
                [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_UPDATED object:nil];
                return;
            }
        }
        [_weatherLocations addObject:location];
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_NEW object:nil];
    } else {
        location = city;
        [location updateWeatherLocation:result withType:type];
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_UPDATED object:nil];
        [self checkError:error WithLocation:location];
    }
}

- (void)checkError:(NSError *)error WithLocation:(WeatherLocation *)location {
    if (error) {
        NSLog(@"API call failed");
        location.weatherLocationError = YES;
    } else {
        NSLog(@"Weather information : %@", location.weatherLocationName);
        location.weatherLocationError = NO;
    }
}

#pragma mark -
#pragma mark WeatherUserLocationDelegate

- (void)userLocationDenied {
    NSLog(@"Location denied");
    _weatherLocationsWaitingForCurrentLocation = NO;
}

- (void)userLocationFound {
    NSLog(@"Location found");
    [self userLocationUpdated];
    _weatherLocationsWaitingForCurrentLocation = NO;
}

- (void)userLocationNotFound {
    NSLog(@"Location not found");
    _weatherLocationsWaitingForCurrentLocation = NO;
}

- (void)userLocationUpdated {
    WeatherUserLocationManager  *userLoc = [WeatherUserLocationManager sharedWeatherUserLocationManager];
    
    NSLog(@"Location updated");
    _weatherLocationsWaitingForCurrentLocation = NO;
    [[WeatherUserLocationManager sharedWeatherUserLocationManager] stopUserLocation];
    
    for (WeatherLocation    *location in _weatherLocations) {
        if (location.weatherLocationCoord.latitude == userLoc.weatherUserCurrentLocation.coordinate.latitude && location.weatherLocationCoord.longitude == userLoc.weatherUserCurrentLocation.coordinate.longitude)
        {
            location.weatherLocationCurrent = YES;
            [self createWeatherLocationWithCurrentWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:location];
            [self createWeatherLocationWithForecastWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:location];
        } else {
            location.weatherLocationCurrent = NO;
        }
    }
    WeatherLocation *currentLoc = [[WeatherLocation alloc] initWithDictionary:nil withType:WeatherLocationInformationTypeUnknown];
    
    _weatherLocationCurrent = currentLoc;
    _weatherLocationCurrent.weatherLocationCurrent = YES;
    [_weatherLocations insertObject:_weatherLocationCurrent atIndex:0];
    [self createWeatherLocationWithCurrentWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:_weatherLocationCurrent];
    [self createWeatherLocationWithForecastWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:_weatherLocationCurrent];
}

- (void)checkRequests {
    if (_weatherLocationsDownloadingNumber == _weatherLocationsPendingNumber && !_weatherLocationsWaitingForCurrentLocation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION object:nil userInfo:@{@"index":[NSNumber numberWithInt:0]}];
    } else if (_weatherLocationsDownloadingNumber == _weatherLocationsPendingNumber) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    }
}

@end
