//
// UITableView+MWCustomReloadData.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/23/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "UITableView+MWCustomReloadData.h"

@implementation UITableView (MWCustomReloadData)

- (void)mw_customReloadData
{
	[self reloadData];

	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[animation setFillMode:kCAFillModeBoth];
	[animation setDuration:1.0];
	[[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
}

@end
