//
// MWCitiesListViewController.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCitiesListViewController.h"
#import "MWCityManager.h"
#import "MWCityCollectionViewCell.h"

@interface MWCitiesListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) NSArray *cities;

@end

@implementation MWCitiesListViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MWCityCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    [self.collectionView setAutoresizesSubviews:NO];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingNone];
    [self.collectionView setNeedsDisplay];
    [self.collectionView setNeedsLayout];
    
    [self.view needsUpdateConstraints];
    [self.view layoutSubviews];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:NSStringFromClass([MWCityCollectionViewCell class])];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    self.cities = [[MWCityManager sharedInstance] cities];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Collecion view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	MWCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MWCityCollectionViewCell class]) forIndexPath:indexPath];

	MWCity *city = self.cities[indexPath.row];

	[cell setupForCity:city];

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	const CGFloat heightOfScreen = self.collectionView.bounds.size.height;

	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;

	const CGFloat minLineSpacing = [flowLayout minimumLineSpacing];

	const NSInteger ammountOfItemsIWantPerHeight = 3;

	CGFloat totalSpacing = minLineSpacing * (ammountOfItemsIWantPerHeight - 1);

	CGFloat heightOfCell = (heightOfScreen - totalSpacing) / ammountOfItemsIWantPerHeight;

	return CGSizeMake(collectionView.bounds.size.width, heightOfCell);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	MWCity *citySelected = self.cities[indexPath.row];

	if ([self.delegate respondsToSelector:@selector(mwCitiesListViewControllerDelegate:didSelectCity:)]) {
		[self.delegate mwCitiesListViewControllerDelegate:self didSelectCity:citySelected];
	}
}

#pragma mark - status bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
