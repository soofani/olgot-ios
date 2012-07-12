//
//  olgotItemLocation.h
//  Olgot
//
//  Created by Raed Hamam on 7/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface olgotItemLocation : NSObject<MKAnnotation>{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    NSString *_imageUrl;
    NSNumber *_itemID;
    NSNumber *_itemKey;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSNumber *itemID;
@property (nonatomic, retain) NSNumber *itemKey;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
