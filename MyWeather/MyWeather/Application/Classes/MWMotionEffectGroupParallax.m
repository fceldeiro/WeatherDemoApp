//
// MWMotionEffectGroupParallax.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/23/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWMotionEffectGroupParallax.h"

@implementation MWMotionEffectGroupParallax

- (instancetype)init
{
	if (self = [super init]) {
		// Set vertical effect
		UIInterpolatingMotionEffect *verticalMotionEffect =
		    [[UIInterpolatingMotionEffect alloc]
		     initWithKeyPath:@"center.y"
		                type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		verticalMotionEffect.minimumRelativeValue = @(-20);
		verticalMotionEffect.maximumRelativeValue = @(20);

		// Set horizontal effect
		UIInterpolatingMotionEffect *horizontalMotionEffect =
		    [[UIInterpolatingMotionEffect alloc]
		     initWithKeyPath:@"center.x"
		                type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontalMotionEffect.minimumRelativeValue = @(-20);
		horizontalMotionEffect.maximumRelativeValue = @(20);

		// Create group to combine both
		self.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

		// Add both effects to your view
	}

	return self;
}

@end
