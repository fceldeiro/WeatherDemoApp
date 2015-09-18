//
// MWService.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import "MWService.h"
#import "MWNetworkingOperationManager.h"

@interface MWService ()
@property (nonatomic, strong) MWNetworkingOperation *operation;

/**
 *  Variable utilizada para manejar el estado de la NSOperation
 */
@property (nonatomic, readwrite, assign) BOOL operationFinished;

/**
 *  Variable utilizada para manejar el estado de la NSOperation
 */
@property (nonatomic, readwrite, assign) BOOL operationExecuting;

@property (nonatomic, strong) MWNetworkingOperationResponse *response;
@property (nonatomic, strong) MWNetworkingOperationError *error;

@end
@implementation MWService

- (id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (void)start
{
	if ([self isExecuting]) {
	//	NSAssert(![self isExecuting], @"Trying to start an already executing operation");
		return;
	}

	if ([self isCancelled]) {
		[self finishOperation];
		return;
	}

	// If the operation is not canceled, begin executing the task.
	[self willChangeValueForKey:@"isExecuting"];
	self.operationExecuting = YES;

	BOOL shouldCancel = [self isCancelled];

	for (NSOperation *operation in self.dependencies) {
		shouldCancel |= [operation isCancelled];
	}
	if (shouldCancel) {
		[self cancelOperation];
	} else {
		[self startOperation];
	}

	[self didChangeValueForKey:@"isExecuting"];
}

- (void)startOperation
{
	NSAssert(self.config, @"Debo tener una config para comenzar a ejecutarme");
	if (!self.config) {
		[self finishOperation];
	} else {
		MWNetworkingOperation *operation = [[MWNetworkingOperation alloc] initWithNetworkingConfig:self.config];

		self.operation = operation;

		__weak MWService *weakSelf = self;
		[operation setSuccessBlock: ^(MWNetworkingOperation *op, MWNetworkingOperationResponse *res) {
		    MWService *strongSelf = weakSelf;
		    strongSelf.response = res;
		    [strongSelf finishOperation];
		}];
		[operation setFailureBlock: ^(MWNetworkingOperation *op, MWNetworkingOperationError *err) {
		    MWService *strongSelf = weakSelf;
		    strongSelf.error = err;
		    [strongSelf finishOperation];
		}];
		[operation setCanceledBlock: ^(MWNetworkingOperation *op, MWNetworkingOperationError *err) {
		    MWService *strongSelf = weakSelf;
		    strongSelf.error = err;
		    [strongSelf finishOperation];
		}];

		[[MWNetworkingOperationManager sharedInstance] addOperation:operation];
	}
}

- (void)finishOperation
{
	// NSLog(@"Completing operation %@",self);

	self.operation = nil;

	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];

	self.operationExecuting = NO;
	self.operationFinished = YES;

	// ME CANCELARON?

	__weak typeof(self) weakSelf = self;

	if ([self isCancelled]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			MWService *strongSelf = weakSelf;

			[strongSelf onServiceOperationCancelled:strongSelf.operation withError:strongSelf.error];
		});
	}
	// ERROR?
	else if (self.error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			MWService *strongSelf = weakSelf;
			[strongSelf onServiceOperationFailed:strongSelf.operation withError:strongSelf.error];
		});
	}
	// SUCCESS
	else if (self.response) {
		dispatch_async(dispatch_get_main_queue(), ^{
			MWService *strongSelf = weakSelf;
			[strongSelf onServiceOperationFinished:strongSelf.operation withResponse:strongSelf.response];
		});
	}

	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
}

- (void)cancelOperation
{
	if (![self isCancelled]) {
		// NSLog(@"Cancel pressed %@",self);
		[super cancel];

		if ([self isExecuting]) {
			// NSLog(@"Canceling an executing operation %@",self);

			if ([self.operation isExecuting]) {
				[self.operation cancel];
			} else {
				[self finishOperation];
			}
		}
	} else {
	//	NSAssert(![self isCancelled], @"Trying to cancel a cancelled operation");
	}
}

#pragma mark - NSOperation

- (void)cancel
{
	/*
	   dispatch_async([self serialQueue], ^{
	   [self cancelOperation];
	   });
	 */

	[self cancelOperation];
}

- (BOOL)isExecuting
{
	return self.operationExecuting;
}

- (BOOL)isFinished
{
	return self.operationFinished;
}

- (BOOL)isConcurrent
{
	return YES;
}

#pragma mark - service protocol

- (void)onServiceOperationFinished:(MWNetworkingOperation *)operation withResponse:(MWNetworkingOperationResponse *)response
{
	NSAssert(NO, @"Abstract method should be implemented in child class");
}

- (void)onServiceOperationFailed:(MWNetworkingOperation *)operation withError:(MWNetworkingOperationError *)error
{
	NSAssert(NO, @"Abstract method should be implemented in child class");
}

- (void)onServiceOperationCancelled:(MWNetworkingOperation *)operation withError:(MWNetworkingOperationError *)error
{
	NSAssert(NO, @"Abstract method should be implemented in child class");
}

- (void)invalidate
{
	[self cancel];
}

- (void)dealloc
{
	if (self.operation) {
		[self.operation cancel];
	}

	NSLog(@"Dealloc %@", [self class]);
}

@end
