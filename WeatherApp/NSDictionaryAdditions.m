//
//  NSDictionaryAdditions.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/10/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "NSDictionaryAdditions.h"

@implementation NSDictionary (Additions)

- (id)safeObjectForKey:(id)aKey {
    id  object = [self objectForKey:aKey];
    
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}

@end
