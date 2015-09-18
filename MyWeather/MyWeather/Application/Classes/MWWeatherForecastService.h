//
//  MWWeatherForecastService.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWService.h"
#import "MWUnitFormat.h"
#import "MWCoordinates.h"


@class MWWeatherForecastService;

@protocol MWWeatherForecastServiceDelegate <NSObject>

@required
- (void)mwWeatherForecastService:(MWWeatherForecastService *)service didFinishedWithWeatherData:(NSArray *)futureWeatherData;

- (void)mwWeatherForecastService:(MWWeatherForecastService *)service didFailedWithError:(NSError *)error;

@end

@interface MWWeatherForecastService : MWService <MWServiceProtocol>

- (instancetype)initWithCityName:(NSString *)cityName countryIdentifier:(NSString *)countryIdentifier andDelegate:(id <MWWeatherForecastServiceDelegate> )delegate andUnitFormat:(MWUnitFormat) unitFormat;

- (instancetype)initWithCoordinates:(MWCoordinates *)coordinates andDelegate:(id <MWWeatherForecastServiceDelegate> )delegate andUnitFormat:(MWUnitFormat) unitFormat;

@end
