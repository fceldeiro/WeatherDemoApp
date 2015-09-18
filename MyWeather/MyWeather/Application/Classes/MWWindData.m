//
// MWWindData.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWindData.h"
#import "NSDictionary+NSNull.h"


#define kWindDataKeySpeed @"speed"
#define kWindDataKeyDeg @"deg"

@implementation MWWindData


-(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    if (self = [super init]){
        
        
        id speed = [dictionary mw_objectForKey:kWindDataKeySpeed];
        if ([speed isKindOfClass:[NSNumber class]]){
            self.speed = speed;
        }
        
        id deg = [dictionary mw_objectForKey:kWindDataKeyDeg];
        if ([deg isKindOfClass:[NSNumber class]]){
            self.direction = deg;
        }
        
        
    }
    
    return self;
}

@end
