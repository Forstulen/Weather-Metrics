//
//  WeatherPageControl.m
//  WeatherMetrics
//
//  Created by Romain Tholimet on 11/17/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherLocationsManager.h"
#import "WeatherPageControl.h"
#import "WeatherLocation.h"
#import "defines.h"

@implementation WeatherPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)updateDots {
    WeatherLocationsManager *locManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    for (NSUInteger i = 0; i < [self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        WeatherLocation *location =locManager.weatherLocations[i];
        if (location.weatherLocationCurrent) {
            dot.image = [UIImage imageNamed:WEATHER_CURRENT_LOCATION_IMAGE];
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
