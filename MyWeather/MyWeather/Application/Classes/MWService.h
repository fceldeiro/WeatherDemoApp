//
// MWService.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWServiceProtocol.h"

#import "MWNetworkingOperation.h"
#import "MWNetworkingOperationError.h"
#import "MWNetworkingOperationResponse.h"

@class MWNetworkingConfiguration;

@interface MWService : NSOperation <MWServiceProtocol>

// Configuración que sera utilizada para ejecutar los request
@property (nonatomic, strong) MWNetworkingConfiguration *config;

- (void)invalidate;

@end
