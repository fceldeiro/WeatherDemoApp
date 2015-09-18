//
// MWNetworkingOperation.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWNetworkingOperation.h"
#import "MWNetworkingOperation_Private.h"

#import "MWNetworkingConfiguration.h"
#import "MWNetworkingSessionManager.h"

@interface MWNetworkingOperation () <MWNetworkingSessionManagerDelegate>

/**
 *  Variable utilizada para manejar el estado de la NSOperation
 */
@property (nonatomic, readwrite, assign) BOOL operationFinished;

/**
 *  Variable utilizada para manejar el estado de la NSOperation
 */
@property (nonatomic, readwrite, assign) BOOL operationExecuting;

/*!
 *   Identificador del task creado. BORRAR CUANDO TERMINEMOS ES SOLO PARA DEBUG
 */
@property (nonatomic, strong) NSNumber *taskIdentifier;

/**
 *  Aquí se va almacenando la respuesta del task.
 */
@property (nonatomic, strong) MWNetworkingOperationResponse *response;

/**
 *  Aquí se guarda el error si hay alguno
 */
@property (nonatomic, strong) MWNetworkingOperationError *error;

// @property (nonatomic,strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSOperationQueue *serialOperationQueue;

/*!
 *  Aquí vamos guardando la data que va vininendo para ir appendeando.
 */
@property (nonatomic, strong) NSMutableData *partialResponse;

/*!
 *  Si hubo una descarga y esta en disco , este es el path.
 */
@property (nonatomic, strong) NSURL *downloadURL;

@end

@implementation MWNetworkingOperation
@synthesize configuration = _configuration;

// @dynamic priority;
// @dynamic countOfBytesRecieved;
// @dynamic countOfBytesExpectedToRecieve;
// @dynamic countOfBytesSent;
// @dynamic countOfBytesExpectedToSend;

#pragma mark - Class methods

#pragma mark - NSObject

