//
// MWTempData.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWTempData.h"
#import "NSDictionary+NSNull.h"

#define kTempDataKeyTemp @"temp"
#define kTempDataKeyTempMin @"temp_min"
#define kTempDataKeyTempMax @"temp_max"

@implementation MWTempData


-(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    if (self = [super init]){
        
        id temp = [dictionary mw_objectForKey:kTempDataKeyTemp];
        if ([temp isKindOfClass:[NSNumber class]]){
            
            NSInteger roundedValue = round([temp doubleValue]);
            
            self.currentTemperature = [NSString stringWithFormat:@"%liº",(long)roundedValue];
            
        }
        
        id tempMin = [dictionary mw_objectForKey:kTempDataKeyTempMin];
        if ([tempMin isKindOfClass:[NSNumber class]]){
            
            NSInteger roundedValue = round([tempMin doubleValue]);
            self.minTemperature = [NSString stringWithFormat:@"%liº",(long)roundedValue];
            
        }
        
        id tempMax = [dictionary mw_objectForKey:kTempDataKeyTempMax];
        if ([tempMax isKindOfClass:[NSNumber class]]){
           
            NSInteger roundedValue = round([tempMax doubleValue]);
            self.maxTemperature = [NSString stringWithFormat:@"%liº",(long)roundedValue];

        }
    }
    
    return self;
}
@end
