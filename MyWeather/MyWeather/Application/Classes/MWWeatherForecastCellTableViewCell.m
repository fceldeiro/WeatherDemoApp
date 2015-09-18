//
//  MWWeatherForecastCellTableViewCell.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/20/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherForecastCellTableViewCell.h"
#import "MWWeatherCondition.h"


@interface MWWeatherForecastCellTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelMinTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelDay;

@end


@implementation MWWeatherForecastCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setupForForecastDayData:(MWWeatherForecastDayData*) data{
    
    self.labelMaxTemp.text = data.tempMax;
    self.labelMinTemp.text = data.tempMin;
    
    
    NSDate * dateFromSeconds = [NSDate dateWithTimeIntervalSince1970:data.dt.integerValue];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *dayName = [dateFormatter stringFromDate:dateFromSeconds];
    
    self.labelDay.text = dayName;
    
    [self.imageViewIcon setImage:[UIImage imageNamed:data.weatherCondition.imageName]];
    
    [self needsUpdateConstraints];
    [self layoutIfNeeded];
    
    
    
    
}

@end
