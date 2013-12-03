//
//  WeatherLocationTableViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"
#import "WeatherLocationTableViewController.h"
#import "WeatherLocationsManager.h"
#import "WeatherLocationCell.h"
#import "WeatherLocation.h"
#import "WeatherAddCell.h"
#import "defines.h"

@interface WeatherLocationTableViewController ()

@end

@implementation WeatherLocationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _weatherLocationTableRefresh = [UIRefreshControl new];
    _weatherLocationIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, WEATHER_LOCATION_CELL_WIDTH, WEATHER_LOCATION_CELL_HEIGHT)];
    _weatherLocationIndicator.color = WEATHER_LIGH_GREY_BG_COLOR;
    [_weatherLocationTableRefresh addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
    [NSTimer scheduledTimerWithTimeInterval:WEATHER_CLOCK_INTERVAL target:self selector:@selector(createClock) userInfo:nil repeats:YES];
    _weatherLocationClock = [UILabel new];
    
    [self.tableView addSubview:_weatherLocationTableRefresh];
    self.tableView.tableFooterView = _weatherLocationIndicator;
    [self createClock];
    [self createHeader];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:WEATHER_LOCATION_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failUpdateData) name:WEATHER_LOCATION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefresh) name:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefresh) name:WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION object:nil];
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)handleRefresh {
    [[WeatherLocationsManager sharedWeatherLocationsManager] updateAllLocations];
}

- (void)stopRefresh {
    [self.tableView reloadData];
    [_weatherLocationTableRefresh endRefreshing];
}

- (NSDate *)findStartDateForClock {
    NSDateComponents *time = [[NSCalendar currentCalendar]
    						  components:NSSecondCalendarUnit
    						  fromDate:[NSDate date]];
    
    NSInteger           secondsLeft = [time second] % 60;
    
    return [NSDate dateWithTimeInterval:(60 - secondsLeft) sinceDate:[NSDate date]];
}

- (void)createClock {
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"h" options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateFormat];
    _weatherLocationClock.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:[dateFormatter stringFromDate:[NSDate date]] withKerning:1];
    [_weatherLocationClock sizeToFit];
    _weatherLocationClock.textAlignment = NSTextAlignmentLeft;
    _weatherLocationClock.font = [UIFont fontWithName:WEATHER_LOCATION_FONT_NUMBER size:22];
    _weatherLocationClock.textColor = WEATHER_LIGH_GREY_BG_COLOR;
    
    CGRect frame;
    
    frame = _weatherLocationClock.frame;
    frame.size.height = _weatherLocationClock.superview.frame.size.height;
    frame.size.width = _weatherLocationClock.superview.frame.size.height * 2;
    frame.origin.x = 10;
    frame.origin.y = 0;
    _weatherLocationClock.frame = frame;
}

- (void)createHeader {
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WEATHER_TABLE_VIEW_TOP_BAR_WIDTH, WEATHER_TABLE_VIEW_TOP_BAR_HEIGHT)];
    UILabel *edit = [UILabel new];
    UIButton *temperatureType = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString    *text = @"F°/C°";
    NSMutableAttributedString *titleButton = [[NSMutableAttributedString alloc] initWithString:text];

    
    WeatherLocationsManager *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    if (weatherLocationsManager.weatherLocationsTemperatureType == WeatherLocationTemperatureTypeCelsius) {
        [titleButton addAttribute: NSForegroundColorAttributeName value:WEATHER_ADD_CITY_BG_COLOR range:[text rangeOfString:@"C°"]];
        [titleButton addAttribute: NSForegroundColorAttributeName value:WEATHER_LIGH_GREY_BG_COLOR range:[text rangeOfString:@"F°/"]];
    } else {
        [titleButton addAttribute: NSForegroundColorAttributeName value:WEATHER_ADD_CITY_BG_COLOR range:[text rangeOfString:@"F°"]];
        [titleButton addAttribute: NSForegroundColorAttributeName value:WEATHER_LIGH_GREY_BG_COLOR range:[text rangeOfString:@"/C°"]];
    }
    [temperatureType setAttributedTitle:titleButton forState:UIControlStateNormal];
    
    temperatureType.frame = view.frame;
    temperatureType.titleLabel.numberOfLines = 1;
    temperatureType.titleLabel.textAlignment = NSTextAlignmentCenter;
    [temperatureType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    temperatureType.titleLabel.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:22];
    [temperatureType addTarget:self action:@selector(changeTemperatureType) forControlEvents:UIControlEventTouchDown];
    
    [view addSubview:temperatureType];
    [view addSubview:edit];
    [view addSubview:_weatherLocationClock];
    
    CGRect  frame;
    
    view.backgroundColor = [UIColor whiteColor];
    edit.attributedText = [NSMutableAttributedString mutableAttributedStringWithText:WEATHER_LOCATION_HEADER_TABLE_VIEW withKerning:2];
    edit.textAlignment = NSTextAlignmentCenter;
    edit.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:16];
    edit.textColor = WEATHER_LIGH_GREY_BG_COLOR;
    [edit sizeToFit];
    
    frame = edit.frame;
    frame.origin.x = (view.frame.size.width / 2) - (edit.frame.size.width / 2);
    frame.origin.y = (view.frame.size.height / 2) - (edit.frame.size.height / 2);
    edit.frame = frame;
    
    frame = temperatureType.frame;
    frame.size.height = view.frame.size.height;
    frame.size.width = view.frame.size.height;
    frame.origin.x = view.frame.size.width - frame.size.width - 10;
    frame.origin.y = 0;
    temperatureType.frame = frame;
    
    frame = _weatherLocationClock.frame;
    frame.size.height = view.frame.size.height;
    frame.size.width = view.frame.size.height * 2;
    frame.origin.x = 10;
    frame.origin.y = 0;
    _weatherLocationClock.frame = frame;
    
    self.tableView.tableHeaderView = view;
}

