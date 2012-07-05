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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];                
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
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
//        annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;    
}

@end
