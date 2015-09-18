//
// ViewController.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCityWeatherDetailViewController.h"

#import "MWCitiesService.h"
#import "MWWeatherService.h"
#import "MWLocationManager.h"

#import "MWCity.h"
#import "MWCoordinates.h"
#import "MWCityManager.h"
#import "MWSettingsViewController.h"
#import "MWCitiesListViewController.h"

#import "MWSettingsManager.h"

#import "MWWeatherDetailHeader.h"
#import "MWWeatherForecastService.h"

#import "MWForecastDatasource.h"
#import "MWTransitionerDelegate.h"

#import "UITableView+MWCustomReloadData.h"
#import "MWMotionEffectGroupParallax.h"
#import "MWTransitionRotateDelegate.h"

@interface MWCityWeatherDetailViewController () <MWWeatherServiceDelegate, MWLocationManagerDelegate, MWCitiesListViewControllerDelegate, MWWeatherForecastServiceDelegate, UIAlertViewDelegate, UITableViewDelegate>

// Transition delegates
@property (nonatomic, strong) MWTransitionerDelegate *mwTransitionDelegate;
@property (nonatomic, strong) MWTransitionRotateDelegate *mwTransitionRotateDelegate;

// Weather service
@property (nonatomic, strong) MWWeatherService *weatherService;

// Forecast sevice
@property (nonatomic, strong) MWWeatherForecastService *weatherForecastService;

// Operation queue for services
@property (nonatomic, strong) NSOperationQueue *servicesOperationQueue;

// Location manager
@property (nonatomic, strong) MWLocationManager *locationManager;

// My dtos
@property (nonatomic, strong) MWCity *citySelected;
@property (nonatomic, strong) MWCoordinates *coordinatesSelected;
@property (nonatomic, strong) MWWeatherData *weatherData;

// Datasources
@property (nonatomic, strong) MWForecastDatasource *forecastDatasource;

// TableView
@property (nonatomic, strong) UITableView *tableView;

// Header
@property (nonatomic, strong)  MWWeatherDetailHeader *viewHeader;

// Background imageView
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

// Blurred image
@property (nonatomic, copy) NSString *blurredImageName;

// Top buttons
@property (weak, nonatomic) IBOutlet UIButton *buttonList;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;

// Loading activity
@property (nonatomic, strong) UIActivityIndicatorView *loadingProgressActivity;

- (IBAction)onButtonSettingsPressed:(id)sender;
- (IBAction)onButtonCitiesPressed:(id)sender;
@end

