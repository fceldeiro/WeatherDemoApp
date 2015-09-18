//
// MWNetworkingOperation_Private.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWNetworkingOperation.h"

@interface MWNetworkingOperation ()

/**
 *  Task creado para realizar los request
 */
@property (nonatomic, readwrite, strong) NSURLSessionTask *task;

/**
 *  Si existe este delegate por cada callback que intente llamar debe verificar antes que este implementado aquí. Si no lo está va por el callback original. (ya sea block o delegate).
 */
@property (atomic, weak) id <MWNetworkingOperationDelegate> managerDelegate;

@end
