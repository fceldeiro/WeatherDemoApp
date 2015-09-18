//
// MWWeatherForecastDayData.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherForecastDayData.h"
#import "NSDictionary+NSNull.h"

@implementation MWWeatherForecastDayData

/*
   @property (nonatomic,strong) NSNumber * dt;
   @property (nonatomic,strong) NSNumber * humidity;
   @property (nonatomic,strong) NSNumber * tempMax;
   @property (nonatomic,strong) NSNumber * tempMin;
   @property (nonatomic,strong) MWWeatherCondition * weatherCondition;
 */

- (NSNumber *)tempMaxFromDictionary:(NSDictionary *)dic
{
	NSArray *allKeys = dic.allKeys;

	NSNumber *maxValue = nil;

	for (NSString *key in allKeys) {
		NSNumber *value = dic[key];
		if (!maxValue) {
			maxValue = value;
		} else {
			if (value.doubleValue > maxValue.doubleValue) {
				maxValue = value;
			}
		}
	}
	return maxValue;
}

- (NSNumber *)tempMinFromDictionary:(NSDictionary *)dic
{
	NSArray *allKeys = dic.allKeys;

	NSNumber *minValue = nil;

	for (NSString *key in allKeys) {
		NSNumber *value = dic[key];
		if (!minValue) {
			minValue = value;
		} else {
			if (value.doubleValue < minValue.doubleValue) {
				minValue = value;
			}
		}
	}
	return minValue;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init]) {
		self.dt = [dictionary mw_objectForKey:@"dt"];
		self.humidity = [dictionary mw_objectForKey:@"humidity"];

		NSDictionary *tempMap = [dictionary mw_objectForKey:@"temp"];


        NSInteger tempMaxInteger = round([[self tempMaxFromDictionary:tempMap] doubleValue]);
        NSInteger tempMinInteger = round([[self tempMinFromDictionary:tempMap] doubleValue]);

        
        
        self.tempMax = [NSString stringWithFormat:@"%liº",(long)tempMaxInteger];
        self.tempMin = [NSString stringWithFormat:@"%liº",(long)tempMinInteger];
        
		
		NSArray *weatherConditionsArray = [dictionary mw_objectForKey:@"weather"];
		if (weatherConditionsArray.count > 0) {
			self.weatherCondition = [[MWWeatherCondition alloc] initWithDictionary:[weatherConditionsArray firstObject]];
		}
	}

	return self;
}

@end
