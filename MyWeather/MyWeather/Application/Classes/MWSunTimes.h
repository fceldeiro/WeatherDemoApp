//
// MWSunTimes.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWSunTimes : NSObject

@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;


-(instancetype) initWithDictionary:(NSDictionary*) dictionary NS_DESIGNATED_INITIALIZER;
@end
