//
// CitiesService.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import "MWCitiesService.h"
#import "MWCitiesServiceResponse.h"
#import "MWNetworkingConfiguration.h"
#import "MWNetworkingOperation.h"
#import "MWNetworkingOperationManager.h"
#import "MWNetworkingConfigurationDataJSON.h"
#import "NSDictionary+NSNull.h"

@interface MWCitiesService ()
@property (nonatomic, weak) id <MWCitiesServiceDelegate> delegate;
@end

@implementation MWCitiesService

#pragma mark - NSObject
- (instancetype)initWithDelegate:(id <MWCitiesServiceDelegate> )delegate
{
	if (self = [super init]) {
		MWNetworkingConfigurationDataJSON *configuration = [[MWNetworkingConfigurationDataJSON alloc] init];
		configuration.httpMethod = MWNetworkingHTTPMethodGET;
		configuration.baseURLString = @"https://dl.dropboxusercontent.com";
		configuration.path = @"/u/3501/countries.json";

		self.delegate = delegate;
		self.config = configuration;
	}
	return self;
}

#pragma mark - Custom

- (MWCitiesServiceResponse *)parseNetworkingResponse:(MWNetworkingOperationResponse *)networkingResponse
{
	NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:networkingResponse.responseData options:NSJSONReadingAllowFragments error:nil];

	// Valid response returned
	MWCitiesServiceResponse *citiesResponseToReturn = nil;
	if (dicResponse && [dicResponse isKindOfClass:[NSDictionary class]]) {
		citiesResponseToReturn = [[MWCitiesServiceResponse alloc] initWithDictionary:dicResponse];
	}

	return citiesResponseToReturn;
}

#pragma  mark - service protocol

- (void)onServiceOperationFinished:(MWNetworkingOperation *)operation withResponse:(MWNetworkingOperationResponse *)response
{
	if ([self.delegate respondsToSelector:@selector(mwCitiesService:didFinishedWithResponse:)]) {
		MWCitiesServiceResponse *finalResponse = [self parseNetworkingResponse:response];

		[self.delegate mwCitiesService:self didFinishedWithResponse:finalResponse];
	}
}

- (void)onServiceOperationFailed:(MWNetworkingOperation *)operation withError:(MWNetworkingOperationError *)error
{
	if ([self.delegate respondsToSelector:@selector(mwCitiesService:didFailedWithError:)]) {
		[self.delegate mwCitiesService:self didFailedWithError:error];
	}
}

- (void)onServiceOperationCancelled:(MWNetworkingOperation *)operation withError:(MWNetworkingOperationError *)error
{
	if ([self.delegate respondsToSelector:@selector(mwCitiesService:didFailedWithError:)] && ![self isCancelled]) {
		[self.delegate mwCitiesService:self didFailedWithError:error];
	}
}

@end