@implementation MWCityWeatherDetailViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.servicesOperationQueue = [[NSOperationQueue alloc] init];
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.mwTransitionDelegate = [[MWTransitionerDelegate alloc] init];

	NSString *defaultBackgroundImageName = @"clear_d_portrait.jpg";
	NSString *defaultBackgroundImageBlurred = @"clear_d_portrait_blur.jpg";
	self.blurredImageName = defaultBackgroundImageBlurred;

	UIImage *defaultImage = [UIImage imageNamed:defaultBackgroundImageName];
	[self.backgroundImageView setImage:defaultImage];

	MWWeatherDetailHeader *headerView = [MWWeatherDetailHeader weatherHeaderFromNib];

	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

	self.forecastDatasource = [[MWForecastDatasource alloc]initForTableView:tableView];

	[tableView setDataSource:self.forecastDatasource];
	[tableView setDelegate:self];

	[tableView setBackgroundColor:[UIColor clearColor]];
	[tableView setAutoresizesSubviews:NO];
	[tableView setAutoresizingMask:UIViewAutoresizingNone];
	[tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

	[self.view addSubview:headerView];
	[self.view addSubview:tableView];

	[self.view addSubview:self.buttonSettings];
	[self.view addSubview:self.buttonList];

	NSDictionary *viewsDic = NSDictionaryOfVariableBindings(headerView, tableView);

	NSArray *verticalConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView]-0-[tableView]-0-|" options:0 metrics:nil views:viewsDic];

	NSArray *horizontalConstrainsHeaderView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|"  options:0 metrics:nil views:viewsDic];
	NSArray *horizontalConstrainTable = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|"  options:0 metrics:nil views:viewsDic];

	[self.view addConstraints:verticalConstrains];
	[self.view addConstraints:horizontalConstrainsHeaderView];
	[self.view addConstraints:horizontalConstrainTable];

	[self.view needsUpdateConstraints];
	[self.view layoutIfNeeded];

	self.viewHeader = headerView;
	self.tableView = tableView;

	UIView *footerEmpty = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableView.tableFooterView = footerEmpty;

	[self.backgroundImageView addMotionEffect:[[MWMotionEffectGroupParallax alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Si tengo una ciudad tengo que utilizar esa para mostrar los datos del tiempo
	if (self.citySelected) {
	}
	// Si tengo coordenadas uso esas para tratar de mostrar datos del tiempo
	else if (self.coordinatesSelected) {
	}
	// Si no tengo nada trato de buscar coordinates de mi location
	else {
		MWLocationManager *locationManager = [[MWLocationManager alloc] initWithDelegate:self];
		[locationManager startUpdatingLocation];
		self.locationManager = locationManager;
	}

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotificationUnitChanged:) name:kMWSettingsManagerUnitChanged object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - services

- (void)cancelAllServices
{
	[self.loadingProgressActivity removeFromSuperview];

	if ([self.weatherService isExecuting]) {
		[self.weatherService cancel];
	}
	self.weatherService = nil;

	if ([self.weatherForecastService isExecuting]) {
		[self.weatherForecastService cancel];
	}
	self.weatherForecastService = nil;
}

- (void)callWeatherServiceWithCity:(MWCity *)city orCoordinates:(MWCoordinates *)coordinates
{
	[self cancelAllServices];

	MWUnitFormat unitFormat = [[MWSettingsManager sharedInstance] unitFormat];

	if (city) {
		self.weatherService = [[MWWeatherService alloc] initWithCityName:city.name countryIdentifier:city.countryIdentifier andDelegate:self andUnitFormat:unitFormat];

		self.weatherForecastService = [[MWWeatherForecastService alloc] initWithCityName:city.name countryIdentifier:city.countryIdentifier andDelegate:self andUnitFormat:unitFormat];
	} else if (coordinates) {
		self.weatherService = [[MWWeatherService alloc] initWithCoordinates:coordinates andDelegate:self andUnitFormat:unitFormat];

		self.weatherForecastService = [[MWWeatherForecastService alloc] initWithCoordinates:coordinates andDelegate:self andUnitFormat:unitFormat];
	}

	if (self.weatherService && self.weatherForecastService) {
		[self showLoading];

		[self.weatherForecastService addDependency:self.weatherService];
		[self.servicesOperationQueue addOperation:self.weatherService];
		[self.servicesOperationQueue addOperation:self.weatherForecastService];
	}
}

#pragma mark - loading

- (void)showLoading
{
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	[activityView setTranslatesAutoresizingMaskIntoConstraints:NO];

	[activityView setAlpha:0];
	[self.view addSubview:activityView];

	NSLayoutConstraint *constrainX = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	NSLayoutConstraint *constrainY = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

	[self.view addConstraint:constrainX];
	[self.view addConstraint:constrainY];

	self.loadingProgressActivity = activityView;
	[self.loadingProgressActivity startAnimating];

	[UIView animateWithDuration:0.5 animations: ^{
	    [activityView setAlpha:1];
	}];

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideLoading
{
	__weak typeof(self) weakself = self;

	[UIView animateWithDuration:0.8 animations: ^{
	    MWCityWeatherDetailViewController *strongSelf = weakself;
	    [strongSelf.loadingProgressActivity setAlpha:0];
	} completion: ^(BOOL finished) {
	    MWCityWeatherDetailViewController *strongSelf = weakself;
	    [strongSelf.loadingProgressActivity removeFromSuperview];
	}];
}

#pragma mark - LocationManager delegate
- (void)mwLocationManager:(MWLocationManager *)locationManager didRecievedLocation:(MWCoordinates *)coordinates
{
	// Me vino una location entonces voy a llamar al servicio de weather para conseguir datos de esas coordenadas
	self.coordinatesSelected = coordinates;
	[self callWeatherServiceWithCity:nil orCoordinates:coordinates];
	[self.locationManager stopUpdatingLocation];
}

- (void)mwLocationManager:(MWLocationManager *)locationManager didFailedtoRecieveLocation:(NSError *)error
{
	[self.locationManager stopUpdatingLocation];

	// Pedir la city default
	MWCity *defaultCity = [[MWCityManager sharedInstance] defaultCity];
	self.citySelected = defaultCity;

	[self.viewHeader clearData];
	[self.viewHeader setCityName:defaultCity.name];
	[self callWeatherServiceWithCity:defaultCity orCoordinates:nil];
}

#pragma mark - Weather Service
- (void)mwWeatherService:(MWWeatherService *)service didFinishedWithWeatherData:(MWWeatherData *)weatherData
{
	[self hideLoading];

	weatherData.cityName = self.citySelected.name;

	self.weatherData = weatherData;
	self.citySelected.weatherData = weatherData;

	NSString *imageLargeName = [weatherData.weatherCondition imageNameLarge];
	if (!imageLargeName) {
		imageLargeName = @"clear_d_portrait.jpg";
	}

	self.blurredImageName = [weatherData.weatherCondition imageNameLargeBlurred];

	UIImage *toImage = [UIImage imageNamed:imageLargeName];

	[UIView transitionWithView:self.backgroundImageView
	                  duration:2.0f
	                   options:UIViewAnimationOptionTransitionCrossDissolve
	                animations: ^{
	    [self.viewHeader setupForWeatherData:weatherData];
	    self.backgroundImageView.image = toImage;
	} completion:nil];

// NSLog(@"Weather data %@", weatherData);
}

- (void)mwWeatherService:(MWWeatherService *)service didFailedWithError:(NSError *)error
{
	[self hideLoading];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	[self cancelAllServices];

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];

	[alertView show];

// NSLog(@"Weather service error %@", error);
}

#pragma mark - Forecast service
- (void)mwWeatherForecastService:(MWWeatherForecastService *)service didFinishedWithWeatherData:(NSArray *)futureWeatherData
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	self.forecastDatasource.forecastArray = futureWeatherData;
	[self.tableView mw_customReloadData];
	// [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	// [self.tableView reloadData];
}

- (void)mwWeatherForecastService:(MWWeatherForecastService *)service didFailedWithError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	self.forecastDatasource.forecastArray = nil;
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

// NSLog(@"Error %@", error);
}

