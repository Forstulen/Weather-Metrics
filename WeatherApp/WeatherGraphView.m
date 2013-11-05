//
//  WeatherGraphView.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/15/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherLocationsManager.h"
#import "NSDictionaryAdditions.h"
#import "WeatherGraphView.h"

@implementation WeatherGraphView

- (void) initializeWeatherGraphValue {
    self.weatherGraphPoints = [[NSArray alloc] init];
    self.weatherGraphOrigin = CGPointMake(0, self.frame.size.height);
    self.weatherGraphStrokeColor = [UIColor redColor];
    self.weatherGraphStrokeWidth = 2.0f;
    self.weatherGraphPadding = 40.f;
    self.weatherGraphRadiusDot = 12;
}

- (id) initWithCoder:(NSCoder *)aCoder {
    if (self = [super initWithCoder:aCoder]) {
        [self initializeWeatherGraphValue];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeWeatherGraphValue];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath    *graph = [UIBezierPath bezierPath];
    CGPoint         currentPoint;
    CGPoint         previousPoint;
    CGContextRef    context = UIGraphicsGetCurrentContext();
    WeatherLocationsManager *weatherManager = [WeatherLocationsManager sharedWeatherLocationsManager];
    
    [graph moveToPoint:currentPoint];
    [graph setFlatness:0.3f];
    [graph setLineWidth:self.weatherGraphStrokeWidth];
    [self.weatherGraphStrokeColor setStroke];
    self.weatherGraphDistanceBetweenPoints = self.frame.size.width / (self.weatherGraphPoints.count - 2);
    
    currentPoint = [self getFirstPoint];
    previousPoint = currentPoint;
    for (NSDictionary   *dict in self.weatherGraphPoints) {
        NSNumber    *value = [dict safeObjectForKey:@"temp"];
        
        currentPoint.y = [self getRealValue:value.integerValue];
            
        [graph addCurveToPoint:currentPoint controlPoint1:[self getFirstControlPoint:currentPoint PreviousPoint:previousPoint] controlPoint2:[self getSecondControlPoint:currentPoint PreviousPoint:previousPoint]];
        previousPoint = currentPoint;
        currentPoint.x += self.weatherGraphDistanceBetweenPoints;
    }
    [graph stroke];
    [graph closePath];
    
    currentPoint = [self getFirstPoint];
    previousPoint = currentPoint;
    for (NSDictionary   *dict in self.weatherGraphPoints) {
        NSNumber    *value = [dict safeObjectForKey:@"temp"];
        NSDate      *date = [dict safeObjectForKey:@"date"];
        NSString    *str = [NSString stringWithFormat:@"%d°", [weatherManager getConvertedTemperature:value.integerValue]];
        UIFont      *font = [UIFont fontWithName:@"Helvetica" size:8];
        CGSize      size;
        
        currentPoint.y = [self getRealValue:value.integerValue];
        CGRect      rect = CGRectMake(currentPoint.x - self.weatherGraphRadiusDot, currentPoint.y - self.weatherGraphRadiusDot, self.weatherGraphRadiusDot << 1, self.weatherGraphRadiusDot << 1);
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextFillEllipseInRect(context, rect);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        size = [str sizeWithFont:font];
        rect.origin.y += (rect.size.height - size.height) / 2;
        [str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        previousPoint = currentPoint;
        currentPoint.x += self.weatherGraphDistanceBetweenPoints;
        [self addLabel:date WithRect:rect];
        CGContextRestoreGState(context);
    }

}

- (void)addLabel:(NSDate *)date WithRect:(CGRect)rect {
    if (rect.origin.x >= 0 && rect.origin.x <= self.frame.size.width) {
        WeatherLocationsManager *weatherManager = [WeatherLocationsManager sharedWeatherLocationsManager];
        rect.origin.y = 0;
        UILabel     *label = [[UILabel alloc] initWithFrame:rect];
        
        label.font = [UIFont fontWithName:@"Helvetica" size:12];
        label.textColor = [UIColor whiteColor];
        label.text = [weatherManager getFormattedDate:date WithFormat:@"H"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

- (CGPoint)getFirstPoint {
    NSDictionary    *dict = [self.weatherGraphPoints firstObject];
    NSNumber    *firstPoint = [dict safeObjectForKey:@"temp"];
    CGPoint     firstPointCoordinates;
    
    firstPointCoordinates.y = [self getRealValue:firstPoint.integerValue];
    firstPointCoordinates.x = -self.weatherGraphDistanceBetweenPoints / 2;
    
    return firstPointCoordinates;
}

- (CGPoint)getFirstControlPoint:(CGPoint)cur PreviousPoint:(CGPoint)prev {
    CGPoint     controlPoint = CGPointZero;
    
    controlPoint.x = prev.x + (cur.x - prev.x) / 2;
    controlPoint.y = prev.y;
    
    return controlPoint;
}

- (CGPoint)getSecondControlPoint:(CGPoint)cur PreviousPoint:(CGPoint)prev {
    CGPoint     controlPoint = CGPointZero;
    
    controlPoint.x = prev.x + (cur.x - prev.x) / 2;
    controlPoint.y = cur.y;
    
    return controlPoint;
}

- (NSUInteger)getMultiplicationCoeff {
    NSUInteger  diff = self.weatherGraphMax.intValue - self.weatherGraphMin.intValue;
    NSUInteger  coeff = (self.frame.size.height - self.weatherGraphPadding * 2) / diff;
    
    return coeff;
}

- (NSInteger)getRealValue:(NSInteger)value {
    NSInteger   temp = self.weatherGraphMax.integerValue - value;
    
    return temp * [self getMultiplicationCoeff] + self.weatherGraphPadding;
}

@end
