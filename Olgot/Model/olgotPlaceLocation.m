//
//  olgotPlaceLocation.m
//  Olgot
//
//  Created by Raed Hamam on 7/4/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotPlaceLocation.h"

@implementation olgotPlaceLocation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end
