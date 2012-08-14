//
//  olgotAddItemNearbyPlacesViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemNearbyPlacesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "olgotAddItemDetailsViewController.h"
#import "olgotVenue.h"

@interface olgotAddItemNearbyPlacesViewController ()

@end

@implementation olgotAddItemNearbyPlacesViewController

@synthesize capturedImage = _capturedImage, placeCell = _placeCell;
@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadVenues:(NSString*)query {
    loadingNew = YES;
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    NSNumber* lat = [NSNumber numberWithDouble:locationManager.location.coordinate.latitude];
    NSNumber* lng = [NSNumber numberWithDouble:locationManager.location.coordinate.longitude];
    
    NSMutableDictionary* myParams = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                              lat, @"lat", 
                              lng,@"long", 
                              [NSNumber numberWithInt:_currentPage], @"page",
                              [NSNumber numberWithInt:_pageSize], @"pagesize",
                              nil];
    
    
    NSString* resourcePath;
    NSLog(@"query is %@",query);
    if (query) {
        NSLog(@"loading items with query");
        [myParams setValue:query forKey:@"query"];
        resourcePath = [@"/findvenues/" appendQueryParams:myParams];
    }else{
        resourcePath = [@"/nearbyvenues/" appendQueryParams:myParams];
        NSLog(@"requesting nearby place %@", resourcePath);
    }
    
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
    _searchBar.delegate = self;
    [_searchBar setPlaceholder:@"Search..."];
    [_searchBar setShowsCancelButton:NO];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 0.0f;
    
//    self.collectionView.scrollView.bounds = CGRectMake(0, 70.0, 320.0, 410.0);
    [self.collectionView.scrollView setFrame:CGRectMake(0.0, 44.0, 320.0, 430.0)];
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    [self.view addSubview:_searchBar];
    _places = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    loadingNew = NO;
    
    
    UIColor *barColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]; 
    self.searchBar.tintColor = barColor;
    

    
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 10;
    
    [locationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self performSegueWithIdentifier:@"ShowAddItemDetails" sender:self];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.capturedImage = nil;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded actions: %@", objects);
    if([objectLoader.response isOK]){
        loadingNew = NO;
        [_places addObjectsFromArray:objects];
        [self.collectionView reloadData];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowAddItemDetails"]) {
        olgotAddItemDetailsViewController* itemDetailsController = [segue destinationViewController];
        
        itemDetailsController.venue = [_places objectAtIndex:_selectedRowIndexPath.row];
        itemDetailsController.itemImage = _capturedImage;
    }
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    return [_places count];
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myVenueRowIdentifier = @"venueRowCell"; 
    
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myVenueRowIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"nearbyViewPlaceRow" owner:self options:nil];
            cell = _placeCell;
            self.placeCell = nil;
        }
    
    UIImageView* placeImage;
    UILabel* placeLabel;
    
    placeImage = (UIImageView*)[cell viewWithTag:1];
    [placeImage setImageWithURL:[NSURL URLWithString:[[_places objectAtIndex:indexPath.row] venueIcon]]];
    
    placeLabel = (UILabel*)[cell viewWithTag:2];    //place name
    placeLabel.text = [[_places objectAtIndex:indexPath.row] name_En];
    
    placeLabel = (UILabel*)[cell viewWithTag:3];    //place address
    placeLabel.text = [[_places objectAtIndex:indexPath.row] foursquareAddress];
    
    placeLabel = (UILabel*)[cell viewWithTag:4];    //place distance
    placeLabel.text = [[_places objectAtIndex:indexPath.row] distance];

    return cell;
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    header.text = [NSString stringWithFormat:@"Section %i", section + 1];
	header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 19.0f, 0.0f, 19.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    
    return CGSizeMake(300.0f, 80.0f);
    
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        _selectedRowIndexPath = indexPath;
        [self performSegueWithIdentifier:@"ShowAddItemDetails" sender:self];
    }
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}

-(void)collectionView:(SSCollectionView *)aCollectionView willDisplayItem:(SSCollectionViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I want more");
    if (indexPath.row == ([_places count] - 1) && loadingNew == NO && indexPath.section == 0 && ([_places count] > 5)) {
        _currentPage++;
        NSLog(@"loading page %d",_currentPage);
        
        [self loadVenues:self.searchBar.text];
    }
}

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
        [self loadVenues:nil];

    }
    // else skip the event and process the next one.
}

#pragma mark uisearchbardelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length == 0) {
        _places = [[NSMutableArray alloc] init];
        [self.collectionView reloadData];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        [self loadVenues:nil];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _places = [[NSMutableArray alloc] init];
    [self.collectionView reloadData];
    _currentPage = 1;
    _pageSize = 10;
    loadingNew = NO;
    [self loadVenues:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;  
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES; 
} 

@end
