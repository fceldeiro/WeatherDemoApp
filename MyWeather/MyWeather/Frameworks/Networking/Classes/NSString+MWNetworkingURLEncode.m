//
// NSString+MWNetworkingURLEnconde.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "NSString+MWNetworkingURLEncode.h"

@implementation NSString (MWNetworkingURLEncode)

- (NSString *)mwNetworking_URLEncodedString
{
	NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
	        NULL,                                                 /* allocator */
	        (CFStringRef)self,
	        NULL,                                                 /* charactersToLeaveUnescaped */
	        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
	        kCFStringEncodingUTF8);
	return encodedString;
}

@end
