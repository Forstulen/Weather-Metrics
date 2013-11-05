	//
//  WeatherLocationPageViewController.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherLocationPageViewController.h"
#import "WeatherLocationViewController.h"
#import "WeatherLocationsManager.h"
#import "defines.h"

@interface WeatherLocationPageViewController ()

@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation WeatherLocationPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.weatherLocationPageStartIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{    _weatherLocationPageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _weatherLocationPageController.dataSource = self;
    _weatherLocationPageController.view.frame = [[self view] bounds];
    _weatherLocationPageController.view.backgroundColor = self.view.backgroundColor;
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    WeatherLocationViewController *initialViewController = [self viewControllerAtIndex:self.weatherLocationPageStartIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_weatherLocationPageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:_weatherLocationPageController];
    [[self view] addSubview:_weatherLocationPageController.view];
    [_weatherLocationPageController didMoveToParentViewController:self];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WeatherLocationViewController *)viewControllerAtIndex:(NSUInteger)index {
    WeatherLocationViewController *viewController = [[WeatherLocationViewController alloc] initWithNibName:NSStringFromClass([WeatherLocationViewController class]) bundle:nil];
    
    viewController.weatherLocationViewIndex = index;
    
    return viewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(WeatherLocationViewController*)viewController weatherLocationViewIndex];
    
    if (index == 0) {
        return nil;
    }
    --index;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(WeatherLocationViewController*)viewController weatherLocationViewIndex];
 
    if (index == ([self presentationCountForPageViewController:_weatherLocationPageController] - 1)) {
        return nil;
    }
    ++index;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    WeatherLocationsManager *locationsManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    return locationsManager.weatherLocations.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.weatherLocationPageStartIndex;
}

@end
