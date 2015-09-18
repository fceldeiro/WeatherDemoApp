// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 *  Enum que identifica que tipo de request será creado o es actualmente.
 */
typedef NS_ENUM (NSUInteger, MWNetworkingRequestType) {
	/**
	 *  Request de datos
	 */
	MWNetworkingRequestTypeData = 0,
	/**
	 *  Request de download
	 */
	MWNetworkingRequestTypeDownload = 1,
};

/**
 *  Enum que se usa para determinar que metodo http rest utiliza a la hora de crear el request.
 */
typedef NS_ENUM (NSUInteger, MWNetworkingHTTPMethod) {
	/**
	 *  GET
	 */
	MWNetworkingHTTPMethodGET,
	/**
	 *  POST
	 */
	MWNetworkingHTTPMethodPOST,
	/**
	 *  PUT
	 */
	MWNetworkingHTTPMethodPUT,
	/**
	 *  HEAD
	 */
	MWNetworkingHTTPMethodHEAD,
	/**
	 *  DELETE
	 */
	MWNetworkingHTTPMethodDELETE
};

@interface MWNetworkingConfiguration : NSObject <NSCopying>

/**
 *  Identificación de que tipo de request debe crear.
 */
@property (nonatomic, assign) MWNetworkingRequestType requestType;

/**
 *  Identificación de que tipo de servicio HTTP REST debe crear.
 */
@property (nonatomic, assign) MWNetworkingHTTPMethod httpMethod;

/**
 *  Ejemplo : http://myapi.com"
 */
@property (nonatomic, copy) NSString *baseURLString;

/**
 *  Ejemplo: /things/to/get
 */
@property (nonatomic, copy) NSString *path;

/**
 *  Mapa con todos los query params.
 *  Ejemplo @{@"q":@"stuff"}
 */
@property (nonatomic, strong) NSDictionary *queryParams;

/**
 *  NSData que será enviado como body del request.
 */
@property (nonatomic, strong) NSData *body;

/**
 *  Headers adicionales utilizados para hacer un request.
 */
@property (nonatomic, strong) NSDictionary *aditionalHeaders;

/**
 *  Devolución de urlRequest formado a partir de todas las propiedades del MWNetworkingConfigurationProtocol
 */
@property (nonatomic, copy, readonly) NSURLRequest *urlRequest;

/*!
 *  Devuelve una URL en base a los parametros de la configuración
 */
@property (nonatomic, copy, readonly) NSURL *url;

/*!
 *  Devuelve una URL en string en base a los parametros de la configuración
 */
@property (nonatomic, copy, readonly) NSString *urlString;

@property (nonatomic, readonly, copy) NSString *methodString;

@property (nonatomic, strong) NSData *resumeData;

@end
