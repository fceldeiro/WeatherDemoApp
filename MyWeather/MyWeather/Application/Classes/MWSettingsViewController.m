//
// MWSettingsViewController.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWSettingsViewController.h"
#import "MWUnitFormat.h"
#import "MWSettingsManager.h"
#import "MWMotionEffectGroupParallax.h"

#define kMWSettingsControllerCelcius @"Celcius"
#define kMWSettingsControllerFarenheit @"Farenheit"

@interface MWSettingsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *pickerDto;

@property (nonatomic, strong) NSDictionary *mapTemperatureKeysWithUnitEnum;

- (IBAction)onBtnCancelPressed:(id)sender;

- (IBAction)onBtnDonePressed:(id)sender;

@end

@implementation MWSettingsViewController

#pragma mark - NSOBJect
- (instancetype)init
{
	if (self = [super init]) {
	}

	return self;
}

#pragma mark - view

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];

	self.pickerDto = @[kMWSettingsControllerCelcius, kMWSettingsControllerFarenheit];

	self.mapTemperatureKeysWithUnitEnum = @{@(MWUnitFormatMetric) : kMWSettingsControllerCelcius,
		                                    @(MWUnitFormatImperial) : kMWSettingsControllerFarenheit};

	// Mejorar esto por dios, (así nomas para que funque para iterar).
	MWUnitFormat unitFormat = [[MWSettingsManager sharedInstance]unitFormat];

	if (unitFormat == MWUnitFormatMetric) {
		[self.pickerView selectRow:0 inComponent:0 animated:NO];
	} else {
		[self.pickerView selectRow:1 inComponent:0 animated:NO];
	}

	self.labelTitle.text = self.mapTemperatureKeysWithUnitEnum[@(unitFormat)];
    
    [self.imageViewBackground addMotionEffect:[[MWMotionEffectGroupParallax alloc] init]];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)onBtnCancelPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion: ^{
	}];
}

- (void)onBtnDonePressed:(id)sender
{
	MWUnitFormat unitFormat = [[MWSettingsManager sharedInstance] unitFormat];

	// Estoy cambiando de c a f
	if ([self.labelTitle.text isEqualToString:kMWSettingsControllerCelcius] &&         unitFormat != MWUnitFormatMetric) {
		[[MWSettingsManager sharedInstance] setUnitFormat:MWUnitFormatMetric];
	}

	// Estoy cambiando de f a c
	if ([self.labelTitle.text isEqualToString:kMWSettingsControllerFarenheit] && unitFormat != MWUnitFormatImperial) {
		[[MWSettingsManager sharedInstance] setUnitFormat:MWUnitFormatImperial];
	}

	[self dismissViewControllerAnimated:YES completion: ^{
	}];
}

#pragma mark - Picker
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.pickerDto.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = self.pickerDto[row];
	NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

	return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.labelTitle.text = self.pickerDto[row];
}

#pragma mark - status
#pragma mark - status bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
