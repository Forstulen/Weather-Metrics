//
//  WeatherAnimatedIcon.m
//  WeatherApp
//
//  Created by Romain Tholimet on 10/23/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#import "WeatherAnimatedIcon.h"
#import "defines.h"

@implementation WeatherAnimatedIcon

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)createIcon:(NSString *)name withShift:(BOOL)shift {
    NSFileManager   *fm = [NSFileManager defaultManager];
    NSError         *dataError = nil;
    NSString        *path = [NSString stringWithFormat:@"%@/%@", [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WEATHER_ICON_FOLDER], name];
    NSArray         *fileNames = nil;

    _weatherAnimatedIconImages = [[NSMutableArray alloc] init];
    fileNames = [fm contentsOfDirectoryAtPath:[path stringByExpandingTildeInPath]  error:&dataError];
    
    if (!dataError) {
        for (NSString *file in fileNames) {
            #pragma message("Change this PLEASE")
            //if ([file rangeOfString:@"@2x"].location == NSNotFound) {
                UIImage     *image = [UIImage imageNamed:[[WEATHER_ICON_FOLDER stringByAppendingPathComponent:name] stringByAppendingPathComponent:file]];

                if (image) {
                    [_weatherAnimatedIconImages addObject:image];
                }
            //}
        }
    } else {
        NSLog(@"Files are missing. Cannot create animation with %@", _weatherAnimatedIconName);
    }
    
    if (shift && _weatherAnimatedIconImages.count) {
        NSUInteger  nbShift = arc4random() % _weatherAnimatedIconImages.count;
        
        for (NSUInteger i = nbShift; i > 0; --i) {
            id image = [_weatherAnimatedIconImages lastObject];
            [_weatherAnimatedIconImages insertObject:image atIndex:0];
            [_weatherAnimatedIconImages removeLastObject];
        }
    }
    
    _weatherAnimatedIconName = name;
    self.weatherAnimatedIconDuration = WEATHER_ICON_DURATION;
    self.
    self.animationImages = _weatherAnimatedIconImages;
    self.animationDuration = self.weatherAnimatedIconDuration;
    self.contentMode = UIViewContentModeScaleAspectFit;
}

@end
