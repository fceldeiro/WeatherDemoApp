//
// MWNetworkingSessionManager.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWNetworkingSessionManager.h"
#import "MWNetworkingConfiguration.h"

#define kMWNetworkingSessionDelegateMapDefaultSize 5u

@interface MWNetworkingSessionManager () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *foregroundSession;
@property (nonatomic, strong) NSMutableDictionary *foregroundSessionDelegates;

@property (nonatomic, strong) NSOperationQueue *operationQueueCallback;

+ (MWNetworkingSessionManager *)sharedInstance;

- (NSURLSessionDataTask *)dataTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate;

- (NSURLSessionDownloadTask *)downloadTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate;

@end

@implementation MWNetworkingSessionManager

+ (MWNetworkingSessionManager *)sharedInstance
{
	static MWNetworkingSessionManager *shared;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[MWNetworkingSessionManager alloc] init];
	});
	return shared;
}

- (id)init
{
	if (self = [super init]) {
		// Creo la queue de callbacks. Definir luego si es serial o no.
		self.operationQueueCallback = [[NSOperationQueue alloc] init];

		/*!
		 *  Creación de la foreground configuration , session y delegatesMap
		 */
		NSURLSessionConfiguration *foregroundConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		self.foregroundSession = [NSURLSession sessionWithConfiguration:foregroundConfiguration delegate:self delegateQueue:self.operationQueueCallback];

		self.foregroundSessionDelegates = [NSMutableDictionary dictionaryWithCapacity:kMWNetworkingSessionDelegateMapDefaultSize];
	}
	return self;
}

#pragma mark - class methods
+ (NSURLSessionDataTask *)dataTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	return [[MWNetworkingSessionManager sharedInstance] dataTaskFromConfiguration:configuration withDelegate:delegate];
}

+ (NSURLSessionDownloadTask *)downloadTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	return [[MWNetworkingSessionManager sharedInstance] downloadTaskFromConfiguration:configuration withDelegate:delegate];
}

+ (NSURLSessionTask *)taskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	return [[MWNetworkingSessionManager sharedInstance] taskFromConfiguration:configuration withDelegate:delegate];
}

#pragma mark - instance methods

- (NSURLSession *)sessionForConfiguration:(MWNetworkingConfiguration *)configuration
{
	return [self foregroundSession];
}

- (NSMutableDictionary *)delegateDictionaryForSession:(NSURLSession *)session
{
	return self.foregroundSessionDelegates;
}

- (NSURLSessionDataTask *)dataTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	@synchronized(self)
	{
		NSURLSession *sessionToUse = [self sessionForConfiguration:configuration];
		NSMutableDictionary *dictionaryToUse = [self delegateDictionaryForSession:sessionToUse];

		NSURLRequest *urlRequest = [configuration urlRequest];
		NSLog(@"URL Request %@", urlRequest.URL);
		NSURLSessionDataTask *task = [sessionToUse dataTaskWithRequest:urlRequest];
		dictionaryToUse[@(task.taskIdentifier)] = delegate;

		return task;
	}
}

- (NSURLSessionDownloadTask *)downloadTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	@synchronized(self)
	{
		NSURLSession *sessionToUse = [self sessionForConfiguration:configuration];
		NSMutableDictionary *dictionaryToUse = [self delegateDictionaryForSession:sessionToUse];

		NSURLSessionDownloadTask *task = nil;
		if (configuration.resumeData) {
			task = [sessionToUse downloadTaskWithResumeData:configuration.resumeData];
		} else {
			task = [sessionToUse downloadTaskWithRequest:[configuration urlRequest]];
		}
		dictionaryToUse[@(task.taskIdentifier)] = delegate;

		return task;
	}
}

- (NSURLSessionTask *)taskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate
{
	NSURLSessionTask *taskToReturn = nil;

	switch (configuration.requestType) {
		case MWNetworkingRequestTypeData:
		default: {
			taskToReturn = [self dataTaskFromConfiguration:configuration withDelegate:delegate];
		}
		break;

		case MWNetworkingRequestTypeDownload: {
			taskToReturn = [self downloadTaskFromConfiguration:configuration withDelegate:delegate];
		}
	}

	return taskToReturn;
}

/*
 * Messages related to the URL session as a whole
 */
#pragma mark - NSURLSessionDelegate

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
	NSLog(@"Session Manager become invalid with error");
}

/*
 * Messages related to the operation of a specific task.
 */
#pragma  mark - NSURLSessionTaskDelegate

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)      URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error
{
	// NSLog(@"Session Manager did complete with error");

	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(task.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];

	SEL selectorToUse = @selector(mwNetworkingSessionManager:task:didCompleteWithError:);

	if ([delegate respondsToSelector:selectorToUse]) {
		[delegate mwNetworkingSessionManager:self task:task didCompleteWithError:error];
	}

	[delegateDictionary removeObjectForKey:taskIdentifier];
}

/*
 * Messages related to the operation of a task that delivers data
 * directly to the delegate.
 */
#pragma mark - NSURLSessionDataDelegate

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(dataTask.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];

	SEL selectorToUse = @selector(mwNetworkingSessionManager:dataTask:didReceiveData:);
	if ([delegate respondsToSelector:selectorToUse]) {
		[delegate mwNetworkingSessionManager:self dataTask:dataTask didReceiveData:data];
	}
}

/* Notification that a data task has become a download task.  No
 * future messages will be sent to the data task.
 */
- (void)       URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
	NSLog(@"Session Manager did become download task");

	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(dataTask.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];
	[delegateDictionary removeObjectForKey:taskIdentifier];

	// Cambio el delegate en el dictionary ya que cambia el task
	if (delegate) {
		delegateDictionary[@(downloadTask.taskIdentifier)] = delegate;

		SEL selectorToUse = @selector(mwNetworkingSessionManager:dataTask:didBecomeDownloadTask:);
		if ([delegate respondsToSelector:selectorToUse]) {
			[delegate mwNetworkingSessionManager:self dataTask:dataTask didBecomeDownloadTask:downloadTask];
		}
	}
}

/*
 * Messages related to the operation of a task that writes data to a
 * file and notifies the delegate upon completion.
 */
#pragma mark - NSURLSessionDownloadDelegate

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)           URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location
{
	NSLog(@"Session Manager did finish downloading to URL");

	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(downloadTask.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];

	SEL selectorToUse = @selector(mwNetworkingSessionManager:downloadTask:didFinishDownloadingToURL:);
	if ([delegate respondsToSelector:selectorToUse]) {
		[delegate mwNetworkingSessionManager:self downloadTask:downloadTask didFinishDownloadingToURL:location];
	}
}

/* Sent periodically to notify the delegate of download progress. */
- (void)           URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(downloadTask.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];

	SEL selectorToUse = @selector(mwNetworkingSessionManager:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:);
	if ([delegate respondsToSelector:selectorToUse]) {
		[delegate mwNetworkingSessionManager:self downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)    URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didResumeAtOffset:(int64_t)fileOffset
    expectedTotalBytes:(int64_t)expectedTotalBytes
{
	NSMutableDictionary *delegateDictionary = [self delegateDictionaryForSession:session];

	NSNumber *taskIdentifier = @(downloadTask.taskIdentifier);

	id <MWNetworkingSessionManagerDelegate> delegate = delegateDictionary[taskIdentifier];

	SEL selectorToUse = @selector(mwNetworkingSessionManager:downloadTask:didResumeAtOffset:expectedTotalBytes:);
	if ([delegate respondsToSelector:selectorToUse]) {
		[delegate mwNetworkingSessionManager:self downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
	}
}

@end
