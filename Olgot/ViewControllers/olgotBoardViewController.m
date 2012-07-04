//
//  olgotBoardViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotBoardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "olgotItem.h"
#import "olgotItemViewController.h"

@implementation olgotBoardViewController

@synthesize itemCell = _itemCell, categoryID = _categoryID, boardName = _boardName;

@synthesize pullToRefreshView = _pullToRefreshView;

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
        
        _items = [[NSMutableArray alloc] init];
        [_items removeAllObjects];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        
        [self loadItems];
    }
}

- (void)loadItems {
    loadingNew = YES;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    if(_boardName == @"Feed"){
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  [defaults objectForKey:@"userid"], @"id",
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/feeditems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else if (_boardName == @"Nearby") {
        if (nil == locationManager)
            locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        locationManager.distanceFilter = 10;
        
        [locationManager startUpdatingLocation];
        
        

        
    }else if (_boardName == @"My Wants") {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  [defaults objectForKey:@"userid"], @"user",
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/userwants/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _categoryID, @"category", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/categoryitems/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
    }
    
}

-(void)loadNearbyItems
{
    loadingNew = YES;
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                [NSNumber numberWithDouble:locationManager.location.coordinate.latitude], @"lat", 
                [NSNumber numberWithDouble:locationManager.location.coordinate.longitude] , @"long",
                [NSNumber numberWithInt:_currentPage], @"page",
                [NSNumber numberWithInt:_pageSize], @"pagesize",
                                      nil];
            NSString* resourcePath = [@"/nearbyitems/" appendQueryParams:myParams];
            [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];           
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    
     self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
//    Map view button
    UIImage *mapImage30 = [UIImage imageNamed:@"btn-nav-map"];
    
    UIButton *mapBtn = [[UIButton alloc] init];
    mapBtn.frame=CGRectMake(0,0,35,30);
    [mapBtn setBackgroundImage:mapImage30 forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mapBtn];
    
    [self.navigationItem setTitle:_boardName];
    
    _items = [[NSMutableArray alloc] init];
    [_items removeAllObjects];
    _currentPage = 1;
    _pageSize = 10;
    loadingNew = NO;
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.collectionView.scrollView delegate:self];
    
    if(!_categoryID){
        [self loadItems];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (void)showMapView
{
    [self performSegueWithIdentifier:@"ShowMapView" sender:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pullToRefreshView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    NSLog(@"From request %@",[request resourcePath]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded items: %@", objects);
    if([objectLoader.response isOK]){
        loadingNew = NO;
        
        if (self.pullToRefreshView.isExpanded) {
            _items = [[NSMutableArray alloc] initWithArray:objects];
        } else {
            [_items addObjectsFromArray:objects];    
        }
        [self.pullToRefreshView finishLoading];
        [self.collectionView reloadData];

    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}


#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
	return [_items count];
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myItemTileIdentifier = @"BoardItemTileID";
	
    SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myItemTileIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BoardItemTile" owner:self options:nil];
        cell = _itemCell;
        self.itemCell = nil;
    }
    
    UIImageView *itemImage;
    UILabel *itemLabel;
    
    itemImage = (UIImageView *)[cell viewWithTag:1];
    [itemImage setImageWithURL:[NSURL URLWithString:[[_items objectAtIndex:indexPath.row] itemPhotoUrl]]];
    
    itemLabel = (UILabel *)[cell viewWithTag:2]; //description
    [itemLabel setText:[[_items objectAtIndex:indexPath.row] itemDescription]];
    
    itemLabel = (UILabel *)[cell viewWithTag:3]; //venue
    [itemLabel setText:[[_items objectAtIndex:indexPath.row] venueName_En]];
    
    itemLabel = (UILabel *)[cell viewWithTag:4]; //price
    [itemLabel setText:[NSString stringWithFormat:@"%d %@",
      [[[_items objectAtIndex:indexPath.row] itemPrice] integerValue],
      [[_items objectAtIndex:indexPath.row] countryCurrencyShortName]                  
      ]];
    
//    cell.layer.shadowOpacity = 0.5;
//    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//    cell.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    return cell;
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //	header.text = [NSString stringWithFormat:@"Section %i", section + 1];
	header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 19.0f, 0.0f, 19.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(145.0f, 186.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedRowIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ShowItemView" sender:self];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}

-(void)collectionView:(SSCollectionView *)aCollectionView willDisplayItem:(SSCollectionViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I want more");
    if (indexPath.row == ([_items count] - 1) && loadingNew == NO && [_items count] > 4) {
        _currentPage++;
        NSLog(@"loading page %d with item count %d",_currentPage,[_items count]);
        [self loadItems];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowItemView"]){
        olgotItemViewController *itemViewController = [segue destinationViewController];
        
        itemViewController.itemID = [[_items objectAtIndex:_selectedRowIndexPath.row] itemID];
        itemViewController.itemKey = [[_items objectAtIndex:_selectedRowIndexPath.row] itemKey];
    }
}

#pragma mark SSPullToRefreshViewDelegate
-(void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view{
    [self refresh];
}

-(void)refresh{
    [self.pullToRefreshView startLoading];

    _currentPage = 1;
    _pageSize = 10;
    loadingNew = NO;
    
    [self loadItems];
    
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
        [self loadNearbyItems];
    }
    // else skip the event and process the next one.
}


@end
