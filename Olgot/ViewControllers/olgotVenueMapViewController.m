//
//  olgotVenueMapViewController.m
//  Olgot
//
//  Created by Raed Hamam on 6/22/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotVenueMapViewController.h"
#import "olgotPlaceLocation.h"

@interface olgotVenueMapViewController ()

@end

@implementation olgotVenueMapViewController
@synthesize mapView = _mapView, venue = _venue;

-(void)setVenue:(olgotVenue *)newVenue
{
    if (_venue != newVenue) {
        _venue = newVenue;
        [self plotVenue];
    }
}

-(void)plotVenue
{
    NSLog(@"plotting venue %@ %f %f",_venue, [[_venue geoLat] doubleValue],[[_venue geoLong] doubleValue]);
    // 1
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[_venue geoLat] doubleValue];
    coordinate.longitude= [[_venue geoLong] doubleValue];
    
    olgotPlaceLocation *annotation = [[olgotPlaceLocation alloc] initWithName:[_venue name_En] address:[_venue foursquareAddress] coordinate:coordinate];
    [_mapView addAnnotation:annotation];
    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//
//    // 3
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];                
//    // 4
//    [_mapView setRegion:adjustedRegion animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _mapView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_venue) {
        [self plotVenue];
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setVenue:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[olgotPlaceLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;    
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self zoomToFitMapAnnotations:_mapView];
}

@end
