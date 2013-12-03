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

- (void)viewDidLoad {
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    _weatherLocationPageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _weatherLocationPageController.dataSource = self;
    _weatherLocationPageController.delegate = self;
    _weatherLocationPageController.view.frame = [[self view] bounds];
    _weatherLocationPageController.view.backgroundColor = self.view.backgroundColor;
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    WeatherLocationViewController *initialViewController = [self viewControllerAtIndex:self.weatherLocationPageStartIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

    self.weatherLocationCurrentPage = self.weatherLocationPageStartIndex;
    //We chose NO because there is a bug with it http://stackoverflow.com/questions/12939280/uipageviewcontroller-navigates-to-wrong-page-with-scroll-transition-style/12939384#12939384
    [_weatherLocationPageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = WEATHER_LIGH_GREY_BG_COLOR;
    pageControl.currentPageIndicatorTintColor = WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR;
    pageControl.backgroundColor = [UIColor whiteColor];
      
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
    
    _weatherLocationPageDirection = WeatherLocationPageViewControllerRightDirection;
    --self.weatherLocationCurrentPage;
    if (index == 0) {
        return nil;
    }
    --index;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(WeatherLocationViewController*)viewController weatherLocationViewIndex];
 
    _weatherLocationPageDirection = WeatherLocationPageViewControllerLeftDirection;
    ++self.weatherLocationCurrentPage;
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        WeatherLocationViewController   *previousPage = [previousViewControllers lastObject];
        
        self.weatherLocationCurrentPage = previousPage.weatherLocationViewIndex;
    }
}

@end
