//
//  MWWeatherForecastDayData.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWWeatherCondition.h"

@interface MWWeatherForecastDayData : NSObject
@property (nonatomic,strong) NSNumber * dt;
@property (nonatomic,strong) NSNumber * humidity;
@property (nonatomic,copy) NSString * tempMax;
@property (nonatomic,copy) NSString * tempMin;
@property (nonatomic,strong) MWWeatherCondition * weatherCondition;

-(instancetype) initWithDictionary:(NSDictionary*) dictionary;

@end
