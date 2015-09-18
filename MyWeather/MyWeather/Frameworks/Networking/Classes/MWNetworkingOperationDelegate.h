//
// MWNetworkingOperationDelegate.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MWNetworkingOperation;
@class MWNetworkingOperationResponse;
@class MWNetworkingOperationError;

@protocol MWNetworkingOperationDelegate <NSObject>

@required
/**
 *  Se invoca cuando una operación termina con éxito
 *
 *  @param operation La operación que realizo el request
 *  @param response  La respuesta obtenida.
 */
- (void)mwNetworkingOperation:(MWNetworkingOperation *)operation
        didFinishWithResponse:(MWNetworkingOperationResponse *)response;

/**
 *  Se invoca cuando una operación termina con error
 *
 *  @param operation La operación que realizó el request.
 *  @param error An error object indicating how the transfer failed.
 */
- (void)mwNetworkingOperation:(MWNetworkingOperation *)operation
             didFailWithError:(MWNetworkingOperationError *)error;

@optional

/**
 *  Se invoca cuando una operación termina por cancelación
 *
 *  @param operation La operación que realizó el request
 *  @param error An error object indicating how the transfer was cancelled.
 */
- (void)mwNetworkingOperation:(MWNetworkingOperation *)operation
           didCancelWithError:(MWNetworkingOperationError *)error;

/* Sent periodically to notify the delegate of download progress. */
- (void)mwNetworkingOperation:(MWNetworkingOperation *)operation
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)mwNetworkingOperation:(MWNetworkingOperation *)operation
           didCancelWithError:(MWNetworkingOperationError *)error
            didResumeAtOffset:(int64_t)fileOffset
           expectedTotalBytes:(int64_t)expectedTotalBytes;

@end
