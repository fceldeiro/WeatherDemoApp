//
//  MWCityCollectionViewCell.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/21/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWCity.h"

@interface MWCityCollectionViewCell : UICollectionViewCell


-(void) setupForCity:(MWCity*)city;

@end
