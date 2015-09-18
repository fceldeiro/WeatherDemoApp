//
//  MWWeatherForecastCellTableViewCell.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWWeatherForecastDayData.h"

@interface MWWeatherForecastCellTableViewCell : UITableViewCell

-(void) setupForForecastDayData:(MWWeatherForecastDayData*) data;

@end
