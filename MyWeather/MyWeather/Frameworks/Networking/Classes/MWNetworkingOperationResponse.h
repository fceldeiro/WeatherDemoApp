//
// MWNetworkingResponse.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Clase utilizada como respuesta de las operaciones de Networking
 */
@interface MWNetworkingOperationResponse : NSObject

/*!
 *  Contiene lo que devuelve el request al finalizar.
 */
@property (nonatomic, strong) NSURLResponse *urlResponse;

/*!
 *  La respuesta sin proceso luego de un request
 */
@property (nonatomic, strong) NSData *responseData;

/**
 *  Status code devuelto por la conección
 */
@property (nonatomic, assign) NSInteger statusCode;

/**
 *  Headers de respuesta
 */
@property (nonatomic, strong) NSDictionary *headers;

/**
 *  Borrar es para test por ahora
 */
@property (nonatomic, copy) NSString *identifier;

@end
