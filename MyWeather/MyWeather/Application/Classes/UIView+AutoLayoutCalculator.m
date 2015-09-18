//
// UIView+AutoLayoutCalculator.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "UIView+AutoLayoutCalculator.h"

@implementation UIView (AutoLayoutCalculator)


- (CGFloat)mw_heightForSystemSize:(CGSize)size
{
	if([self isKindOfClass:[UITableViewCell class]])
	{
		UITableViewCell *selfCell = (UITableViewCell *)self;
		return [selfCell.contentView systemLayoutSizeFittingSize:size].height + 1;
	} else {
		return [self systemLayoutSizeFittingSize:size].height;
	}
}


- (CGFloat)mw_heightForCompressedSize
{
	return [self mw_heightForSystemSize:UILayoutFittingCompressedSize];
}

- (CGFloat)mw_heightForExpandedSize
{
	return [self mw_heightForSystemSize:UILayoutFittingExpandedSize];
}

@end
