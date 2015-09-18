//
// NSDictionary+NSNull.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Null)

/**
 *  Returns the value associated with the given key with extra verifications for nil values
 *
 *  @param key key of value to be evaluated
 *
 *  @return nil for all nil, NSNull, and empty NSString objects; otherwise the value associated with the key
 */
- (id)mw_objectForKey:(id)key;

@end
