//
// City.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWWeatherData.h"
#import "MWCoordinates.h"

/*!
 *  Object to represent 1 city
 */
@interface MWCity : NSObject <NSCoding>

/*!
 *  Name of the city
 */
@property (nonatomic, copy) NSString *name;

/*!
 *  Name of the country of the city
 */
@property (nonatomic, copy) NSString *countryIdentifier;

/*!
 *  Image url of the city
 */
@property (nonatomic, copy) NSString *imageURL;

/*!
 *  Weather data of the city if available
 */
@property (nonatomic, strong) MWWeatherData *weatherData;

/*!
 *  Coordinates of the city , if available
 */
@property (nonatomic, strong) MWCoordinates *coordinates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;



@end
