//
//  olgotVenue.h
//  Olgot
//
//  Created by Raed Hamam on 6/2/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotVenue : NSObject

@property (nonatomic, retain) NSNumber* venueId;
@property (nonatomic, retain) NSString* name_Ar;
@property (nonatomic, retain) NSString* name_En;
@property (nonatomic, retain) NSNumber* geoLat;
@property (nonatomic, retain) NSNumber* geoLong;
@property (nonatomic, retain) NSNumber* items;
@property (nonatomic, retain) NSString* venueIcon;
@property (nonatomic, retain) NSString* foursquareAddress;

@end
