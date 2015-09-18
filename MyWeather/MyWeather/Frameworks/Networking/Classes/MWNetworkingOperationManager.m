//
// MWNetworkingOperationManager.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import "MWNetworkingOperationManager.h"

#define kMWNetworkingOperationManangerDefaultMaxConcurrentOperations 5

@interface MWNetworkingOperationManager ()
@property (nonatomic, strong, readonly) dispatch_queue_t serialQueue;
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

@end

@implementation MWNetworkingOperationManager

+ (MWNetworkingOperationManager *)sharedInstance
{
	static MWNetworkingOperationManager *shared;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[MWNetworkingOperationManager alloc] init];
	});
	return shared;
}

+ (void)addOperation:(MWNetworkingOperation *)operation
{
	[[MWNetworkingOperationManager sharedInstance] addOperation:operation];
}

- (id)init
{
	if (self = [super init]) {
		_operationQueue = [[NSOperationQueue alloc] init];
		[_operationQueue setMaxConcurrentOperationCount:kMWNetworkingOperationManangerDefaultMaxConcurrentOperations];
		_serialQueue = dispatch_queue_create("MWNetworkingOperationManangerSerialQueue", 0);
	}

	return self;
}

- (void)setMaxConcurrentOperations:(NSInteger)maxConcurrentOperations
{
	dispatch_async(self.serialQueue, ^{
		[self.operationQueue setMaxConcurrentOperationCount:maxConcurrentOperations];
	});
}

- (void)addOperation:(MWNetworkingOperation *)operation
{
	dispatch_async(self.serialQueue, ^{
		NSAssert(![operation isExecuting], @"La operación no puede estar ejecutandose al encolarese");
		[self.operationQueue addOperation:operation];
	});
}

- (NSArray *)allOperations
{
	return self.operationQueue.operations;
}

- (void)cancelOperationsWithDependency:(Class)dependencyClass
{
	dispatch_async(self.serialQueue, ^{
		for (NSOperation *operation in self.operationQueue.operations) {
		    for (NSOperation *operationDependency in operation.dependencies) {
		        if ([operationDependency class] == dependencyClass) {
		            if (![operation isCancelled]) {
		                [operation cancel];
					}
				}
			}
		}
	});
}

@end
