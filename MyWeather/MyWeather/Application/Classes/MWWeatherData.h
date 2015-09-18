//
// MWCityWeather.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import <Foundation/Foundation.h>



#import "MWSunTimes.h"
#import "MWTempData.h"
#import "MWUnitFormat.h"
#import "MWWindData.h"
#import "MWWeatherCondition.h"

@interface MWWeatherData : NSObject

@property (nonatomic, strong) NSString * cityName;

@property (nonatomic, strong) MWSunTimes *sunTimes;
@property (nonatomic, strong) MWTempData *tempData;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) MWWindData *windData;
@property (nonatomic, strong) NSNumber *cloudPorcent;
@property (nonatomic, strong) MWWeatherCondition *weatherCondition;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
