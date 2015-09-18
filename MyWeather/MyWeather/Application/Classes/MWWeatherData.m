//
// MWCityWeather.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherData.h"
#import "NSDictionary+NSNull.h"


/*
@property (nonatomic, strong) MWSunTimes *sunTimes;
@property (nonatomic, strong) MWTempData *tempData;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) MWWindData *windData;
@property (nonatomic, strong) NSNumber *cloudPorcent;
@property (nonatomic, strong) NSNumber *rainPorcent;
@property (nonatomic, strong) NSNumber *snowPorcent;
@property (nonatomic, strong) NSArray *weatherConditions;
*/


#define kWeatherDataKeySys @"sys"
#define kWeatherDataKeyMain @"main"
#define kWeatherDataKeyHumidity @"humidity"
#define kWeatherDataKeyPressure @"pressure"

#define kWeatherDataKeyWind @"wind"

#define kWeatherDataKeyClouds @"clouds"
#define kWeatherDataKeyCloudsAll @"all"

#define kWeatherDataKeyWeatherConditions @"weather"

@implementation MWWeatherData

-(instancetype) initWithDictionary:(NSDictionary*) dictionary{
    
    if (self = [super init]){
        
        NSDictionary * sysDic = [dictionary mw_objectForKey:kWeatherDataKeySys];
        if ([sysDic isKindOfClass:[NSDictionary class]]){
            
            MWSunTimes * sunTimes = [[MWSunTimes alloc] initWithDictionary:sysDic];
            self.sunTimes = sunTimes;
            
            
        }
        
        NSDictionary * main = [dictionary mw_objectForKey:kWeatherDataKeyMain];
        if ([main isKindOfClass:[NSDictionary class]]){
            
            MWTempData * tempData = [[MWTempData alloc] initWithDictionary:main];
            self.tempData = tempData;
            
            id humidity = [main mw_objectForKey:kWeatherDataKeyHumidity];
            if ([humidity isKindOfClass:[NSNumber class]]){
                self.humidity = humidity;
            }
            
            id pressure = [main mw_objectForKey:kWeatherDataKeyPressure];
            if ([pressure isKindOfClass:[NSNumber class]]){
                self.pressure = pressure;
            }
        }
        
        
        NSDictionary * wind = [dictionary mw_objectForKey:kWeatherDataKeyWind];
        if ([wind isKindOfClass:[NSDictionary class]]){
            
            MWWindData * windData = [[MWWindData alloc] initWithDictionary:wind];
            
            self.windData = windData;
        }
        
        
        id cloudDic = [dictionary mw_objectForKey:kWeatherDataKeyClouds];
        if ([cloudDic isKindOfClass:[NSDictionary class]]){
            
            id cloudiness = [cloudDic mw_objectForKey:kWeatherDataKeyCloudsAll];
            if ([cloudiness isKindOfClass:[NSNumber class]]){
                self.cloudPorcent = cloudiness;
            }
        }
        
        
        id weatherconditions = [dictionary mw_objectForKey:kWeatherDataKeyWeatherConditions];
        if ([weatherconditions isKindOfClass:[NSArray class]]){
            
            NSUInteger conditionsCount = [weatherconditions count];
            NSMutableArray * mutArray = [NSMutableArray arrayWithCapacity:conditionsCount];
            
            for ( int i = 0 ; i<conditionsCount ; i++){
                id condition = weatherconditions[i];
                if ([condition isKindOfClass:[NSDictionary class]]){
                    MWWeatherCondition * weatherCondition = [[MWWeatherCondition alloc] initWithDictionary:condition];
                    [mutArray addObject:weatherCondition];
                }
            }
            
            if (mutArray.count > 0){
                self.weatherCondition = [mutArray firstObject];
            }

            
            
        }
    }
    
    return self;
}
@end
