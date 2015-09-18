//
// MWSunTimes.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWSunTimes.h"
#import "NSDictionary+NSNull.h"


#define kSunTimesKeySunrise @"sunrise"
#define kSunTimesKeySunset @"sunset"

@implementation MWSunTimes


-(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    if (self = [super init]){
        
        id sunrise = [dictionary mw_objectForKey:kSunTimesKeySunrise];
        if ([sunrise isKindOfClass:[NSNumber class]]){
            NSTimeInterval interval = [sunrise doubleValue];

            self.sunrise = [NSDate dateWithTimeIntervalSince1970:interval];
        }
        
        id sunset = [dictionary mw_objectForKey:kSunTimesKeySunset];
        if ([sunset isKindOfClass:[NSNumber class]]){
            NSTimeInterval interval = [sunset doubleValue];
            self.sunset = [NSDate dateWithTimeIntervalSince1970:interval];
        }
    }
    
    return self;
}

@end
