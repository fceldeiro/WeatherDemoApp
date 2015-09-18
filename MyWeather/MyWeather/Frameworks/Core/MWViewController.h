//
// MWViewController.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWViewController : UIViewController

-(void) showLoadingMessage:(NSString*) text;
-(void) hideLoadingMessage;

@end
