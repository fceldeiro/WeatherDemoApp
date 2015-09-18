//
// MWWindData.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWWindData : NSObject
@property (nonatomic, strong) NSNumber *speed;
@property (nonatomic, strong) NSNumber *direction;
@property (nonatomic, strong) NSNumber *gust;

-(instancetype) initWithDictionary:(NSDictionary*) dictionary NS_DESIGNATED_INITIALIZER;

@end
