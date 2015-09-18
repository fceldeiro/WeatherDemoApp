//
// MWNetworkingOperationManager.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWNetworkingOperation.h"
#import "MWNetworkingConfiguration.h"

@interface MWNetworkingOperationManager : NSObject

+ (void)addOperation:(MWNetworkingOperation *)operation;
+ (MWNetworkingOperationManager *)sharedInstance;
- (void)addOperation:(MWNetworkingOperation *)operation;
- (NSArray *)allOperations;
- (void)setMaxConcurrentOperations:(NSInteger)maxConcurrentOperations;
- (void)cancelOperationsWithDependency:(Class)dependencyClass;

@end
