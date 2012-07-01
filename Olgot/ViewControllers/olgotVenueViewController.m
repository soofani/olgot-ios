//
//  olgotVenueViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotVenueViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "olgotItem.h"
#import "olgotItemViewController.h"

@interface olgotVenueViewController ()

@end

@implementation olgotVenueViewController

@synthesize venueCardTile = _venueCardTile, venueItemTile = _venueItemTile;

@synthesize venueId = _venueId;

@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize venueLocationBtn = _venueLocationBtn;
@synthesize venueMapButton = _venueMapButton;
@synthesize venueAddressLabel = _venueAddressLabel;
@synthesize venueIconImageView = _venueIconImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setVenueId:(NSNumber *)venueId
{
    if (_venueId != venueId) {
        _venueId = venueId;
        
        _items = [[NSMutableArray alloc] init];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        
        [self loadItems];
        [self loadVenue];
    }
}

-(void)loadVenue
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                              _venueId, @"venue", nil];
    NSString* resourcePath = [@"/venue/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)loadItems {
    loadingNew = YES;
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                              _venueId, @"venue", 
                              [NSNumber numberWithInt:_currentPage], @"page",
                              [NSNumber numberWithInt:_pageSize], @"pagesize",
                              nil];
    NSString* resourcePath = [@"/venueitems/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded items: %@", objects);
    
    if ([[objects objectAtIndex:0] class] == [olgotVenue class]) {
        _venue = [objects objectAtIndex:0];
        [self.collectionView reloadData];
    }else {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    UIImage *addImage30 = [UIImage imageNamed:@"btn-nav-add-item"];
    
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.frame=CGRectMake(0,0,35,30);
    [addBtn setBackgroundImage:addImage30 forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(showAddItemView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.collectionView.scrollView delegate:self];
}

- (void)showAddItemView
{
    [self performSegueWithIdentifier:@"ShowAddItem" sender:self];
}

- (void)viewDidUnload
{
    [self setVenueLocationBtn:nil];
    [self setVenueMapButton:nil];
    [self setVenueAddressLabel:nil];
    [self setVenueIconImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pullToRefreshView = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 2;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return [_items count];
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myVenueItemTileIdentifier = @"VenueItemTileID";
    static NSString *myVenueCardIdentifier = @"VenueCardID";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell1 = [aCollectionView dequeueReusableItemWithIdentifier:myVenueCardIdentifier];
        
        if (cell1 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"VenueCard" owner:self options:nil];
            cell1 = _venueCardTile;
            self.venueCardTile = nil;
        }
        
        UILabel *venueLabel;
        venueLabel = (UILabel *)[cell1 viewWithTag:2];
        
        [venueLabel setText:[_venue name_En]];
        
//        cell1.layer.shadowOpacity = 0.5;
//        cell1.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell1.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        
        return cell1;
    }
    else {
        SSCollectionViewItem *cell2 = [aCollectionView dequeueReusableItemWithIdentifier:myVenueItemTileIdentifier];
        
        if (cell2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"VenueItemTile" owner:self options:nil];
            cell2 = _venueItemTile;
            self.venueItemTile = nil;
        }
        
        UIImageView *itemImage;
        UILabel *itemLabel;
        
        itemImage = (UIImageView *)[cell2 viewWithTag:1];
        [itemImage setImageWithURL:[NSURL URLWithString:[[_items objectAtIndex:indexPath.row] itemPhotoUrl]]];
        
        itemLabel = (UILabel *)[cell2 viewWithTag:2]; //description
        [itemLabel setText:[[_items objectAtIndex:indexPath.row] itemDescription]];
        
        itemLabel = (UILabel *)[cell2 viewWithTag:3]; //venue
        [itemLabel setText:[[_items objectAtIndex:indexPath.row] venueName_En]];
        
        itemLabel = (UILabel *)[cell2 viewWithTag:4]; //price
        [itemLabel setText:[NSString stringWithFormat:@"%d %@",
                            [[[_items objectAtIndex:indexPath.row] itemPrice] integerValue],
                            [[_items objectAtIndex:indexPath.row] countryCurrencyShortName]                  
                            ]];
        
//        cell2.layer.shadowOpacity = 0.5;
//        cell2.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell2.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        
        return cell2;
    }
    
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //	header.text = [NSString stringWithFormat:@"Section %i", section + 1];
	header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    if (section == 0) {
        return CGSizeMake(300.0f, 150.0f);
    }else{
        return CGSizeMake(145.0f, 184.0f);
    }
	
}

- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        _selectedRowIndexPath = indexPath;
        [self performSegueWithIdentifier:@"ShowItemView" sender:self];
    }
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 0.0f;
    }
	
}

-(void)collectionView:(SSCollectionView *)aCollectionView willDisplayItem:(SSCollectionViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I want more");
    if (indexPath.row == ([_items count] - 1) && loadingNew == NO && indexPath.section == 1) {
        _currentPage++;
        NSLog(@"loading page %d",_currentPage);
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


- (IBAction)showVenueMap:(id)sender {
    [self performSegueWithIdentifier:@"ShowVenueMap" sender:self];
}
@end
