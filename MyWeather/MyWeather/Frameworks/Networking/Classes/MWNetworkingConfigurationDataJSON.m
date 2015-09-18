//
// MWConfigurationJSON.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import "MWNetworkingConfigurationDataJSON.h"

@implementation MWNetworkingConfigurationDataJSON

/**
 *  Devolución de urlRequest formado a partir de todas las propiedades del MWNetworkingConfigurationProtocol
 */
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
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:myBody];
		[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myBody length]] forHTTPHeaderField:@"Content-Length"];
	}

	return request;
}

- (void)setBodyDic:(NSDictionary *)bodyDic
{
	_bodyDic = bodyDic;
	self.body = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
}

@end
