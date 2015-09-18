//
//  MWForecastDatasource.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/23/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWForecastDatasource.h"
#import "MWWeatherForecastCellTableViewCell.h"
@implementation MWForecastDatasource

#pragma mark - TableView delegates


-(instancetype) initForTableView:(UITableView *)tableView{
    
    if (self = [super init]){
        
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MWWeatherForecastCellTableViewCell class]) bundle:[NSBundle mainBundle]];
        
        [tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([MWWeatherForecastCellTableViewCell class])];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forecastArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Si hay más tiempo pasarlo a autolayout con prototipo.
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWWeatherForecastCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MWWeatherForecastCellTableViewCell class])];
    
    [cell setupForForecastDayData:self.forecastArray[indexPath.row]];
    return cell;
}

@end
