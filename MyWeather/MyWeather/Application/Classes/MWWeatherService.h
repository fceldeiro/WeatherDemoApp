//
// MWCityWeatherService.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWService.h"
#import "MWWeatherData.h"
#import "MWCoordinates.h"

@class MWWeatherService;

@protocol MWWeatherServiceDelegate <NSObject>

@required
- (void)mwWeatherService:(MWWeatherService *)service didFinishedWithWeatherData:(MWWeatherData *)weatherData;

- (void)mwWeatherService:(MWWeatherService *)service didFailedWithError:(NSError *)error;

@end

@interface MWWeatherService : MWService <MWServiceProtocol>

- (instancetype)initWithCityName:(NSString *)cityName countryIdentifier:(NSString *)countryIdentifier andDelegate:(id <MWWeatherServiceDelegate> )delegate andUnitFormat:(MWUnitFormat) unitFormat;

- (instancetype)initWithCoordinates:(MWCoordinates *)coordinates andDelegate:(id <MWWeatherServiceDelegate> )delegate andUnitFormat:(MWUnitFormat) unitFormat;

@end