- (id)init
{
	if (self = [super init]) {
		self.operationFinished = NO;
		self.operationExecuting = NO;

		self.operationIdentifier = [[NSUUID UUID] UUIDString];

		self.serialOperationQueue = [[NSOperationQueue alloc] init];
		[self.serialOperationQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (id)initWithNetworkingConfig:(MWNetworkingConfiguration *)configuration
{
	if (self = [self init]) {
		_configuration = [configuration copy];
	}
	return self;
}

- (void)dealloc
{
//	NSLog(@"Dealloc %@", [self class]);
}

#pragma mark - NSObject
- (NSString *)description
{
	NSString *string = nil;
	if (self.taskIdentifier) {
		string = [NSString stringWithFormat:@"Operation %@ - TaskId %@ - isFinished %@ - isCancelled %@ - isExecuting %@", [self class], self.taskIdentifier, [self isFinished] ? @"YES" : @"NO", [self isCancelled] ? @"YES" : @"NO", [self isExecuting] ? @"YES" : @"NO"];
	} else {
		string = [NSString stringWithFormat:@"Operation %@ - isFinished %@ - isCancelled %@ - isExecuting %@", [self class], [self isFinished] ? @"YES" : @"NO", [self isCancelled] ? @"YES" : @"NO", [self isExecuting] ? @"YES" : @"NO"];
	}

	return string;
}

#pragma mark - Custom methods

- (void)setConfiguration:(MWNetworkingConfiguration *)newConfig
{
	NSAssert(!([self isExecuting] || [self isFinished] || [self isCancelled]), @"No puedo cambiar una configuración de una operación en proceso o terminada");

	if (!([self isExecuting] || [self isFinished] || [self isCancelled])) {
		_configuration = [newConfig copy];
	}
}

- (MWNetworkingConfiguration *)configuration
{
	return [_configuration copy];
}

- (void)setPriority:(MWNetworkingOperationPriority)priority
{
	@synchronized(self)
	{
		self.queuePriority = (NSOperationQueuePriority)priority;
	}
}

- (MWNetworkingOperationPriority)priority
{
	return (MWNetworkingOperationPriority)self.queuePriority;
}

- (BOOL)shouldCancel
{
	BOOL shouldCancel = [self isCancelled];
	if (shouldCancel) {
		return YES;
	}

	for (NSOperation *operation in self.dependencies) {
		shouldCancel |= [operation isCancelled];
		if (shouldCancel) {
			return YES;
		}
	}

	return NO;
}

- (void)startOperation
{
	if ([self isExecuting]) {
		NSAssert(![self isExecuting], @"Trying to start an already executing operation");
		return;
	}

	if ([self isCancelled]) {
		[self finishOperation];
		return;
	}

	// If the operation is not canceled, begin executing the task.
	[self willChangeValueForKey:@"isExecuting"];
	self.operationExecuting = YES;

	BOOL shouldCancel = [self shouldCancel];

	if (shouldCancel) {
		[self cancelOperation];
	} else {
		[self startNetworkRequestWithSessionManager];
	}

	[self didChangeValueForKey:@"isExecuting"];

	/*!
	 *  TODO MANEJAR EL CASO DE QUE PASA SI START NETWORK REQUEST NO ME DEVUELVE UN TASK POR ALGUNA RAZON
	 */
	if (!self.task) {
	}
}

- (void)startNetworkRequestWithSessionManager
{
	MWNetworkingConfiguration *configurationCopy = self.configuration;
	self.task = [MWNetworkingSessionManager taskFromConfiguration:configurationCopy withDelegate:self];
	self.taskIdentifier = @(self.task.taskIdentifier);
	[self.task resume];
}

- (void)finishOperation
{
	// NSLog(@"Completing operation %@",self);

	self.task = nil;

	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];

	self.operationExecuting = NO;
	self.operationFinished = YES;

	/*!
	 *  Por qué sync?
	 *  Debido a que si es async cuando las respuestas vienen muy rapido saturan el main thread.
	 *  Al ponerlo sync le digo "ejecuta esto ahora y espera a que termine" por lo que da tiempo a que otras cosas que quieran encolarse en el main thread puedan hacerlo sin problemas.
	 */

	dispatch_sync(dispatch_get_main_queue(), ^{
		// NSLog(@"Operation finished %@",self);

		// ME CANCELARON?
		if ([self isCancelled]) {
		    NSLog(@"Operation finished, was cancelled %@", self.taskIdentifier);

		    if ([self.managerDelegate respondsToSelector:@selector(mwNetworkingOperation:didCancelWithError:)]) {
		        [self.managerDelegate mwNetworkingOperation:self didCancelWithError:self.error];
			} else if ([self.delegate respondsToSelector:@selector(mwNetworkingOperation:didCancelWithError:)]) {
		        [self.delegate mwNetworkingOperation:self didCancelWithError:self.error];
			} else if (self.canceledBlock) {
		        self.canceledBlock(self, self.error);
			}
		}
		// ERROR?
		else if (self.error) {
		    NSLog(@"Operation finished, with error %@", self.taskIdentifier);
		    if ([self.managerDelegate respondsToSelector:@selector(mwNetworkingOperation:didFailWithError:)]) {
		        [self.managerDelegate mwNetworkingOperation:self didFailWithError:self.error];
			} else if ([self.delegate respondsToSelector:@selector(mwNetworkingOperation:didFailWithError:)]) {
		        [self.delegate mwNetworkingOperation:self didFailWithError:self.error];
			} else if (self.failureBlock) {
		        self.failureBlock(self, self.error);
			}
		}
		// SUCCESS
		else if (self.response) {
		    NSLog(@"Operation finished, with response %@", self.taskIdentifier);
		    if ([self.managerDelegate respondsToSelector:@selector(mwNetworkingOperation:didFinishWithResponse:)]) {
		        [self.managerDelegate mwNetworkingOperation:self didFinishWithResponse:self.response];
			} else if ([self.delegate respondsToSelector:@selector(mwNetworkingOperation:didFinishWithResponse:)]) {
		        [self.delegate mwNetworkingOperation:self didFinishWithResponse:self.response];
			} else if (self.successBlock) {
		        NSLog(@"finish operation success");
		        self.successBlock(self, self.response);
			}
		}
	});

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

			if (self.task) {
				[self.task cancel];
			} else {
				[self finishOperation];
			}
		}
	} else {
		NSLog(@"trying to cancel a cancelled operation");
		// NSAssert(![self isCancelled], @"Trying to cancel a cancelled operation");
	}
}

#pragma mark - NSOperation

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

- (void)start
{
	// NSLog(@"Starting operation");
	// Always check for cancellation before launching the task.
	/*
	   dispatch_async([self serialQueue], ^{
	    [self startOperation];
	   });
	 */

	[self.serialOperationQueue addOperationWithBlock: ^{
	    [self startOperation];
	}];
}

