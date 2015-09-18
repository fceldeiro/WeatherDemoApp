//
// MWLocationManager.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MWLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *lastLocation;
@end

@implementation MWLocationManager

- (instancetype)initWithDelegate:(id <MWLocationManagerDelegate> )delegate
{
	if (self = [super init]) {
		self.delegate = delegate;
	}

	return self;
}

- (void)stopUpdatingLocation
{
	if (self.locationManager) {
		[self.locationManager stopUpdatingLocation];
	}
}

- (void)startUpdatingLocation
{
	if ([CLLocationManager locationServicesEnabled]) {
		// In order to show the route, we must retrieve the user location first
		self.locationManager = [[CLLocationManager alloc] init];

		// Si tengo una location corto aca
        
        
        /*
		if (!self.locationManager.location) {
			MWCoordinates *coordinates = [[MWCoordinates alloc] init];
			coordinates.latitude = @(self.locationManager.location.coordinate.latitude);
			coordinates.longitude = @(self.locationManager.location.coordinate.longitude);

			if ([self.delegate respondsToSelector:@selector(mwLocationManager:didRecievedLocation:)]) {
				[self.delegate mwLocationManager:self didRecievedLocation:coordinates];
			}
		} else {*/
			self.locationManager.delegate = self;

			// Check for iOS 8.
			if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
				[self.locationManager requestWhenInUseAuthorization];
			}

			// [self showLoadingMessage:kLoadingLocalized];

			// We check if the user has location enabled
			CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
			if (status == kCLAuthorizationStatusDenied) {
				if ([self.delegate respondsToSelector:@selector(mwLocationManager:didFailedtoRecieveLocation:)]) {
					[self.delegate mwLocationManager:self didFailedtoRecieveLocation:[NSError errorWithDomain:@"Failed to recieve location" code:403 userInfo:nil]];
				}
			} else {
				[self.locationManager startUpdatingLocation];

			}
		//}
	} else {
		// No tengo permisos de location
		if ([self.delegate respondsToSelector:@selector(mwLocationManager:didFailedtoRecieveLocation:)]) {
			[self.delegate mwLocationManager:self didFailedtoRecieveLocation:[NSError errorWithDomain:@"Failed to recieve location" code:403 userInfo:nil]];
		}
	}
}

#pragma mark - location delegate

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager

     didUpdateLocations:(NSArray *)locations
{
    
    [manager stopUpdatingLocation];
    
	// If it's a relatively recent event, turn off updates to save power.
	CLLocation *location = [locations lastObject];
	//NSDate *eventDate = location.timestamp;
	
    
    MWCoordinates *coordinates = [[MWCoordinates alloc] init];
    coordinates.latitude = @(location.coordinate.latitude);
    coordinates.longitude = @(location.coordinate.longitude);

    if ([self.delegate respondsToSelector:@selector(mwLocationManager:didRecievedLocation:)]) {
        [self.delegate mwLocationManager:self didRecievedLocation:coordinates];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [manager stopUpdatingLocation];
    
	//NSLog(@"Location error");

	if ([self.delegate respondsToSelector:@selector(mwLocationManager:didFailedtoRecieveLocation:)]) {
		[self.delegate mwLocationManager:self didFailedtoRecieveLocation:error];
	}
}

@end
