//
// NSDictionary+Null.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import "NSDictionary+NSNull.h"

@implementation NSDictionary (Null)

- (id)mw_objectForKey:(id)key
{
	id object = [self objectForKey:key];

	return [self isNullOrEmpty:object] ? nil : object;
}

- (BOOL)isNullOrEmpty:(id)object
{
	if (object == nil || [object isEqual:[NSNull null]]) {
		return YES;
	}

	if ([object isKindOfClass:[NSString class]]) {
		if ([object isEqualToString:@""]) {
			return YES;
		}
	}

	return NO;
}

@end
