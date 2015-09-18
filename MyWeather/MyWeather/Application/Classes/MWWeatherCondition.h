//
// MWWeatherConditions.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWWeatherCondition : NSObject
@property (nonatomic, strong) NSNumber *conditionIdentifier;
@property (nonatomic, copy) NSString *conditionTitle;
@property (nonatomic, copy) NSString *conditionDescription;
@property (nonatomic, copy) NSString *iconIdentifier;

- (NSString *)imageName ;
- (NSString *)imageNameLarge ;
- (NSString*) imageNameLargeBlurred;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

+ (NSDictionary*) imageLargeMap;
+ (NSDictionary*) imageLargeMapBlurred;

@end
