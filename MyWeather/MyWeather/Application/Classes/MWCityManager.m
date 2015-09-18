//
// MWCityManager.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCityManager.h"
#import "MWCitiesService.h"
#import "MWCity.h"
#import <SDWebImage/SDWebImagePrefetcher.h>

#define  kMWCityManagerDefaultCityName @"New York"
#define  kMWCityManagerDefaultCityCountry @"USA"

@interface MWCityManager () <MWCitiesServiceDelegate>
@property (atomic, strong, readwrite) NSArray *cities;
@property (nonatomic, strong) MWCitiesService *citiesService;

@property (nonatomic,strong) NSOperationQueue *serialQueue;
@end

@implementation MWCityManager



+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	static MWCityManager *shared;

	dispatch_once(&onceToken, ^{
		shared = [[MWCityManager alloc] init];
	});
	return shared;
}


-(instancetype) init{
    
    if (self = [super init]){
        
        self.serialQueue = [[NSOperationQueue alloc] init];
        [self.serialQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}
+(MWCity*) cityFromName:(NSString*) cityName fromCitiesArray:(NSArray*) citiesArray{
    
    return [self cityFromName:cityName andCountry:nil fromCitiesArray:citiesArray];
}

+(MWCity*) cityFromName:(NSString*) cityName andCountry:(NSString*) countryIdentifier fromCitiesArray:(NSArray*) citiesArray{
    
    
    //Medio ineficiente
    for (MWCity * city in citiesArray){
        if ([[city name] isEqualToString:cityName] && [[city countryIdentifier] isEqualToString:countryIdentifier]){
            
            return city;
        }
    }
    
    return nil;
}


-(MWCity*) defaultCity{
 
    NSArray * defaultCityArray = self.cities;
    
    return [MWCityManager cityFromName:kMWCityManagerDefaultCityName andCountry:kMWCityManagerDefaultCityCountry fromCitiesArray:defaultCityArray];
    
}

+(MWCity*) defaultCityFromCitiesArray:(NSArray*) citiesArray{
    
    return [self cityFromName:kMWCityManagerDefaultCityName andCountry:kMWCityManagerDefaultCityCountry fromCitiesArray:citiesArray];
    
    
}

- (void)updateCitiesWithNewCityArray:(NSArray*) newCityArray{
    

    
    __weak typeof (self) weakSelf = self;
    
    [self.serialQueue addOperationWithBlock:^{
        
        MWCityManager * strongSelf = weakSelf;
        
        for (MWCity * city in newCityArray){
            
            for (MWCity * oldCity in strongSelf.cities){
                
                if ([city isEqual:oldCity]){
                    city.weatherData = oldCity.weatherData;
                }
            }
        }
        
        strongSelf.cities = newCityArray;
        
        //Ahora tengo las nuevas ciuidades (sigilosamente voy a cargar las fotos)
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSArray * arrayCopy = [newCityArray copy];
        
            NSMutableArray * imageURLToPrefetchMutable = [NSMutableArray arrayWithCapacity:newCityArray.count];
            
            for (MWCity * city in arrayCopy){
                NSURL * url = [NSURL URLWithString:city.imageURL];
                [imageURLToPrefetchMutable addObject:url];
            }
            
            NSArray * imageURLToPrefetchInmutable = [NSArray arrayWithArray:imageURLToPrefetchMutable];
        
            
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLToPrefetchInmutable];
            
        });
        

    }];
    
   }
- (void)updateCities
{
	// Si no tengo un city service o tengo uno y esta corriendo
	if (![self.citiesService isExecuting]) {
		self.citiesService = [[MWCitiesService alloc]initWithDelegate:self];
        [self.serialQueue addOperation:self.citiesService];
	}
}


- (NSArray *)citiesArrayFromData:(NSData *)data
{
	NSError *error = nil;
	NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
	if (error) {
		return nil;
	} else {
		NSArray *citiesArray = resultDic[@"cities"];

		NSMutableArray *citiesMutable = [NSMutableArray arrayWithCapacity:citiesArray.count];

		for (NSDictionary *cityDic in citiesArray) {
			[citiesMutable addObject:[[MWCity alloc] initWithDictionary:cityDic]];
		}
		return [NSArray arrayWithArray:citiesMutable];
	}
}



- (void)startManager
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];

	NSData *jsonData = [NSData dataWithContentsOfFile:filePath];

	self.cities = [self citiesArrayFromData:jsonData];
    
    [self updateCities];
}

#pragma mark - Cities delegate
- (void)mwCitiesService:(MWCitiesService *)service didFinishedWithResponse:(MWCitiesServiceResponse *)response
{
    
   
    NSArray * newCitiesArray = response.cities;
     self.citiesService = nil;
    [self updateCitiesWithNewCityArray:newCitiesArray];
    

}

- (void)mwCitiesService:(MWCitiesService *)service didFailedWithError:(NSError *)error
{
    self.citiesService = nil;
//    NSLog(@"Error fetching cities");
}

@end
