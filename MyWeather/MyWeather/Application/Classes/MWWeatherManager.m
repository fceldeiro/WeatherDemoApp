//
//  MWWeatherManager.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherManager.h"
#import "MWWeather.h"
#import "MWCity.h"



@interface MWWeatherManager()

@end
@implementation MWWeatherManager

+(instancetype) sharedInstance{
    
    static dispatch_once_t onceToken;
    static MWWeatherManager *shared;
    
    dispatch_once(&onceToken, ^{
        shared = [[MWWeatherManager alloc] init];
    });
    return shared;
    
}


//Por ahora no hay presistencia.
//En base a datos de una city (nombre o location) llamo a los servicios necesarios para conseguir un weather del día y predicciones.
-(MWWeather*) weatherForCity:(MWCity*) city{

    return nil;
}

@end
