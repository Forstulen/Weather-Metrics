//
//  WeatherGraphView.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/15/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherGraphView : UIView {
    UIView          *_weatherGraphMask;
}

@property (nonatomic, readwrite) NSArray        *weatherGraphPoints;
@property (nonatomic, readwrite) NSNumber       *weatherGraphMin;
@property (nonatomic, readwrite) NSNumber       *weatherGraphMax;
@property (nonatomic, readwrite) UIColor        *weatherGraphStrokeColor;
@property (nonatomic, readwrite) CGFloat        weatherGraphStrokeWidth;
@property (nonatomic, readwrite) CGPoint        weatherGraphOrigin;
@property (nonatomic, readwrite) CGFloat        weatherGraphDistanceBetweenPoints;
@property (nonatomic, readwrite) NSUInteger     weatherGraphPadding;
@property (nonatomic, readwrite) NSUInteger     weatherGraphRadiusDot;
@end
