//
//  WeatherLocationViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherLocationViewController.h"
#import "WeatherLocationsManager.h"
#import "WeatherAnimatedIcon.h"
#import "WeatherGraphView.h"
#import "WeatherLocation.h"
#import "defines.h"

@interface WeatherLocationViewController ()

@property (weak, nonatomic) IBOutlet UIView *weatherBackground;
@property (weak, nonatomic) IBOutlet WeatherGraphView *weatherGraph;
@property (weak, nonatomic) IBOutlet UILabel *weatherCityName;
@property (weak, nonatomic) IBOutlet UILabel *weatherCurrentTemp;
@property (weak, nonatomic) IBOutlet WeatherAnimatedIcon *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *weatherCurrentHumidity;
@property (weak, nonatomic) IBOutlet UIButton *weatherListButton;
@property (weak, nonatomic) IBOutlet UIView *weatherForeCastIcons;
@property (weak, nonatomic) IBOutlet UIView *weatherError;



@end

@implementation WeatherLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildWeatherAndGraph) name:WEATHER_LOCATION_UPDATED object:nil];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    _weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    [self buildWeatherAndGraph];
    [_weatherLocationsManager updateLocation:_weatherLocation];
    [self.weatherIcon startAnimating];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self hideWeatherGraphView];
    [self.weatherIcon stopAnimating];
    [super viewDidDisappear:animated];
}

- (IBAction)displayWeatherList:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_SHOW_LIST object:nil];
}

- (void)buildWeatherAndGraph {
    [self buildWeatherPage];
    [self createIconList];
    [self retrieveTemperatureValuesForGraph];
    [self displayWeatherGraphView];
}

- (void)buildWeatherPage {
    _weatherLocation = [_weatherLocationsManager.weatherLocations objectAtIndex:self.weatherLocationViewIndex];
    
    if (_weatherLocation && !_weatherLocation.weatherLocationError) {
        [self.weatherIcon createIcon:@"sun"];
        self.weatherBackground.backgroundColor = [_weatherLocationsManager getWeatherColorWithLocation:_weatherLocation];
        self.weatherCurrentTemp.text = [NSString stringWithFormat:@"%d%@", _weatherLocation.weatherLocationTemp.intValue, @"°"];
        self.weatherCurrentHumidity.text = [NSString stringWithFormat:@"%d%%", _weatherLocation.weatherLocationHumidity.intValue];
        self.weatherCityName.text = _weatherLocation.weatherLocationName;
        self.weatherError.hidden = YES;
    } else {
        self.weatherError.hidden = NO;
    }
}

- (void)displayWeatherGraphView {
    CGRect  newFrame = CGRectZero;
    CGRect  originalFrame = self.weatherGraph.frame;
    
    newFrame.origin.x = originalFrame.origin.x;
    newFrame.origin.y = originalFrame.origin.y + originalFrame.size.height / 2;
    newFrame.size.width = originalFrame.size.width;
    
    self.weatherGraph.frame = newFrame;
    self.weatherGraph.alpha = 0;
    [UIView animateWithDuration:1.5f animations:^() {
        self.weatherGraph.frame = originalFrame;
        self.weatherGraph.alpha = 1.0f;
   }];
}

- (void)hideWeatherGraphView {
    [UIView animateWithDuration:0.1f animations:^() {
        CGRect  newFrame = CGRectZero;
        
        newFrame.origin.x = self.weatherGraph.frame.origin.x;
        newFrame.origin.y = self.weatherGraph.frame.origin.y + self.weatherGraph.frame.size.height / 2;
        newFrame.size.width = self.weatherGraph.frame.size.width;
        
        self.weatherGraph.frame = newFrame;
        self.weatherGraph.alpha = 0;
    }];
}

- (void)retrieveTemperatureValuesForGraph {
    if (!_weatherLocation.weatherLocationError) {
        NSMutableArray  *temperatures = [[NSMutableArray alloc] init];
        NSUInteger      maximumForecast = _weatherLocationsManager.weatherLocationsMaxHourForecast;
        
        for (WeatherLocation    *foreCast in _weatherLocation.weatherLocationForecasts) {
            [temperatures addObject:@{@"date":foreCast.weatherLocationTime, @"temp":foreCast.weatherLocationTemp}];
            [self setMinAndMaxValueForGraph:foreCast.weatherLocationTemp];
            --maximumForecast;
            
            if (maximumForecast <= 0)
                break;
        }
        self.weatherGraph.weatherGraphPoints = temperatures;
    }
}

//MVP need to do a better job with that
- (void)createIconList {
    NSArray         *subViews = self.weatherForeCastIcons.subviews;
    NSUInteger      index = 0;

    for (WeatherLocation    *foreCast in _weatherLocation.weatherLocationForecasts) {
        WeatherAnimatedIcon     *gif = [subViews objectAtIndex:index];
        
        [gif createIcon:@"sun"];
        [gif startAnimating];
        ++index;
        
        if (index == subViews.count) {
            break;
        }
    }
}


- (void)setMinAndMaxValueForGraph:(NSNumber *)value {
    if (!self.weatherGraph.weatherGraphMin) {
        self.weatherGraph.weatherGraphMin = value;
    } else if (value.intValue < self.weatherGraph.weatherGraphMin.intValue) {
        self.weatherGraph.weatherGraphMin = value;
    }
    
    if (!self.weatherGraph.weatherGraphMax) {
        self.weatherGraph.weatherGraphMax = value;
    } else if (value.intValue > self.weatherGraph.weatherGraphMax.intValue) {
        self.weatherGraph.weatherGraphMax = value;
    }
}


@end
