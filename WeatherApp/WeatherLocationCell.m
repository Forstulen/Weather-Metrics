//
//  WeatherLocationCell.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/25/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"
#import "WeatherLocationsManager.h"
#import "WeatherLocationCell.h"
#import "WeatherAnimatedIcon.h"
#import "WeatherLocation.h"
#import "defines.h"

@implementation WeatherLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _weatherLocationIcon = [WeatherAnimatedIcon new];
        
        _weatherLocationCityName = [UILabel new];
        _weatherLocationCityName.textAlignment = NSTextAlignmentLeft;
        _weatherLocationCityName.textColor = [UIColor whiteColor];
        _weatherLocationCityName.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:14];
        _weatherLocationCityName.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _weatherLocationTemp = [UILabel new];
        _weatherLocationTemp.textAlignment = NSTextAlignmentCenter;
        _weatherLocationTemp.textColor = [UIColor whiteColor];
        _weatherLocationTemp.font = [UIFont fontWithName:WEATHER_LOCATION_FONT_NUMBER size:28];
        
        _weatherLocationCurrentLocation = [UIImageView new];
        _weatherLocationCurrentLocation.contentMode = UIViewContentModeCenter;
        
        self.frame = CGRectMake(0, 0, WEATHER_LOCATION_CELL_WIDTH, WEATHER_LOCATION_CELL_HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:_weatherLocationIcon];
        [self.contentView addSubview:_weatherLocationCityName];
        [self.contentView addSubview:_weatherLocationTemp];
        [self.contentView addSubview:_weatherLocationCurrentLocation];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)buildWeatherCell:(WeatherLocation *)location {
    _weatherLocation = location;
    
    [_weatherLocationIcon createIcon:[[WeatherLocationsManager sharedWeatherLocationsManager] getIconFolder:_weatherLocation]withShift:YES];
//    _weatherLocationIcon.contentMode = UIViewContentModeCenter;
    [_weatherLocationIcon startAnimating];
    
    self.backgroundColor = [[WeatherLocationsManager sharedWeatherLocationsManager] getWeatherColorWithLocation:_weatherLocation];
    
    if (_weatherLocationCityName) {
        _weatherLocationCityName.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:location.weatherLocationName withKerning:2];
    } else {
        _weatherLocationCityName.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:WEATHER_LOCATION_ERROR_CITY withKerning:2];
    }
    [_weatherLocationCityName sizeToFit];
    
    if (!_weatherLocation.weatherLocationTemp) {
        _weatherLocationTemp.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:WEATHER_LOCATION_ERROR_TEMP withKerning:0];
    } else {
        _weatherLocationTemp.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:[NSString stringWithFormat:@"%ld%@", (long)[[WeatherLocationsManager sharedWeatherLocationsManager] getConvertedTemperature:_weatherLocation.weatherLocationTemp.integerValue], @"°"] withKerning:0];
    }
    
    _weatherLocationCurrentLocation.image = nil;
    if (_weatherLocation.weatherLocationCurrent) {
        _weatherLocationCurrentLocation.image = [UIImage imageNamed:WEATHER_CURRENT_LOCATION_IMAGE];
    }
}

- (void)layoutSubviews {
    CGRect  frame;
    
    frame = _weatherLocationCityName.frame;
    frame.size.width = WEATHER_LOCATION_CELL_CITY_WIDTH;
    frame.origin.x = WEATHER_LOCATION_CELL_CURRENT_ICON_WIDTH + WEATHER_LOCATION_CELL_CITY_PADDING * 2;
    frame.origin.y = (WEATHER_LOCATION_CELL_HEIGHT / 2) - (frame.size.height / 2);
    _weatherLocationCityName.frame = frame;
    
    frame = _weatherLocationTemp.frame;
    frame.origin.x = _weatherLocationCityName.frame.origin.x + _weatherLocationCityName.frame.size.width + WEATHER_LOCATION_CELL_CITY_PADDING;
    frame.origin.y = 0;
    frame.size.width = WEATHER_LOCATION_CELL_TEMP_WIDTH;
    frame.size.height = WEATHER_LOCATION_CELL_TEMP_HEIGHT;
    _weatherLocationTemp.frame = frame;
    
    frame = _weatherLocationCurrentLocation.frame;
    frame.size.width = WEATHER_LOCATION_CELL_CURRENT_ICON_WIDTH;
    frame.size.height = WEATHER_LOCATION_CELL_CURRENT_ICON_HEIGHT;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _weatherLocationCurrentLocation.frame = frame;
    
    frame = _weatherLocationIcon.frame;
    frame.size.width = WEATHER_LOCATION_CELL_ICON_WIDTH;
    frame.size.height = WEATHER_LOCATION_CELL_ICON_HEIGHT;
    frame.origin.x = (_weatherLocationTemp.frame.origin.x + _weatherLocationTemp.frame.size.width) + (WEATHER_LOCATION_CELL_WIDTH - (_weatherLocationTemp.frame.origin.x + _weatherLocationTemp.frame.size.width)) / 2 - frame.size.width / 2;
    frame.origin.y = WEATHER_LOCATION_CELL_HEIGHT / 2 - frame.size.height / 2;
    _weatherLocationIcon.frame = frame;
}

@end