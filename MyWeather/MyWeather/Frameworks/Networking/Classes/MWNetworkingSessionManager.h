//
// MWNetworkingSessionManager.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWNetworkingConfiguration;
@class MWNetworkingSessionManager;

@protocol MWNetworkingSessionManagerDelegate <NSObject>

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)manager
                          dataTask:(NSURLSessionDataTask *)dataTask
                    didReceiveData:(NSData *)data;

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                              task:(NSURLSessionTask *)task
              didCompleteWithError:(NSError *)error;

- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                          dataTask:(NSURLSessionDataTask *)dataTask
             didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
         didFinishDownloadingToURL:(NSURL *)location;

@optional

/* Sent periodically to notify the delegate of download progress. */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
                      didWriteData:(int64_t)bytesWritten
                 totalBytesWritten:(int64_t)totalBytesWritten
         totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)mwNetworkingSessionManager:(MWNetworkingSessionManager *)sessionManager
                      downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didResumeAtOffset:(int64_t)fileOffset
                expectedTotalBytes:(int64_t)expectedTotalBytes;

@end

/*!
 *  Clase que se encarga de la creación de tasks y repartición de callbacks de los mismos.
 */
@interface MWNetworkingSessionManager : NSObject

+ (NSURLSessionDataTask *)dataTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate;

+ (NSURLSessionDownloadTask *)downloadTaskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate;

+ (NSURLSessionTask *)taskFromConfiguration:(MWNetworkingConfiguration *)configuration withDelegate:(id <MWNetworkingSessionManagerDelegate> )delegate;

@end
