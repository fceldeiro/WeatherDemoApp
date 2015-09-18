//
// MWCitiesListViewController.h
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWViewController.h"
#import "MWCity.h"

@class MWCitiesListViewController;

@protocol  MWCitiesListViewControllerDelegate <NSObject>

- (void)mwCitiesListViewControllerDelegate:(MWCitiesListViewController *)controller didSelectCity:(MWCity *)citySelected;
- (void)mwCitiesListViewControllerDelegateDidCancel:(MWCitiesListViewController *)controller;

@end
@interface MWCitiesListViewController : MWViewController

@property (nonatomic, weak) id <MWCitiesListViewControllerDelegate> delegate;
@end