- (void)changeTemperatureType {
    WeatherLocationsManager *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    if (weatherLocationsManager.weatherLocationsTemperatureType == WeatherLocationTemperatureTypeCelsius) {
        weatherLocationsManager.weatherLocationsTemperatureType = WeatherLocationTemperatureTypeFarenheit;
    } else {
        weatherLocationsManager.weatherLocationsTemperatureType = WeatherLocationTemperatureTypeCelsius;
    }
    [self createHeader];
    [self stopRefresh];
}

- (void)focusPageViewed:(NSUInteger)index withPosition:(UITableViewScrollPosition)position {

    // We add 1 because 0 is the cell with the plus icon
    NSIndexPath     *indexPath = [NSIndexPath indexPathForRow:(index + 1) inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:YES];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateData {
    [_weatherLocationIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)scrollAfterNewCell {
    WeatherLocationsManager *locManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    [self focusPageViewed:(locManager.weatherLocations.count - 1) withPosition:UITableViewScrollPositionBottom];
}

- (void)failUpdateData {
    [_weatherLocationIndicator stopAnimating];
    if (!_weatherLocationFailureAlert) {
        _weatherLocationFailureAlert = YES;
        UIAlertView *weatherError = [[UIAlertView alloc] initWithTitle:WEATHER_LOCATION_ALERT_FAIL_TITLE message:WEATHER_LOCATION_ALERT_FAIL_MESSAGE delegate:self cancelButtonTitle:WEATHER_LOCATION_ALERT_FAIL_VALIDATE_BUTTON_TITLE otherButtonTitles:nil];
        [weatherError show];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WEATHER_LOCATION_ROW_HEIGHT;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WeatherLocationsManager     *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    return weatherLocationsManager.weatherLocations.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger  row = indexPath.row;
    
    if (row != 0) {
        WeatherLocationsManager     *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
        WeatherLocation *loc = weatherLocationsManager.weatherLocations[row - 1];
        
        NSString *CellIdentifier = NSStringFromClass([WeatherLocationCell class]);
        WeatherLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WeatherLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell buildWeatherCell:loc];
        return cell;
    } else {
        NSString *CellIdentifier = NSStringFromClass([WeatherAddCell class]);
        WeatherAddCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WeatherAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_LOCATION_SHOW_PAGE object:nil userInfo:@{@"index":[NSNumber numberWithInteger:indexPath.row - 1]}];
    } else {
        _weatherLocationAddLocation = [[UIAlertView alloc] initWithTitle:WEATHER_LOCATION_ALERT_TITLE message:nil
                                                         delegate:self
                                                cancelButtonTitle:WEATHER_LOCATION_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:WEATHER_LOCATION_ALERT_VALIDATE_BUTTON_TITLE, nil];

        _weatherLocationAddLocation.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_weatherLocationAddLocation textFieldAtIndex:0].delegate = self;
        [_weatherLocationAddLocation show];
    }
}

- (void)checkNewLocation:(NSString *)name {
    if (name.length >= 3) {
        [_weatherLocationIndicator startAnimating];
        [[WeatherLocationsManager sharedWeatherLocationsManager] addLocationWithName:name];
    } else {
        UIAlertView *warning = [UIAlertView new];
        
        warning.alertViewStyle = UIAlertViewStyleDefault;
        [warning addButtonWithTitle:WEATHER_LOCATION_WARNING_BUTTON_TITLE];
        warning.delegate = nil;
        warning.title = WEATHER_LOCATION_WARNING_TITLE;
        [warning show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString    *cityName = [[alertView textFieldAtIndex:0] text];
        
        [self checkNewLocation:cityName];
    }
    _weatherLocationFailureAlert = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString    *cityName = [[_weatherLocationAddLocation textFieldAtIndex:0] text];
    
    [self checkNewLocation:cityName];
    [_weatherLocationAddLocation dismissWithClickedButtonIndex:-1 animated:YES];
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherLocationsManager     *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [weatherLocationsManager delLocation:[weatherLocationsManager.weatherLocations objectAtIndex:indexPath.row - 1]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
