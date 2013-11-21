//
//  WeatherAnimatedIcon.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/23/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherAnimatedIcon : UIImageView {
    NSMutableArray  *_weatherAnimatedIconImages;
    NSString        *_weatherAnimatedIconName;
}

- (void)createIcon:(NSString *)name withShift:(BOOL)shift;

@property   (nonatomic) CGFloat weatherAnimatedIconDuration;
@property   (nonatomic, readonly)   NSString    *weatherAnimatedIconName;

@end
