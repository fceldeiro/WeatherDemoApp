//
// MWConfigurationJSON.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MWNetworkingConfiguration.h"

@interface MWNetworkingConfigurationDataJSON : MWNetworkingConfiguration
@property (nonatomic, strong) NSDictionary *bodyDic;
@end
