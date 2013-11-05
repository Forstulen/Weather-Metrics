//
//  WeatherUserLocation.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherUserLocationManager.h"
#import "defines.h"

@interface WeatherUserLocationManager (Private)

- (id)init;

@end

@implementation WeatherUserLocationManager

+ (id)sharedWeatherUserLocationManager {
    static WeatherUserLocationManager *shared = nil;
    @synchronized(self) {
        if (shared == nil)
            shared = [[self alloc] init];
    }
    return shared;
}

- (id)init {
    if (self = [super init]) {
        _weatherUserLocationDistance = WEATHER_LOCATION_DISTANCE;
        _weatherUserLocationAccuracy = kCLLocationAccuracyKilometer;
        _weatherUserCurrentLocation = nil;
    }
    return self;
}

- (void)startUserLocation {
    if (_weatherUserLocationManager == nil) {
        _weatherUserLocationManager = [[CLLocationManager alloc] init];
        _weatherUserLocationManager.delegate = self;
        _weatherUserLocationManager.desiredAccuracy = _weatherUserLocationAccuracy;
        _weatherUserLocationManager.distanceFilter = _weatherUserLocationDistance;
        [_weatherUserLocationManager startUpdatingLocation];
    }
}

- (void)stopUserLocation {
    if (_weatherUserLocationManager != nil) {
        [_weatherUserLocationManager stopUpdatingLocation];
        _weatherUserLocationManager = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (manager == _weatherUserLocationManager) {
        _weatherUserCurrentLocation = [locations lastObject];
        if (_weatherUserLocationDelegate) {
            if (_weatherUserCurrentLocation != nil) {
                [_weatherUserLocationDelegate userLocationUpdated];
            } else {
                [_weatherUserLocationDelegate userLocationFound];
            }
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (manager == _weatherUserLocationManager) {
        switch (error.code) {
            case kCLErrorHeadingFailure:
                [self stopUserLocation];
                if (_weatherUserLocationDelegate) {
                    [_weatherUserLocationDelegate userLocationNotFound];
                }
                break;
            case kCLErrorDenied:
                [self stopUserLocation];
                if (_weatherUserLocationDelegate) {
                    [_weatherUserLocationDelegate userLocationDenied];
                }
                break;
            case kCLErrorLocationUnknown:
                NSLog(@"Location unknown");
                break;
            default:
                break;
        }
    }
}

@end
