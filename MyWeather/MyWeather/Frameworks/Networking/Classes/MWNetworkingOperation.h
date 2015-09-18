//
// MWNetworkingOperation.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWNetworkingOperationDelegate.h"
#import "MWNetworkingOperationResponse.h"
#import "MWNetworkingOperationError.h"

@class MWNetworkingConfiguration;

/**
 *  Prioridades para las operaciones.
 */
typedef NS_ENUM (NSInteger, MWNetworkingOperationPriority) {
	/**
	 *  Prioridad muy baja
	 */
	MWNetworkingOperationPriorityVeryLow = NSOperationQueuePriorityVeryLow,
	/**
	 *  Prioridad baja
	 */
	MWNetworkingOperationPriorityLow = NSOperationQueuePriorityLow,
	/**
	 *  Prioridad normal
	 */
	MWNetworkingOperationPriorityNormal = NSOperationQueuePriorityNormal,
	/**
	 *  Prioridad alta
	 */
	MWNetworkingOperationPriorityHigh = NSOperationQueuePriorityHigh,
};

/*!
 *  @brief  This class will handle a single network operation. It will handle all the responsability of a request and a response.
    A network operation will work as a "single operation". This means that it can not be reused.
    This operation can be copied.
 */

@interface MWNetworkingOperation : NSOperation <NSCopying>

/**
 *  Delegate utilizado para todos los callback de progreso y completición de la operación
 */
@property (atomic, weak) id <MWNetworkingOperationDelegate> delegate;

/**
 *  Priority for queue execution
 */
@property (nonatomic) MWNetworkingOperationPriority priority;

/**
 *  Bloque de completición con éxito
 *
 *  @param operation      la operación que completó el task
 *  @param responseObject la respuesta final
 */
@property (atomic, copy) void (^successBlock)(MWNetworkingOperation *operation, MWNetworkingOperationResponse *responseObject);

/**
 *  Bloque de completición con error
 *
 *  @param operation La operación que completó el task
 *  @param error     El error obtenido y data adicional
 */
@property (atomic, copy) void (^failureBlock)(MWNetworkingOperation *operation, MWNetworkingOperationError *error);

/**
 *  Bloque de cancelación
 *
 *  @param operation La operación que ejecto el task
 *  @param error     Razones de cancelación y data adicional
 */
@property (atomic, copy) void (^canceledBlock)(MWNetworkingOperation *operation, MWNetworkingOperationError *error);

@property (atomic, copy) void (^invalidationBlock)(MWNetworkingOperation *operation, MWNetworkingOperation *newOperation);

/**
 *  Total de bytes enviados
 */
@property (nonatomic, readonly) int64_t countOfBytesSent;

/**
 *  Total de bytes que se deben enviar
 */
@property (nonatomic, readonly) int64_t countOfBytesExpectedToSend;

/**
 *  Total de bytes recibidos
 */
@property (nonatomic, readonly) int64_t countOfBytesRecieved;

/**
 *  Total de que se esperan recibir.
 */
@property (nonatomic, readonly) int64_t countOfBytesExpectedToRecieve;

/**
 *  Borrar luego si no necesito, solo para test por ahora
 */
@property (nonatomic, copy) NSString *operationIdentifier;

/**
 *  La configuración para hacer el request.
 * Debe ser copy el setter y el getter (revisar la property con copy hace las 2 cosas)
 */
@property (nonatomic, copy) MWNetworkingConfiguration *configuration;

/**
 *  Inicializador designado
 *
 *  @param session Session que utilizara para realizar request
 *  @param config  Objeto necesario para crear las conecciones.
 *
 *  @return Instancia de MWNetworkingOperation
 */

- (id)initWithNetworkingConfig:(MWNetworkingConfiguration *)configuration;

@end
