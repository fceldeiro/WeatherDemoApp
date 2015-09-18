//
// MWUnitFormat.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Prioridades para las operaciones.
 */
typedef NS_ENUM (NSInteger, MWUnitFormat) {
	/**
	 *  Prioridad muy baja
	 */
	MWUnitFormatMetric = 0,
	/**
	 *  Prioridad baja
	 */
	MWUnitFormatImperial = 1,
    
};
