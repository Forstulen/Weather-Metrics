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
        _weatherLocationsAreLoad = NO;
        _weatherLocationsTemperatureType = WeatherLocationTemperatureTypeFarenheit;
        _weatherLocationsAlreadyDisplayCurrentLocation = NO;
        _weatherLocationsWaitingForCurrentLocation = YES;
        _weatherLocationsDownloadingNumber = 0;
        _weatherLocationsPendingNumber = 0;
        _weatherLocationsMaxHourForecast = 6;
        _weatherLocationsMaxDailyForecast = 7;
        _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:WEATHER_APP_ID];
        _weatherLocationsDateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[WeatherUserLocationManager sharedWeatherUserLocationManager] stopUserLocation];
    [self saveRegisteredLocations];
}

#pragma mark -
#pragma mark Add / Del

- (void)addLocationWithLocation:(WeatherLocation *)city {
    
}

- (void)addLocationWithName:(NSString *)city {
    NSString    *encodedName = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self createWeatherLocationWithCurrentWithName:encodedName WithLocation:nil];
    [self createWeatherLocationWithForecastWithName:encodedName WithLocation:nil];
}

- (void)delLocation:(WeatherLocation *)city {
    [self.weatherLocations removeObject:city];
}

- (BOOL)updateLocation:(WeatherLocation *)city {
    if (fabs([city.weatherLocationTime timeIntervalSinceDate:[NSDate date]]) >= WEATHER_API_DELAY_REQUEST) {
        [self createWeatherLocationWithCurrentWithName:city.weatherLocationName WithLocation:city];
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
            NSString    *encodedName = [loc.weatherLocationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self createWeatherLocationWithCurrentWithName:encodedName WithLocation:loc];
        [self createWeatherLocationWithForecastWithName:encodedName WithLocation:loc];
    }
}

- (UIColor *)getWeatherColorWithLocation:(WeatherLocation *)loc {
    NSInteger       temp = loc.weatherLocationTemp.integerValue;
    
    if (!loc) {
        return WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR;
    }
    
    if (temp >= 30) {
		return [UIColor colorWithRed:1 green:(64.f / 255.f) blue:(73.f / 255.f) alpha:1];
    } else if (temp >= 20) {
		return [UIColor colorWithRed:(251.f / 255.f) green:(105.f / 255.f) blue:(41.f / 255.f) alpha:1];
    } else if (temp >= 10) {
		return [UIColor colorWithRed:(143.f / 255.f) green:(176.f / 255.f) blue:(65.f / 255.f) alpha:1];
    } else if (temp >= 0) {
		return [UIColor colorWithRed:(80.f / 255.f) green:(191.f / 255.f) blue:(171.f / 255.f) alpha:1];
    } else if (temp >= -10) {
		return [UIColor colorWithRed:(53.f / 255.f) green:(126.f / 255.f) blue:(148.f / 255.f) alpha:1];
    } else {
        return [UIColor colorWithRed:(50.f / 255.f) green:(97.f / 255.f) blue:(150.f / 255.f) alpha:1];
    }
}

- (NSString *)getFormattedDate:(NSDate *)date WithFormat:(NSString *)format {
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:[NSLocale systemLocale]];
    [_weatherLocationsDateFormatter setDateFormat:dateFormat];
    
    return [_weatherLocationsDateFormatter stringFromDate:date];
    // Trim 0
    return [NSString stringWithFormat:@"%ld", (long)[_weatherLocationsDateFormatter stringFromDate:date].integerValue];
}

- (NSInteger)getConvertedTemperature:(NSInteger)temp {
    switch (_weatherLocationsTemperatureType) {
        case WeatherLocationTemperatureTypeCelsius:
            return temp;
        case WeatherLocationTemperatureTypeFarenheit:
            return WEATHER_CELSIUS_TO_FARENHEIT(temp);
        case WeatherLocationTemperatureTypeKelvin:
            return WEATHER_CELSIUS_TO_KELVIN(temp);
        default:
            return temp;
    }
}

