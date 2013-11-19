//
//  NSMutableAttributedString+Addition.h
//  WeatherMetrics
//
//  Created by Romain Tholimet on 11/16/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Addition)

+ (NSMutableAttributedString *) mutableAttributedStringWithText:(NSString *)text withKerning:(NSUInteger)kerning;

@end
