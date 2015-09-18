//
//  MWTransitionRotateDelegate.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/23/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWTransitionRotateDelegate.h"
#import "MWTransitionRotate.h"

@implementation MWTransitionRotateDelegate


- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented
                                                                    presentingController:(UIViewController *)presenting
                                                                        sourceController:(UIViewController *)source
{
    MWTransitionRotate *transitioner = [[MWTransitionRotate alloc] init];
    return transitioner;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed
{
    MWTransitionRotate *transitioner = [[MWTransitionRotate alloc] init];
    transitioner.reverse = YES;
    return transitioner;
}
@end
