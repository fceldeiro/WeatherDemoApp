//
//  MWForecastDatasource.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/23/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MWForecastDatasource : NSObject <UITableViewDataSource>
@property (nonatomic,strong) NSArray * forecastArray;

-(instancetype) initForTableView:(UITableView*) tableView;
@end
