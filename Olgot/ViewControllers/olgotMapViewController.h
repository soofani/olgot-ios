//
//  olgotMapViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import "olgotItem.h"
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@class olgotItem;

@interface olgotMapViewController : UIViewController<MKMapViewDelegate,RKObjectLoaderDelegate,CLLocationManagerDelegate>
{
//    IBOutlet UINavigationItem *myNavItem;
    NSArray* _items;
    
    CLLocationManager* locationManager;
    
    NSNumber* _selectedItemID;
    NSNumber* _selectedItemKey;
    
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSString *boardName;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)dismissMap:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *itemCountLabel;


@end
