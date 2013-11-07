//
//  WeatherAddCell.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/25/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherAddCell.h"
#import "defines.h"

@implementation WeatherAddCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, WEATHER_LOCATION_CELL_WIDTH, WEATHER_LOCATION_CELL_HEIGHT);
        self.backgroundColor = WEATHER_ADD_CITY_BG_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *img = [UIImage imageNamed:WEATHER_ADD_CITY_IMAGE];
        
        _weatherAddIcon = [[UIImageView alloc] initWithImage:img];
        CGRect  frame = _weatherAddIcon.frame;
        
        frame.origin.x = (self.frame.size.width / 2) - (_weatherAddIcon.frame.size.width / 2);
        frame.origin.y = (self.frame.size.height / 2) - (_weatherAddIcon.frame.size.height / 2);
        _weatherAddIcon.frame = frame;
        [self addSubview:_weatherAddIcon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
