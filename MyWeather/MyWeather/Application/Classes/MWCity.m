//
// City.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWCity.h"
#import "NSDictionary+NSNull.h"

#define kMWCityKeyCity @"city"
#define kMWCityKeyCountry @"country"
#define kMWCityKeyImageURL @"imageURL"

@implementation MWCity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	if (self = [super init]) {
		self.name = [dictionary mw_objectForKey:kMWCityKeyCity];
		self.countryIdentifier = [dictionary mw_objectForKey:kMWCityKeyCountry];
		self.imageURL = [dictionary mw_objectForKey:kMWCityKeyImageURL];
	}

	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		self.name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
		self.imageURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imageURL))];
		self.countryIdentifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(countryIdentifier))];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:NSStringFromSelector(@selector(name))];
	[aCoder encodeObject:self.imageURL forKey:NSStringFromSelector(@selector(imageURL))];
	[aCoder encodeObject:self.countryIdentifier forKey:NSStringFromSelector(@selector(countryIdentifier))];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"CityName = %@\nCountryName = %@\nImageURL = %@\n", self.name, self.countryIdentifier, self.imageURL];
}


-(BOOL) isEqual:(id)object{
    
    
    BOOL equal = YES;
    
    
    equal &= [object isKindOfClass:[MWCity class]];
    
    if (equal){
        
        MWCity * otherCity = (MWCity*) object;
        
        
        equal &= [self.name isEqualToString:[otherCity name]];
        equal &= [self.countryIdentifier isEqualToString:[otherCity countryIdentifier]];
        
    }
 
    return equal;
}
@end
