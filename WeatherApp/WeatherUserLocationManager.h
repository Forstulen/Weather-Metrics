//
//  WeatherUserLocation.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WeatherUserLocationDelegate <NSObject>
@optional
- (void)userLocationFound;
- (void)userLocationUpdated;
- (void)userLocationNotFound;
@required
- (void)userLocationDenied;
@end

@interface WeatherUserLocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager  *_weatherUserLocationManager;
    CLLocation          *_weatherUserCurrentLocation;
    NSInteger           _weatherUserLocationDistance;
    CLLocationAccuracy  _weatherUserLocationAccuracy;
    id<WeatherUserLocationDelegate>                  _weatherUserLocationDelegate;
}

+ (id)sharedWeatherUserLocationManager;

- (void)startUserLocation;
- (void)stopUserLocation;

@property (nonatomic, readwrite)    NSInteger   weatherUserLocationDistance;
@property (nonatomic, readwrite)    CLLocationAccuracy  weatherUserLocationAccuracy;
@property (nonatomic)               id<WeatherUserLocationDelegate>  weatherUserLocationDelegate;
@property (nonatomic, readonly)     CLLocation  *weatherUserCurrentLocation;

@end
