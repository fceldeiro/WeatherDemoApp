//
// MWTempData.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWTempData : NSObject
@property (nonatomic, copy) NSString *currentTemperature;
@property (nonatomic, copy) NSString *maxTemperature;
@property (nonatomic, copy) NSString *minTemperature;

-(instancetype) initWithDictionary:(NSDictionary*) dictionary NS_DESIGNATED_INITIALIZER;
@end
