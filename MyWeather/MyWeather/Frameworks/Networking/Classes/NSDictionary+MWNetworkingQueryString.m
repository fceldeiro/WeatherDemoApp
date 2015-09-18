//
// NSDictionary+MWetworkingQueryString.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "NSDictionary+MWNetworkingQueryString.h"
#import "NSString+MWNetworkingURLEncode.h"

@implementation NSDictionary (MWNetworkingQueryString)

- (NSString *)mwNetworking_queryString
{
	NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in[self keyEnumerator]) {
        if ([self[key] isKindOfClass:[NSString class]] || [self[key] isKindOfClass:[NSNumber class]]) {
			NSString *valueToAdd = [NSString stringWithFormat:@"%@", self[key]];
			valueToAdd = [valueToAdd mwNetworking_URLEncodedString];
			valueToAdd = [NSString stringWithFormat:@"%@=%@", key, valueToAdd];
			[pairs addObject:valueToAdd];
		}
	}
	NSString *queryString = [pairs componentsJoinedByString:@"&"];

	return queryString;
}

@end
