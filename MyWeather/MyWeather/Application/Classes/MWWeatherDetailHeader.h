//
//  MWWeatherDetailHeader.h
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWWeatherData;

@interface MWWeatherDetailHeader : UIView

+(instancetype) weatherHeaderFromNib;

-(void) setupForWeatherData:(MWWeatherData*) weatherData;
-(void) clearData;
-(void) setCityName:(NSString*) cityName;
@end
