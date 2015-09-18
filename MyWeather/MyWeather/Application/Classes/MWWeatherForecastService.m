//
// MWWeatherForecastService.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherForecastService.h"
#import "MWNetworkingConfigurationDataJSON.h"
#import "MWWeatherForecastDayData.h"

#define kMWWeatherServiceQueryParamUnits @"units"
#define kMWWeatherServiceQueryParamUnitsMetric @"metric"
#define kMWWeatherServiceQueryParamUnitsImperial @"imperial"

/*
   http://api.openweathermap.org/data/2.5/forecast/daily?q=Buenos%20Aires&mode=json
 */

typedef void (^MWWeatherForecastServiceParseCompletitionBlock)(NSArray *futureWeatherData, NSError *error);

@interface MWWeatherForecastService ()
@property (nonatomic, weak) id <MWWeatherForecastServiceDelegate> delegate;

@property (nonatomic, copy) NSString *cityName;

- (instancetype)initWithDelegate:(id <MWWeatherForecastServiceDelegate> )delegate NS_DESIGNATED_INITIALIZER;
@end

@implementation MWWeatherForecastService

#pragma mark - custom methods
+ (MWNetworkingConfigurationDataJSON *)configurationBasic
{
	MWNetworkingConfigurationDataJSON *configuration = [[MWNetworkingConfigurationDataJSON alloc] init];

	configuration.baseURLString = @"http://api.openweathermap.org";
	configuration.path = @"/data/2.5/forecast/daily";

	return configuration;
}

- (NSString *)queryValueForUnitFormat:(MWUnitFormat)unitFormat
{
	switch (unitFormat) {
		case MWUnitFormatMetric: {
			return kMWWeatherServiceQueryParamUnitsMetric;
		}
		break;

		case MWUnitFormatImperial: {
			return kMWWeatherServiceQueryParamUnitsImperial;
		}
		break;

		default:
			return nil;
	}
}

#pragma mark - Init methods

- (instancetype)initWithDelegate:(id <MWWeatherForecastServiceDelegate> )delegate
{
	if (self = [super init]) {
		self.delegate = delegate;
	}
	return self;
}

- (instancetype)initWithCityName:(NSString *)cityName countryIdentifier:(NSString *)countryIdentifier andDelegate:(id <MWWeatherForecastServiceDelegate> )delegate andUnitFormat:(MWUnitFormat)unitFormat
{
	if (self = [self initWithDelegate:delegate]) {
		MWNetworkingConfigurationDataJSON *basicConfig = [MWWeatherForecastService configurationBasic];

		NSAssert(cityName, @"Service must be created with city name");
		self.cityName = cityName;

		NSString *stringToUse = nil;
		if (cityName) {
			stringToUse = [NSString stringWithString:cityName];
			/* fix temporal esta rara la api de weather
			   if (countryIdentifier) {
			    stringToUse = [cityName stringByAppendingFormat:@",%@", countryIdentifier];
			   }
			 */
		}

		NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithCapacity:2];

		if (stringToUse) {
			queryParams[@"q"] = stringToUse;
		}

		NSString *unitString = [self queryValueForUnitFormat:unitFormat];
		if (unitString) {
			queryParams[kMWWeatherServiceQueryParamUnits] = unitString;
		}

		queryParams[@"cnt"] = @"7";

		basicConfig.queryParams = [NSDictionary dictionaryWithDictionary:queryParams];

		self.config = basicConfig;
	}
	return self;
}

- (instancetype)initWithCoordinates:(MWCoordinates *)coordinates andDelegate:(id <MWWeatherForecastServiceDelegate> )delegate andUnitFormat:(MWUnitFormat)unitFormat
{
	if (self = [self initWithDelegate:delegate]) {
		MWNetworkingConfigurationDataJSON *basicConfig = [MWWeatherForecastService configurationBasic];

		NSAssert(coordinates, @"Coordinates must not be nil");
		NSAssert(coordinates.latitude, @"Latitude must not be nil");
		NSAssert(coordinates.longitude, @"Longitude must not be nil");

		// http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139

		NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:2];

		if (coordinates.latitude) {
			mutDic[@"lat"] = coordinates.latitude;
		}
		if (coordinates.longitude) {
			mutDic[@"lon"] = coordinates.longitude;
		}

		NSString *unitString = [self queryValueForUnitFormat:unitFormat];
		if (unitString) {
			mutDic[kMWWeatherServiceQueryParamUnits] = unitString;
		}

		mutDic[@"cnt"] = @"7";

		basicConfig.queryParams = [NSDictionary dictionaryWithDictionary:mutDic];

		self.config = basicConfig;
	}
	return self;
}

- (void)parseWithNetworkingResponse:(MWNetworkingOperationResponse *)networkingResponse withCompletitionBlock:(MWWeatherForecastServiceParseCompletitionBlock)completitionBlock
{
	NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:networkingResponse.responseData options:NSJSONReadingAllowFragments error:nil];

	// Check if error

	NSString *responseCodeString = dicResponse[@"cod"];
	NSInteger responseCodeInteger = [responseCodeString integerValue];

	// Error
	if (responseCodeInteger >= 400) {
		// I know it's horrible but weather api fault =P
		NSString *codInString = dicResponse[@"cod"];
		NSInteger codeInteger = [codInString integerValue];

		NSString *domain = dicResponse[@"message"];
		if (!domain) {
			domain = @"Unkown error";
		}

		NSError *error = [NSError errorWithDomain:domain code:codeInteger userInfo:nil];
		completitionBlock(nil, error);
	} else {
		// Valid response returned
		NSArray *weatherDataArray = nil;
		if (dicResponse && [dicResponse isKindOfClass:[NSDictionary class]]) {
			NSArray *dataListArray = dicResponse[@"list"];
			if ([dataListArray isKindOfClass:[NSArray class]]) {
				NSMutableArray *weatherDataMutableArray = [NSMutableArray arrayWithCapacity:dataListArray.count];

				// for (NSDictionary * dic in dataListArray){
				if (dataListArray.count > 1) {
					for (int i = 1; i < dataListArray.count; i++) {
						NSDictionary *dic = dataListArray[i];
						MWWeatherForecastDayData *data = [[MWWeatherForecastDayData alloc] initWithDictionary:dic];

						[weatherDataMutableArray addObject:data];
					}
				}
				weatherDataArray = [NSArray arrayWithArray:weatherDataMutableArray];
			}
		}

		completitionBlock(weatherDataArray, nil);
	}
}

#pragma mark  - MWServiceProtocol
- (void)onServiceOperationFinished:(MWNetworkingOperation *)operation withResponse:(MWNetworkingOperationResponse *)response
{
	[self parseWithNetworkingResponse:response withCompletitionBlock: ^(NSArray *weatherData, NSError *error) {
	    if (error) {
	        [self onServiceOperationFailed:operation withError:error];
		} else {
	        if ([self.delegate respondsToSelector:@selector(mwWeatherForecastService:didFinishedWithWeatherData:)]) {
	            [self.delegate mwWeatherForecastService:self didFinishedWithWeatherData:weatherData];
			}
		}
	}];
}

- (void)onServiceOperationFailed:(MWNetworkingOperation *)operation withError:(NSError *)error
{
	NSLog(@"Weather service failed %@", error);

	if ([self.delegate respondsToSelector:@selector(mwWeatherForecastService:didFailedWithError:)]) {
		[self.delegate mwWeatherForecastService:self didFailedWithError:error];
	}
}

- (void)onServiceOperationCancelled:(MWNetworkingOperation *)operation withError:(NSError *)error
{
	NSLog(@"Weather service cancelled %@", error);
}

@end
