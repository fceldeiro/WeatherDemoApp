//
// MWSettings.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWSettingsManager.h"

#define kMWSettingsManagerUserDefaultsKeyUnitFormat @"kMWSettingsManagerUserDefaultsKeyUnitFormat"

@interface MWSettingsManager ()
@end

@implementation MWSettingsManager

+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	static MWSettingsManager *shared;

	dispatch_once(&onceToken, ^{
		shared = [[MWSettingsManager alloc] init];
	});
	return shared;
}

- (instancetype)init
{
	if (self = [super init]) {
		NSNumber *unitFormat = [[NSUserDefaults standardUserDefaults] objectForKey:kMWSettingsManagerUserDefaultsKeyUnitFormat];
		if (!unitFormat) {
			_unitFormat = MWUnitFormatImperial;
		} else {
			_unitFormat = [unitFormat integerValue];
		}
	}

	return self;
}

- (void)setUnitFormat:(MWUnitFormat)unitFormat
{
	@synchronized(self)
	{
        
        MWUnitFormat previousUnitFormat = _unitFormat;
        
		_unitFormat = unitFormat;

		[[NSUserDefaults standardUserDefaults] setObject:@(unitFormat) forKey:kMWSettingsManagerUserDefaultsKeyUnitFormat];
        
        if (previousUnitFormat != unitFormat){
        
            NSNotification * unitFormatChangeNotification = [[NSNotification alloc] initWithName:kMWSettingsManagerUnitChanged object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:unitFormatChangeNotification];
        }
        
        
        //Ponerlo despues en una notificacion de aplicación va a cerrarse o ir a background.
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

@end
