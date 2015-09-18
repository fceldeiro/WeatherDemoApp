//
// MWCityManager.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWCity.h"

@interface MWCityManager : NSObject

@property (nonatomic, readonly, atomic) NSArray *cities;

+ (instancetype)sharedInstance;

- (void)startManager;
- (void)updateCities;
- (void)updateCitiesWithNewCityArray:(NSArray*) newCityArray;
- (MWCity *)defaultCity;

+ (MWCity *)cityFromName:(NSString *)cityName fromCitiesArray:(NSArray *)citiesArray;
+ (MWCity *)cityFromName:(NSString *)cityName andCountry:(NSString *)countryIdentifier fromCitiesArray:(NSArray *)citiesArray;
+ (MWCity *)defaultCityFromCitiesArray:(NSArray *)citiesArray;

@end
