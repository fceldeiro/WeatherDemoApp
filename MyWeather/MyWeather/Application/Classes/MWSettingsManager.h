//
// MWSettings.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWUnitFormat.h"


#define kMWSettingsManagerUnitChanged @"MWSettingManagerUnitChanged"

@interface MWSettingsManager : NSObject


+ (instancetype)sharedInstance;

@property (readwrite,nonatomic) MWUnitFormat unitFormat;


@end