#pragma mark - Cities List delegate
- (void)mwCitiesListViewControllerDelegate:(MWCitiesListViewController *)controller didSelectCity:(MWCity *)citySelected
{
	// MWCity *currentCitySelected = self.citySelected;

	self.citySelected = citySelected;

	[self.viewHeader clearData];
	[self.viewHeader setCityName:citySelected.name];

	[controller dismissViewControllerAnimated:YES completion: ^{
	    // Si me avisa que cambio de ciudad  voy a buscar la data

	    [self callWeatherServiceWithCity:citySelected orCoordinates:nil];
	}];
}

- (void)mwCitiesListViewControllerDelegateDidCancel:(MWCitiesListViewController *)controller
{
	[controller dismissViewControllerAnimated:YES completion: ^{
	}];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex) {
		[self callWeatherServiceWithCity:self.citySelected orCoordinates:nil];
	}
}

#pragma  mark - notification
- (void)onNotificationUnitChanged:(id)sender
{
	[self.viewHeader clearData];
	[self.viewHeader setCityName:self.citySelected.name];
	self.forecastDatasource.forecastArray = nil;
	[self.tableView reloadData];

	[self cancelAllServices];

	[self callWeatherServiceWithCity:self.citySelected orCoordinates:self.coordinatesSelected];
}

#pragma mark - Actions
- (void)onButtonSettingsPressed:(id)sender
{
	MWSettingsViewController *settingsViewController = [[MWSettingsViewController alloc] init];
	[settingsViewController view];

	[settingsViewController.imageViewBackground setImage:[UIImage imageNamed:self.blurredImageName]];

	if (!self.mwTransitionRotateDelegate) {
		self.mwTransitionRotateDelegate = [[MWTransitionRotateDelegate alloc] init];
	}
	[settingsViewController setTransitioningDelegate:self.mwTransitionRotateDelegate];

	[self presentViewController:settingsViewController animated:YES completion: ^{
	}];
}

- (void)onButtonCitiesPressed:(id)sender
{
	self.coordinatesSelected = nil;

	MWCitiesListViewController *citiesListViewController = [[MWCitiesListViewController alloc] init];
	[citiesListViewController setDelegate:self];
	[citiesListViewController setTransitioningDelegate:self.mwTransitionDelegate];

	[self cancelAllServices];

	[self presentViewController:citiesListViewController animated:YES completion: ^{
	    self.forecastDatasource.forecastArray = nil;
	    [self.tableView reloadData];
	}];
}

#pragma mark - status bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
