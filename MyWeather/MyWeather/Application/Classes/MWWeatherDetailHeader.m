//
// MWWeatherDetailHeader.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWWeatherDetailHeader.h"
#import "MWCity.h"
#import "UIView+AutoLayoutCalculator.h"

@interface MWWeatherDetailHeader ()

@property (weak, nonatomic) IBOutlet UILabel *labelCityName;
@property (weak, nonatomic) IBOutlet UILabel *labelConditionDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewConditionIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;

@property (weak, nonatomic) IBOutlet UILabel *labelDay;
@property (weak, nonatomic) IBOutlet UILabel *labelHumidity;
@property (weak, nonatomic) IBOutlet UILabel *labelHumidityValue;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIconSunrise;
@property (weak, nonatomic) IBOutlet UILabel *labelSunrise;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIconSunset;
@property (weak, nonatomic) IBOutlet UILabel *labelSunset;

@property (weak, nonatomic) IBOutlet UIView *customContentView;

@end
@implementation MWWeatherDetailHeader

+ (instancetype)weatherHeaderFromNib
{
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MWWeatherDetailHeader class]) owner:nil options:nil];

	MWWeatherDetailHeader *headerView = nibObjects[0];

	headerView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, [headerView mw_heightForCompressedSize]);

	[headerView setBackgroundColor:[UIColor clearColor]];
	[headerView.customContentView setBackgroundColor:[UIColor clearColor]];

	[headerView setAutoresizesSubviews:NO];
	[headerView setAutoresizingMask:UIViewAutoresizingNone];
	[headerView setTranslatesAutoresizingMaskIntoConstraints:NO];

	[headerView.customContentView setAutoresizesSubviews:NO];
	[headerView.customContentView setAutoresizingMask:UIViewAutoresizingNone];
	[headerView.customContentView setTranslatesAutoresizingMaskIntoConstraints:NO];

	[headerView clearData];

	return headerView;
}

- (void)setupForWeatherData:(MWWeatherData *)weatherData
{
	self.labelCityName.text = weatherData.cityName ? weatherData.cityName : @"Local weather";

	self.labelConditionDescription.text = weatherData.weatherCondition.conditionDescription;

	[self.imageViewConditionIcon setImage:[UIImage imageNamed:weatherData.weatherCondition.imageName]];

	self.labelTemperature.text = weatherData.tempData.currentTemperature;

	self.labelDay.text = @"Today";
	self.labelHumidityValue.text = [NSString stringWithFormat:@"%@%%", [weatherData.humidity stringValue]];
	self.labelHumidity.text = @"Humidity";

	[self needsUpdateConstraints];
	[self layoutIfNeeded];

	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self mw_heightForCompressedSize]);
}

- (void)clearData
{
	self.labelCityName.text = nil;
	self.labelConditionDescription.text = nil;
	[self.imageViewConditionIcon setImage:nil];
	self.labelTemperature.text = nil;
	self.labelDay.text = nil;
	self.labelHumidity.text = nil;
	self.labelHumidityValue.text = nil;
}

- (void)setCityName:(NSString *)cityName
{
	self.labelCityName.text = cityName;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

@end
