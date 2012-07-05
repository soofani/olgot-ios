//
//  olgotVenueMapViewController.h
//  Olgot
//
//  Created by Raed Hamam on 6/22/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "olgotVenue.h"

#define METERS_PER_MILE 1609.344

@class olgotVenue;

@interface olgotVenueMapViewController : UIViewController<MKMapViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) olgotVenue* venue;

@end
