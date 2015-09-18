//
// CitiesServiceResponse.m
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCitiesServiceResponse.h"
#import "NSDictionary+NSNull.h"
#import "MWCity.h"

@implementation MWCitiesServiceResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init]) {
		NSArray *citiesArray = [dictionary mw_objectForKey:@"cities"];
		NSMutableArray *cities = [NSMutableArray arrayWithCapacity:citiesArray.count];

		if (citiesArray && [citiesArray isKindOfClass:[NSArray class]]) {
			for (NSDictionary *cityDic in citiesArray) {
				MWCity *city = [[MWCity alloc] initWithDictionary:cityDic];
				[cities addObject:city];
			}
		}

		self.cities = [NSArray arrayWithArray:cities];
	}

	return self;
}

@end
