//
// MWWeatherConditions.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherCondition.h"
#import "NSDictionary+NSNull.h"

#define kWeatherConditionKeyId @"id"
#define kWeatherConditionKeyMain @"main"
#define kWeatherConditionKeyDescription @"description"
#define kWeatherConditionKeyIcon @"icon"

@implementation MWWeatherCondition

+ (NSDictionary *)imageLargeMapBlurred
{
	static NSDictionary *_imageLargeMapBlurred = nil;
	if (!_imageLargeMapBlurred) {
		_imageLargeMapBlurred = @{
			@"01d" : @"clear_d_portrait_blur.jpg",
			@"02d" : @"cloudy_d_portrait_blur.jpg",
			@"03d" : @"cloudy_d_portrait_blur.jpg",
			@"04d" : @"cloudy_d_portrait_blur.jpg",
			@"09d" : @"rain_d_portrait_blur.jpg",
			@"10d" : @"rain_d_portrait_blur.jpg",
			@"11d" : @"storm_d_portrait_blur.jpg",
			@"13d" : @"snow_d_portrait_blur.jpg",
			@"50d" : @"mist_d_portrait_blur.jpg",
			@"01n" : @"clear_n_portrait_blur.jpg",
			@"02n" : @"cloudy_n_portrait_blur.jpg",
			@"03n" : @"cloudy_n_portrait_blur.jpg",
			@"04n" : @"cloudy_n_portrait_blur.jpg",
			@"09n" : @"rain_n_portrait_blur.jpg",
			@"10n" : @"rain_n_portrait_blur.jpg",
			@"11n" : @"storm_n_portrait_blur.jpg",
			@"13n" : @"snow_n_portrait_blur.jpg",
			@"50n" : @"mist_n_portrait_blur.jpg",
		};
	}
	return _imageLargeMapBlurred;
}

+ (NSDictionary *)imageLargeMap
{
	static NSDictionary *_imageLargeMap = nil;
	if (!_imageLargeMap) {
		_imageLargeMap = @{
			@"01d" : @"clear_d_portrait.jpg",
			@"02d" : @"cloudy_d_portrait.jpg",
			@"03d" : @"cloudy_d_portrait.jpg",
			@"04d" : @"cloudy_d_portrait.jpg",
			@"09d" : @"rain_d_portrait.jpg",
			@"10d" : @"rain_d_portrait.jpg",
			@"11d" : @"storm_d_portrait.jpg",
			@"13d" : @"snow_d_portrait.jpg",
			@"50d" : @"mist_d_portrait.jpg",
			@"01n" : @"clear_n_portrait.jpg",
			@"02n" : @"cloudy_n_portrait.jpg",
			@"03n" : @"cloudy_n_portrait.jpg",
			@"04n" : @"cloudy_n_portrait.jpg",
			@"09n" : @"rain_n_portrait.jpg",
			@"10n" : @"rain_n_portrait.jpg",
			@"11n" : @"storm_n_portrait.jpg",
			@"13n" : @"snow_n_portrait.jpg",
			@"50n" : @"mist_n_portrait.jpg",
		};
	}
	return _imageLargeMap;
}

+ (NSDictionary *)imageMap
{
	static NSDictionary *_imageMap = nil;
	if (!_imageMap) {
		_imageMap = @{
			@"01d" : @"weather-clear",
			@"02d" : @"weather-few",
			@"03d" : @"weather-few",
			@"04d" : @"weather-broken",
			@"09d" : @"weather-shower",
			@"10d" : @"weather-rain",
			@"11d" : @"weather-tstorm",
			@"13d" : @"weather-snow",
			@"50d" : @"weather-mist",
			@"01n" : @"weather-moon",
			@"02n" : @"weather-few-night",
			@"03n" : @"weather-few-night",
			@"04n" : @"weather-broken",
			@"09n" : @"weather-shower",
			@"10n" : @"weather-rain-night",
			@"11n" : @"weather-tstorm",
			@"13n" : @"weather-snow",
			@"50n" : @"weather-mist",
		};
	}
	return _imageMap;
}

- (NSString *)imageName
{
	return [MWWeatherCondition imageMap][self.iconIdentifier];
}

- (NSString *)imageNameLarge
{
	return [MWWeatherCondition imageLargeMap][self.iconIdentifier];
}

- (NSString *)imageNameLargeBlurred
{
	return [MWWeatherCondition imageLargeMapBlurred][self.iconIdentifier];
}

- (NSString *)imageLargeName
{
	return [MWWeatherCondition imageLargeMap][self.iconIdentifier];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init]) {
		id identifier = [dictionary mw_objectForKey:kWeatherConditionKeyId];
		if ([identifier isKindOfClass:[NSNumber class]]) {
			self.conditionIdentifier = identifier;
		}

		id main = [dictionary mw_objectForKey:kWeatherConditionKeyMain];
		if ([main isKindOfClass:[NSString class]]) {
			self.conditionTitle = main;
		}

		id description = [dictionary mw_objectForKey:kWeatherConditionKeyDescription];
		if ([description isKindOfClass:[NSString class]]) {
			self.conditionDescription = [description capitalizedString];
		}

		id icon = [dictionary mw_objectForKey:kWeatherConditionKeyIcon];
		if ([icon isKindOfClass:[NSString class]]) {
			self.iconIdentifier = icon;
		}
	}

	return self;
}

@end
