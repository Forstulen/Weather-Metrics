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
        self.backgroundColor = [UIColor greenColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _weatherAddIcon = [UIImageView new];
        CGRect  frame = _weatherAddIcon.frame;
        
        frame.origin.x = (self.frame.size.width / 2) - (_weatherAddIcon.frame.size.width / 2);
        frame.origin.y = (self.frame.size.height / 2) - (_weatherAddIcon.frame.size.height / 2);
        _weatherAddIcon.frame = frame;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
