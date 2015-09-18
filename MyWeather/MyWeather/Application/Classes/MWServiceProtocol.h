//
// MWServiceProtocol.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWNetworkingOperationResponse;
@class MWNetworkingOperation;


@protocol MWServiceProtocol <NSObject>

@required

- (void)onServiceOperationFinished:(MWNetworkingOperation *)operation withResponse:(MWNetworkingOperationResponse *)response;

- (void)onServiceOperationFailed:(MWNetworkingOperation *)operation withError:(NSError *)error;

- (void)onServiceOperationCancelled:(MWNetworkingOperation *)operation withError:(NSError *)error;

@end
