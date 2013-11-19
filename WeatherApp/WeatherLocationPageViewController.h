//
//  WeatherLocationPageViewController.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WeatherLocationPageViewControllerLeftDirection,
    WeatherLocationPageViewControllerRightDirection
}WeatherLocationPageViewControllerLastDirection;

@interface WeatherLocationPageViewController : UIViewController <UIPageViewControllerDataSource, UIScrollViewDelegate, UIPageViewControllerDelegate> {
    
    UIPageViewController    *_weatherLocationPageController;
    WeatherLocationPageViewControllerLastDirection            _weatherLocationPageDirection;
}

@property (nonatomic) UIPageViewController *weatherLocationPageController;
@property (nonatomic, readwrite)    NSUInteger  weatherLocationPageStartIndex;
@property (nonatomic, readwrite) NSUInteger weatherLocationCurrentPage;

@end
