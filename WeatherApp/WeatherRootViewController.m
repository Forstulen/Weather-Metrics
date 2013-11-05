//
//  WeatherRootViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherRootViewController.h"
#import "WeatherLocationPageViewController.h"
#import "WeatherLocationTableViewController.h"
#import "WeatherLocationsManager.h"
#import "NSDictionaryAdditions.h"
#import "defines.h"

@interface WeatherRootViewController ()

@property UIViewController  *currentController;

@end

@implementation WeatherRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[WeatherLocationsManager sharedWeatherLocationsManager] loadRegistredLocations];
        
        _weatherLocationPageViewController = [[WeatherLocationPageViewController alloc] initWithNibName:NSStringFromClass([WeatherLocationPageViewController class]) bundle:nil];
        _weatherLocationTableViewController = [[WeatherLocationTableViewController alloc] initWithNibName:NSStringFromClass([WeatherLocationTableViewController class]) bundle:nil];
        _weatherStartingViewType = WeatherTableViewController;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPageViewController:) name:WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPageViewController:) name:WEATHER_LOCATION_SHOW_PAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentTableViewController) name:WEATHER_LOCATIONS_UP_TO_DATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentTableViewController) name:WEATHER_LOCATION_SHOW_LIST object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [self prefersStatusBarHidden];
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentPageViewController:(NSNotification *)notification {
    NSDictionary    *userInfo = [notification userInfo];
    NSNumber    *index = [userInfo safeObjectForKey:@"index"];
    
    if (!index) {
        _weatherLocationPageViewController.weatherLocationPageStartIndex = 0;
    } else {
        _weatherLocationPageViewController.weatherLocationPageStartIndex = index.integerValue;
    }
    
    if (!self.currentController) {
        [self presentController:_weatherLocationPageViewController];
    } else if (self.currentController != _weatherLocationPageViewController) {
        [self swapCurrentControllerWith:_weatherLocationPageViewController];
    }
}

- (void)presentTableViewController {
    if (!self.currentController) {
        [self presentController:_weatherLocationTableViewController];
    } else if (self.currentController != _weatherLocationTableViewController) {
        [self swapCurrentControllerWith:_weatherLocationTableViewController];
    }
}

- (void)presentController:(UIViewController*)newContent{

    if (self.currentController){
        [self removeCurrentViewController];
    }

    [self addChildViewController:newContent];
    newContent.view.frame = [self frameForContentController];
    [self.view addSubview:newContent.view];
    self.currentController = newContent;

    [newContent didMoveToParentViewController:self];
}

- (void)removeCurrentViewController{
    [self.currentController willMoveToParentViewController:nil];
    [self.currentController.view removeFromSuperview];
    [self.currentController removeFromParentViewController];
}

- (CGRect)frameForContentController{
    CGRect frame = self.view.bounds;
    
    return frame;
}

- (void)swapCurrentControllerWith:(UIViewController*)viewController{
    NSInteger   newViewHeight = viewController.view.frame.size.height;
    NSInteger   currentViewHeight = self.currentController.view.frame.size.height;
    
    if (viewController == _weatherLocationTableViewController) {
        newViewHeight = -newViewHeight;
    } else {
        currentViewHeight = -currentViewHeight;
    }
    
    [self.currentController willMoveToParentViewController:nil];
    [self addChildViewController:viewController];
    viewController.view.frame = CGRectMake(0, newViewHeight, viewController.view.frame.size.width, viewController.view.frame.size.height);
    [self.view addSubview:viewController.view];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         viewController.view.frame = self.currentController.view.frame;
                         self.currentController.view.frame = CGRectMake(0, currentViewHeight, self.currentController.view.frame.size.width, self.currentController.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self.currentController.view removeFromSuperview];
                         [self.currentController removeFromParentViewController];
                         self.currentController = viewController;                         [self.currentController didMoveToParentViewController:self];
                     }];
    
}

@end
