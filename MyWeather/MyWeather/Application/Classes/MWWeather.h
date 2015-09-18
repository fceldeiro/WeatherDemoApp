//
//  MWWeather.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWWeatherData.h"

@interface MWWeather : NSObject

@property (nonatomic,strong) MWWeatherData * currentWeather;
@property (nonatomic,strong) NSArray * forecastDaily;
@property (nonatomic,strong) NSArray * forecastHourly;



@end
