//
//  NSMutableAttributedString+Addition.m
//  WeatherMetrics
//
//  Created by Romain Tholimet on 11/16/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"

@implementation NSMutableAttributedString (Addition)

+ (NSMutableAttributedString *) mutableAttributedStringWithText:(NSString *)text withKerning:(NSUInteger)kerning {
    
    if (!text) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString addAttribute:NSKernAttributeName value:@(kerning) range:NSMakeRange(0, text.length)];

    return attributedString;
}

@end
