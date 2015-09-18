//
//  MWCityCollectionViewCell.m
//  MyWeather
//
//  Created by Fabian Celdeiro on 1/21/15.
//  Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCityCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MWCityCollectionViewCell()

@property (nonatomic,weak) IBOutlet UIImageView * backgroundImageView;

@property (nonatomic,weak) IBOutlet UILabel * labelCity;

@property (nonatomic,weak) IBOutlet UILabel * labelCountry;


@end
@implementation MWCityCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setupForCity:(MWCity*)city{
    
    self.labelCity.text = city.name;
    self.labelCountry.text = city.countryIdentifier;
    
    NSURL *url = [NSURL URLWithString:city.imageURL];
    
    [self.backgroundImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"collectionViewPlaceHolderImage"]];
    
   
    
    

    
}
@end
