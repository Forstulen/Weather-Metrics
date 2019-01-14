//
//  WeatherLocationViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"
#import "WeatherLocationViewController.h"
#import "WeatherLocationsManager.h"
#import "NSDictionaryAdditions.h"
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
@property (weak, nonatomic) IBOutlet UIButton *weatherListButton;
@property (weak, nonatomic) IBOutlet UIView *weatherForeCastIcons;
@property (weak, nonatomic) IBOutlet UIImageView *weatherForecastCurrentSquare;
@property (weak, nonatomic) IBOutlet UILabel *weatherForecastError;
@property (weak, nonatomic) IBOutlet UIView *weatherGraphMask;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherGraphMaskLeadingAlignment;
@property (weak, nonatomic) IBOutlet UIView *weatherSwitchView;
@property (weak, nonatomic) IBOutlet WeatherAnimatedIcon *weatherSwitchIcon;


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
    [super viewDidLoad];
    self.weatherCityName.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:18];
    self.weatherCityName.textColor = WEATHER_BLACK_HIGHLIGHT_BAR_COLOR;
    self.weatherCityName.textColor = WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR;
    self.weatherCurrentTemp.font = [UIFont fontWithName:WEATHER_LOCATION_FONT_NUMBER size:24];
    self.weatherCurrentTemp.textColor = WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR;
    self.weatherForeCastIcons.backgroundColor = WEATHER_BLACK_HIGHLIGHT_BAR_COLOR;
    self.weatherForecastError.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:14];
    self.weatherForecastError.textColor = WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR;
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
}

- (void)handleSwipeUpFrom:(id)sender {
    _weatherLocation.weatherLocationDisplayForecast = YES;
    [self animateViewFrame];
}

- (void)handleSwipeDownFrom:(id)sender {
    _weatherLocation.weatherLocationDisplayForecast = NO;
    [self animateViewFrame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildWeatherAndGraph:) name:WEATHER_LOCATION_UPDATED object:nil];
    
    _weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    [_weatherLocationsManager updateLocation:_weatherLocation];
    
    [self buildWeatherAndGraph:nil];
    
    if (!_weatherLocation.weatherLocationDisplayForecast) {
        self.weatherSwitchView.alpha = 1.0f;
        self.weatherSwitchView.hidden = NO;
        self.weatherGraphMaskLeadingAlignment.constant = 0;
        [self.view layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_weatherLocation.weatherLocationDisplayForecast) {
        self.weatherSwitchView.alpha = 0.0f;
        self.weatherSwitchView.hidden = YES;
        [self displayWeatherGraphView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hideWeatherGraphView];
}

- (IBAction)displayWeatherList:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_SHOW_LIST object:nil];
}

- (void)buildWeatherAndGraph:(NSNotification *)notif {
    if (notif) {
        NSDictionary    *userInfo = [notif userInfo];
        WeatherLocation *loc = [userInfo safeObjectForKey:@"location"];
        
        if ([loc.weatherLocationName isEqual:_weatherLocation.weatherLocationName])
            return;
    }
    [self buildWeatherPage];
    [self createIconList];
    [self retrieveTemperatureValuesForGraph];
}

- (void)buildWeatherPage {
    _weatherLocation = [_weatherLocationsManager.weatherLocations objectAtIndex:self.weatherLocationViewIndex];
    if (_weatherLocation && !_weatherLocation.weatherLocationError) {
        [self.weatherIcon createIcon:[_weatherLocationsManager getIconFolder:_weatherLocation withFolderType:WeatherLocationFolderTypeBig]withShift:NO];
        [self.weatherIcon startAnimating];
        [self.weatherSwitchIcon createIcon:[_weatherLocationsManager getIconFolder:_weatherLocation withFolderType:WeatherLocationFolderTypeBig]withShift:NO];
        [self.weatherSwitchIcon startAnimating];
        
        self.weatherBackground.backgroundColor = [_weatherLocationsManager getWeatherColorWithLocation:_weatherLocation];
        self.weatherSwitchView.backgroundColor = [_weatherLocationsManager getWeatherColorWithLocation:_weatherLocation];
        
        self.weatherForeCastIcons.backgroundColor = self.weatherBackground.backgroundColor;
        self.weatherCurrentTemp.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:[NSString stringWithFormat:@"%ld%@", (long)[_weatherLocationsManager getConvertedTemperature:_weatherLocation.weatherLocationTemp.integerValue], @"°"] withKerning:0];
        self.weatherCityName.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:[NSString stringWithFormat:@"%@, %@", _weatherLocation.weatherLocationName, _weatherLocation.weatherLocationCountry] withKerning:2];
    } else {
        self.weatherCityName.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:WEATHER_LOCATION_ERROR_CITY withKerning:2];
        if (_weatherLocation) {
            [_weatherLocationsManager updateLocation:_weatherLocation];
        }
    }
}

- (void)displayWeatherGraphView {
    if (_weatherLocation.weatherLocationDisplayForecast) {
        if (self.weatherGraphMaskLeadingAlignment.constant < self.weatherGraphMask.frame.size.width) {
            self.weatherGraphMaskLeadingAlignment.constant = self.weatherGraphMask.frame.size.width;
            [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^() {
                [self.view layoutIfNeeded];
            } completion:nil];
        }
    }
}

- (void)hideWeatherGraphView {
    if (!_weatherLocation.weatherLocationDisplayForecast) {
        self.weatherGraphMaskLeadingAlignment.constant = 0;
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^() {
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}


- (IBAction)collapseGraph:(id)sender {
    _weatherLocation.weatherLocationDisplayForecast = !_weatherLocation.weatherLocationDisplayForecast;
    [self animateViewFrame];
}

- (IBAction)collapseSwitchView:(id)sender {
    [self collapseGraph:nil];
}

- (void)animateViewFrame {
    self.weatherSwitchView.alpha = 0.0f;
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve    animations:^() {
        if (self->_weatherLocation.weatherLocationDisplayForecast) {
            self.weatherSwitchView.alpha = 0.0f;
            self.weatherSwitchView.hidden = YES;
            [self displayWeatherGraphView];
        } else {
            self.weatherSwitchView.alpha = 1.0f;
            self.weatherSwitchView.hidden = NO;
            [self hideWeatherGraphView];
        }
    } completion:nil];
}

- (void)retrieveTemperatureValuesForGraph {
    if (!_weatherLocation.weatherLocationError && _weatherLocation.weatherLocationForecasts.count) {
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
    } else {
        self.weatherForecastError.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:WEATHER_LOCATION_FORECAST_ERROR withKerning:2];
    }
}

//MVP need to do a better job with that
- (void)createIconList {
    NSArray         *subViews = self.weatherForeCastIcons.subviews;
    NSUInteger      index = 0;
    BOOL            firstElem = YES;

    for (WeatherLocation    *foreCast in _weatherLocation.weatherLocationForecasts) {
        WeatherAnimatedIcon     *gif = [subViews objectAtIndex:index];
        
        if ([gif isEqual:self.weatherForecastCurrentSquare]) {
            ++index;
            gif = [subViews objectAtIndex:index];
        }
        if (!firstElem) {
            gif.backgroundColor = WEATHER_BLACK_HIGHLIGHT_BAR_COLOR;
        }
        firstElem = NO;
        [gif createIcon:[_weatherLocationsManager getIconFolder:foreCast withFolderType:WeatherLocationFolderTypeForecast]withShift:YES];
        [gif startAnimating];
        ++index;
        
        if (subViews.count == index) {
            return;
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
