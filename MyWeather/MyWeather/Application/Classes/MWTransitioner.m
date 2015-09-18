//
// MWTransitionDelegate.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/21/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWTransitioner.h"

static NSTimeInterval const MWAnimatedTransitionDuration = 1.0f;


@implementation MWTransitioner

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext
{
 
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        if (self.reverse){
            toViewController.view.transform =CGAffineTransformMakeScale(1, 1);
        }else{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext
{
	return MWAnimatedTransitionDuration;
}

@end
