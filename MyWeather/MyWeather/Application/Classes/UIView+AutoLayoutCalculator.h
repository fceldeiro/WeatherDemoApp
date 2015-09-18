//
// UIView+AutoLayoutCalculator.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayoutCalculator)


- (CGFloat)mw_heightForSystemSize:(CGSize)size;

- (CGFloat)mw_heightForCompressedSize;

- (CGFloat)mw_heightForExpandedSize;

@end