- (void)cancel
{
	/*
	   dispatch_async([self serialQueue], ^{
	    [self cancelOperation];
	   });
	 */

	[self.serialOperationQueue addOperationWithBlock: ^{
	    [self cancelOperation];
	}];
}

#pragma mark - session manager delegate

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)manager
                          dataTask:(NSURLSessionDataTask *)dataTask
                    didReceiveData:(NSData *)data
{
	[self.serialOperationQueue addOperationWithBlock: ^{
	    if (!self.partialResponse) {
	        self.partialResponse = [[NSMutableData alloc] init];
		}
	    [self.partialResponse appendData:data];
	}];
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                              task:(NSURLSessionTask *)task
              didCompleteWithError:(NSError *)error
{
	[self.serialOperationQueue addOperationWithBlock: ^{
	    NSLog(@"%@", task.response);

	    // NSLog(@"Task finished %@ is autenticated:%lu",self.task,self.configuration.authenticationMode);

	    if (error) {
	        self.error = [[MWNetworkingOperationError alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
		}

	    // self.response.identifier = self.operationIdentifier;

	    // Bueno aca puede pasar 3 cosas /ya probado ver que hacer
	    // 1) Cancele, pero termino igual el request, que hago?
	    // 2) Cancele, y se pudo cancelar , viene con error.code -999
	    // 3) No cancele, termino con error.
	    // 4) No cancele, termino con éxito.

	    // Por ahora me fijo, si estoy en isCancelled, finalizo la operación y no hago mas nada.
	    if ([self isCancelled]) {
	        [self finishOperation];
	        return;
		}

	    // Si tengo error me fijo si es de cancelación
	    if (error) {
	        if (error.code == -999) {
	            // Cancelo la operación entonces.
	            [super cancel];
			}
		} else if (self.partialResponse || self.downloadURL) {
	        // Si el tipo de http response de de NSHTTPURL response me fijo si hubo un error HTTP para generar el error correspondiente si es necesario
	        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
	            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

	            NSString *responseString = [[NSString alloc] initWithData:self.partialResponse encoding:NSUTF8StringEncoding];

	            if (httpResponse.statusCode >= 400) {
	                NSDictionary *errorInfo = nil;
	                if (responseString) {
	                    errorInfo = @{@"response" : responseString};
					}

	                self.error = [[MWNetworkingOperationError alloc] initWithDomain:@"HTTPPropertyStatusCode" code:httpResponse.statusCode userInfo:errorInfo];
				}
			}

	        self.response = [[MWNetworkingOperationResponse alloc] init];
	        self.response.urlResponse = self.task.response;
	        self.response.identifier = self.operationIdentifier;
	        if (self.partialResponse) {
	            self.response.responseData = [NSData dataWithData:self.partialResponse];
			}
		}
	    [self finishOperation];
	}];
}

- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                          dataTask:(NSURLSessionDataTask *)dataTask
             didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
	[self.serialOperationQueue addOperationWithBlock: ^{
	    self.task = downloadTask;
	}];
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
         didFinishDownloadingToURL:(NSURL *)location
{
	// Ver en serio algo para manejar cache, asi esto no escala
	self.partialResponse = [NSMutableData dataWithContentsOfURL:location];
}

/* Sent periodically to notify the delegate of download progress. */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
                      didWriteData:(int64_t)bytesWritten
                 totalBytesWritten:(int64_t)totalBytesWritten
         totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
	[self.serialOperationQueue addOperationWithBlock: ^{
	    // NSLog(@"Write data %lli / %lli",totalBytesWritten,totalBytesExpectedToWrite);
	    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
	        if ([self.delegate respondsToSelector:@selector(mwNetworkingOperation:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
	            [self.delegate mwNetworkingOperation:self didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
			}
		}];
	}];
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didResumeAtOffset:(int64_t)fileOffset
                expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

#pragma mark - NSCopying protocol
- (id)copyWithZone:(NSZone *)zone
{
	MWNetworkingOperation *operationCopy = [[[self class] alloc] init];

	operationCopy.delegate = self.delegate;

	operationCopy.successBlock = self.successBlock;
	operationCopy.failureBlock = self.failureBlock;
	operationCopy.canceledBlock = self.canceledBlock;
	operationCopy.operationIdentifier = self.operationIdentifier;
	operationCopy.configuration = self.configuration;
	operationCopy.managerDelegate = self.managerDelegate;
	operationCopy.queuePriority = self.queuePriority;

	return operationCopy;
}

@end
