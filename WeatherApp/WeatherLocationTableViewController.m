//
//  WeatherLocationTableViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

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
        _weatherLocationTableRefresh = [UIRefreshControl new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _weatherLocationTableRefresh = [UIRefreshControl new];
    [_weatherLocationTableRefresh addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_weatherLocationTableRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:WEATHER_LOCATION_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefresh) name:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self createHeader];
}

- (void)handleRefresh {
    [[WeatherLocationsManager sharedWeatherLocationsManager] updateAllLocations];
}

- (void)stopRefresh {
    [self.tableView reloadData];
    [_weatherLocationTableRefresh endRefreshing];
}

- (void)createHeader {
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    UILabel *edit = [UILabel new];
    CGRect  frame;
    
    view.backgroundColor = [UIColor grayColor];
    edit.text = WEATHER_LOCATION_HEADER_TABLE_VIEW;
    edit.textAlignment = NSTextAlignmentCenter;
    edit.font = [UIFont fontWithName:WEATHER_LOCATION_FONT size:18];
    edit.textColor = [UIColor whiteColor];
    [edit sizeToFit];
    [view addSubview:edit];
    frame = edit.frame;
    frame.origin.x = (view.frame.size.width / 2) - (edit.frame.size.width / 2);
    frame.origin.y = (view.frame.size.height / 2) - (edit.frame.size.height / 2);
    edit.frame = frame;
    
    self.tableView.tableHeaderView = view;
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
    [self.tableView reloadData];
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
        [[WeatherLocationsManager sharedWeatherLocationsManager] addNewLocationWithName:name];
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString    *cityName = [[_weatherLocationAddLocation textFieldAtIndex:0] text];
    
    [self checkNewLocation:cityName];
    [_weatherLocationAddLocation dismissWithClickedButtonIndex:-1 animated:YES];
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherLocationsManager     *weatherLocationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [weatherLocationsManager delNewLocation:[weatherLocationsManager.weatherLocations objectAtIndex:indexPath.row - 1]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
 
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