- (NSString *)getIconFolder:(WeatherLocation *)loc withFolderType:(WeatherLocationFolderType)type {
    NSString    *iconNameWithoutExt = [loc.weatherLocationIcon stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"nd"]];
    NSString    *fullName;
    
    switch (type) {
        case WeatherLocationFolderTypeBig:
            fullName = [NSString stringWithString:WEATHER_FOLDER_CURRENT_WEATHER];
            break;
        case WeatherLocationFolderTypeForecast:
            fullName = [NSString stringWithString:WEATHER_FOLDER_FORECAST_WEATHER];
        default:
            break;
    }
    
    if (loc.weatherLocationNightTime && ([iconNameWithoutExt isEqualToString:WEATHER_CLEAR_DESCRIPTION] || [iconNameWithoutExt isEqualToString:WEATHER_FEW_CLOUDS_DESCRIPTION])) {
        return [WEATHER_NIGHT_LOCATION stringByAppendingFormat:@" %@", fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_CLEAR_DESCRIPTION]) {
        return [WEATHER_SUNNY_LOCATION stringByAppendingFormat:@" %@", fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_SHOWER_RAIN_DESCRIPTION] || [iconNameWithoutExt isEqualToString:WEATHER_RAIN_DESCRIPTION]) {
        return [WEATHER_RAINY_LOCATION stringByAppendingFormat:@" %@", fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_FEW_CLOUDS_DESCRIPTION]) {
        return [WEATHER_PARTLY_CLOUDY_LOCATION stringByAppendingFormat:@" %@", fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_MIST_DESCRIPTION]) {
        return [WEATHER_FOGGY_LOCATION stringByAppendingFormat:@" %@",fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_SCATTERED_CLOUDS_DESCRIPTION] || [iconNameWithoutExt isEqualToString:WEATHER_BROKEN_CLOUDS_DESCRIPTION]) {
        return [WEATHER_CLOUDY_LOCATION stringByAppendingFormat:@" %@",fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_SNOW_DESCRIPTION]) {
        return [WEATHER_SNOWY_LOCATION stringByAppendingFormat:@" %@",fullName];
    } else if ([iconNameWithoutExt isEqualToString:WEATHER_THUNDERSTORM_DESCRIPTION]) {
        return [WEATHER_THUNDERSTORM_LOCATION stringByAppendingFormat:@" %@",fullName];
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark UserDefaults

- (void)loadRegisteredLocations {
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
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    }
}

- (void)saveRegisteredLocations {
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray  *cityNames = [[NSMutableArray alloc] initWithCapacity:_weatherLocations.count];

    for (WeatherLocation *city in _weatherLocations) {
        if (city.weatherLocationName.length && !city.weatherLocationCurrent) {
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
        city.weatherLocationName = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationType3HoursForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithDailyForecastWithName:(NSString *)name WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI dailyForecastWeatherByCityName:name withCount:_weatherLocationsMaxDailyForecast andCallback:^(NSError *error, NSDictionary *result) {
        city.weatherLocationName = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        [self createOrUpdateWeatherLocationWithDict:result WithType:WeatherLocationInformationTypeDailyForecasts WithError:error WithCity:city];
    }];
}

- (void) createWeatherLocationWithCurrentWithName:(NSString *)name WithLocation:(WeatherLocation *)city {
    ++_weatherLocationsPendingNumber;
    [_weatherAPI currentWeatherByCityName:name withCallback:^(NSError *error, NSDictionary *result) {
        city.weatherLocationName = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
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
            [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_FAILED object:nil];
            return;
        }
        
        for (WeatherLocation *loc in _weatherLocations) {
            if ([location.weatherLocationName isEqualToString:loc.weatherLocationName]) {
                location = loc;
                [location updateWeatherLocation:result withType:type];
                [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_UPDATED object:@{@"location":location}];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_NEW object:nil];
        [_weatherLocations addObject:location];
    } else {
        location = city;
        [location updateWeatherLocation:result withType:type];
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_UPDATED object:@{@"location":location}];
        [self checkError:error WithLocation:location];
    }
    
    location.weatherLocationDisplayForecast = NO;
}

- (void)checkError:(NSError *)error WithLocation:(WeatherLocation *)location {
    if (error) {
        NSLog(@"API call failed %@", error.description);
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
    WeatherLocation     *currentLocation = nil;
    
    NSLog(@"Location updated");
    _weatherLocationsWaitingForCurrentLocation = NO;
    [userLoc stopUserLocation];
    
    currentLocation = [_weatherLocations firstObject];
    if (currentLocation.weatherLocationCurrent) {
        [[WeatherLocationsManager sharedWeatherLocationsManager] delLocation:currentLocation];
    }
    
    WeatherLocation *currentLoc = [[WeatherLocation alloc] initWithDictionary:nil withType:WeatherLocationInformationTypeUnknown];
    
    _weatherLocationCurrent = currentLoc;
    _weatherLocationCurrent.weatherLocationCurrent = YES;
    [_weatherLocations insertObject:_weatherLocationCurrent atIndex:0];
    [self createWeatherLocationWithCurrentWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:_weatherLocationCurrent];
    [self createWeatherLocationWithForecastWithCoord:userLoc.weatherUserCurrentLocation.coordinate WithLocation:_weatherLocationCurrent];
}

- (void)checkRequests {
    if (_weatherLocationsDownloadingNumber == _weatherLocationsPendingNumber && !_weatherLocationsWaitingForCurrentLocation && !_weatherLocationsAlreadyDisplayCurrentLocation) {
        _weatherLocationsAlreadyDisplayCurrentLocation = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION object:nil userInfo:@{@"index":[NSNumber numberWithInt:0]}];
    } else if (_weatherLocationsDownloadingNumber == _weatherLocationsPendingNumber) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    }
}

@end
