//
//  olgotItemLocation.m
//  Olgot
//
//  Created by Raed Hamam on 7/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotItemLocation.h"
#import "UIImageView+AFNetworking.h"

@implementation olgotItemLocation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize imageUrl = _imageUrl;
@synthesize itemID = _itemID;
@synthesize itemKey = _itemKey;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate{
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
