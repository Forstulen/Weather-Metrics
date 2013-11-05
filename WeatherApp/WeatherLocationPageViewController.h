//
//  WeatherLocationPageViewController.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherLocationPageViewController : UIViewController <UIPageViewControllerDataSource> {
    
    UIPageViewController    *_weatherLocationPageController;
}

@property (nonatomic) UIPageViewController *weatherLocationPageController;
@property (nonatomic, readwrite)    NSUInteger  weatherLocationPageStartIndex;

@end
