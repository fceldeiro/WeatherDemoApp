//
//  MWTransitionerDelegate.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/23/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWTransitionerDelegate.h"

#import "MWTransitioner.h"

@interface MWTransitionerDelegate()
@end

@implementation MWTransitionerDelegate


- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented
                                                                    presentingController:(UIViewController *)presenting
                                                                        sourceController:(UIViewController *)source
{
    MWTransitioner *transitioner = [[MWTransitioner alloc] init];
    return transitioner;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed
{
    MWTransitioner *transitioner = [[MWTransitioner alloc] init];
    transitioner.reverse = YES;
    return transitioner;
}

@end
