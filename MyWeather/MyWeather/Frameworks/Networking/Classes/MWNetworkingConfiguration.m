//
// MWNetworkingConfiguration.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWNetworkingConfiguration.h"
#import "NSDictionary+MWNetworkingQueryString.h"

@implementation MWNetworkingConfiguration

@dynamic methodString;
@dynamic urlRequest;

#pragma mark - Read only methods

- (instancetype)init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString *)methodString
{
	switch (self.httpMethod) {
		case MWNetworkingHTTPMethodPOST: {
			return @"POST";
		}
		break;

		case MWNetworkingHTTPMethodGET:
		default: {
			return @"GET";
		}

		case MWNetworkingHTTPMethodPUT: {
			return @"PUT";
		}
		break;

		case MWNetworkingHTTPMethodDELETE: {
			return @"DELETE";
		}
		break;

		case MWNetworkingHTTPMethodHEAD: {
			return @"HEAD";
		}
		break;
	}
}

- (NSURL *)url
{
	NSURL *urlToReturn = [NSURL URLWithString:[self urlString]];
	return urlToReturn;
}

- (NSString *)urlString
{
	NSString *completeURLString = self.baseURLString;
	if (completeURLString && self.path) {
		completeURLString = [completeURLString stringByAppendingString:self.path];
	}
	if (completeURLString && self.queryParams) {
		// Apendeo los query params
		NSString *queryParamsString = [self.queryParams mwNetworking_queryString];

		if ([queryParamsString length] > 0) {
			completeURLString = [NSString stringWithFormat:@"%@%@%@", completeURLString, @"?", queryParamsString];
		}
	}

	return completeURLString;
}

- (NSURLRequest *)urlRequest
{
	NSString *urlString = [self urlString];

	NSURL *url = [NSURL URLWithString:urlString];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	for (NSString *headerKey in self.aditionalHeaders.allKeys) {
		[request addValue:self.aditionalHeaders[headerKey] forHTTPHeaderField:headerKey];
	}

	if ([self methodString]) {
		[request setHTTPMethod:[self methodString]];
	}

	NSData *myBody = [self body];
	if (myBody) {
		[request setHTTPBody:myBody];
	}

	return request;
}

#pragma mark - NSCopyingProtocol
- (instancetype)copyWithZone:(NSZone *)zone
{
	MWNetworkingConfiguration *copyConfiguration = [[self class] allocWithZone:zone];

	copyConfiguration.httpMethod = self.httpMethod;
	copyConfiguration.baseURLString = [self.baseURLString copy];
	copyConfiguration.path = [self.path copy];
	copyConfiguration.queryParams = [self.queryParams copy];

	// Turbo!
	// No lo copio por que es muy pesado
	copyConfiguration.body = self.body;

	copyConfiguration.aditionalHeaders = [self.aditionalHeaders copy];

	return copyConfiguration;
}

@end
