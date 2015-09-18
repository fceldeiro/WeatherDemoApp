//
// CitiesService.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWServiceProtocol.h"
#import "MWService.h"
#import "MWCitiesServiceResponse.h"

@class MWCitiesService;

@protocol MWCitiesServiceDelegate <NSObject>
- (void)mwCitiesService:(MWCitiesService *)service didFinishedWithResponse:(MWCitiesServiceResponse *)response;

- (void)mwCitiesService:(MWCitiesService *)service didFailedWithError:(NSError *)error;

@end

@interface MWCitiesService : MWService <MWServiceProtocol>

- (instancetype)initWithDelegate:(id <MWCitiesServiceDelegate> )delegate NS_DESIGNATED_INITIALIZER;

@end
