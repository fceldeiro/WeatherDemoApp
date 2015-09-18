//
// MWLocationManager.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWCoordinates.h"

@class MWLocationManager;

@protocol  MWLocationManagerDelegate <NSObject>

- (void)mwLocationManager:(MWLocationManager *)locationManager didRecievedLocation:(MWCoordinates *)coordinates;
- (void)mwLocationManager:(MWLocationManager *)locationManager didFailedtoRecieveLocation :(NSError *)error;

@end

@interface MWLocationManager : NSObject

@property (nonatomic, weak) id <MWLocationManagerDelegate> delegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;


-(instancetype) initWithDelegate:(id<MWLocationManagerDelegate>) delegate;
@end
