//
//  olgotMapViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotMapViewController.h"
#import "olgotItemLocation.h"
#import "olgotCustomAnnotationView.h"
#import "olgotItemViewController.h"



@interface olgotMapViewController ()

@end

@implementation olgotMapViewController
@synthesize itemCountLabel = _itemCountLabel;

@synthesize mapView = _mapView;
@synthesize boardName = _boardName, categoryID = _categoryID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setCategoryID:(NSNumber *)categoryID
{
    if (_categoryID != categoryID) {
        _categoryID = categoryID;
        
        [self loadItems];
    }
}

-(void)setBoardName:(NSString *)boardName
{
    if (![_boardName isEqual:boardName]) {
        _boardName = boardName;
        [self loadItems];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    
    UIImage *boardImage30 = [UIImage imageNamed:@"btn-nav-board"];
    
    UIButton *boardBtn = [[UIButton alloc] init];
    boardBtn.frame=CGRectMake(0,0,35,30);
    [boardBtn setBackgroundImage:boardImage30 forState:UIControlStateNormal];
    [boardBtn addTarget:self action:@selector(showBoardView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:boardBtn];
    
    self.title = _boardName;
//    myNavItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:boardBtn];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.mapView.delegate = self;
    
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 10;
    
    [locationManager startUpdatingLocation];
}


- (void)showBoardView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setItemCountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissMap:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadItems {    
    // Load the object model via RestKit
    defaults = [NSUserDefaults standardUserDefaults];
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    if([_boardName isEqual:@"Feed"]){
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  [defaults objectForKey:@"userid"], @"id",
                                  nil];
        NSString* resourcePath = [@"/mapfeeditems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else if ([_boardName isEqual:@"Nearby"]) {
        [locationManager startUpdatingLocation];
    }else if ([_boardName isEqual:@"My Wants"]) {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  [defaults objectForKey:@"userid"], @"user",
                                  nil];
        NSString* resourcePath = [@"/mapuserwants/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }
    else if ([_boardName isEqual:@"Hot"]) {
        [locationManager startUpdatingLocation];
    }
    else {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _categoryID, @"category", 
                                  nil];
        NSString* resourcePath = [@"/mapcategoryitems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
    }
    
}

-(void)loadLocationRelatedItems
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys:
                              [defaults objectForKey:@"userid"], @"id",
                              [NSNumber numberWithDouble:locationManager.location.coordinate.latitude], @"lat", 
                              [NSNumber numberWithDouble:locationManager.location.coordinate.longitude], @"long",
                              nil];
    
    if (_boardName == @"Nearby") {
        NSString* resourcePath = [@"/mapnearbyitems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
    }else if (_boardName == @"Hot") {
        NSString* resourcePath = [@"/maphotitems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
    }
}

-(void)plotItems
{
    CLLocationCoordinate2D coordinate;
    for (olgotItem* _item in _items) {
        NSLog(@"plotting venue %@ %f %f",_item, [[_item venueGeoLat] doubleValue],[[_item venueGeoLong] doubleValue]);
        // 1

        coordinate.latitude = [[_item venueGeoLat] doubleValue];
        coordinate.longitude= [[_item venueGeoLong] doubleValue];
        
        olgotItemLocation *annotation = [[olgotItemLocation alloc] initWithName:[_item venueName_En] address:[_item itemDescription] coordinate:coordinate];
        
        annotation.imageUrl = [_item itemPhotoUrl];
        annotation.itemID = [_item itemID];
        annotation.itemKey = [_item itemKey];
        
        [_mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[olgotItemLocation class]])
    {
        // Try to dequeue an existing pin view first.
        olgotCustomAnnotationView* pinView = (olgotCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[olgotCustomAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:@"CustomPinAnnotation"];

            pinView.canShowCallout = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
            
//            [rightButton addTarget:self action:@selector(showItemPage:)
//                  forControlEvents:UIControlEventTouchUpInside];
            
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;   
}

-(void)showItemPage:(UIButton*)sender{
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control{
    olgotCustomAnnotationView* mView = (olgotCustomAnnotationView*)view;
    _selectedItemID = mView.itemID;
    _selectedItemKey = mView.itemKey;
    [self performSegueWithIdentifier:@"ShowItemFromMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowItemFromMap"]) {
        olgotItemViewController *itemViewController = [segue destinationViewController];
        itemViewController.itemID = _selectedItemID;
        itemViewController.itemKey = _selectedItemKey;
    }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    NSLog(@"From request %@",[request resourcePath]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded items: %@", objects);
    if([objectLoader.response isOK]){
        
        _items = objects;
        [[self itemCountLabel] setText:[NSString stringWithFormat:@"%d Items",[_items count]]];
        [self plotItems];
        
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    NSLog(@"Hit error: %@", error);
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          newLocation.coordinate.latitude,
          newLocation.coordinate.longitude);
    
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        [manager stopUpdatingLocation];
        
        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1.5*METERS_PER_MILE, 1.5*METERS_PER_MILE);
        // 3
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];                
        // 4
        [_mapView setRegion:adjustedRegion animated:YES];
        
        [self loadLocationRelatedItems];
        
    }else {
        [self loadLocationRelatedItems];
    }
}

@end
