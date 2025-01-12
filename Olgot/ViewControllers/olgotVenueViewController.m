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
#import "olgotVenueMapViewController.h"
#import "olgotProfileViewController.h"


@interface olgotVenueViewController ()

@end

@implementation olgotVenueViewController

@synthesize venueCardTile = _venueCardTile, venueItemTile = _venueItemTile;

@synthesize venueId = _venueId;

@synthesize cameraOverlayViewController;

@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize venueLocationBtn = _venueLocationBtn;
@synthesize venueMapButton = _venueMapButton;
@synthesize venueAddressLabel = _venueAddressLabel;
@synthesize venueIconImageView = _venueIconImageView;
//@synthesize venueUserProfileImageView = _venueUserProfileImageView;
//@synthesize topUserImage = _topUserImage;
//@synthesize topUserName = _topUserName;
//@synthesize topUserItems = _topUserItems;
//@synthesize topUserLabel = _topUserLabel;

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
    NSLog(@"Loaded payload: %@ from resource path: %@", [response bodyAsString], [request resourcePath]);
    [self removeWaitLoader];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded items: %@", objects);
    
    if ([[objects objectAtIndex:0] isKindOfClass:[olgotVenue class]]) {
        _venue = [objects objectAtIndex:0];
        
//        if ([_venue topUserId] == NULL || [_venue topUserId] == 0) {
//            hasTopUser = NO;
//        }else {
//            hasTopUser = YES;
//        }
        
        
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
    [self takePicture:self];
}

- (IBAction)takePicture:(id)sender {
    
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

- (void)viewDidUnload
{
    [self setVenueLocationBtn:nil];
    [self setVenueMapButton:nil];
    [self setVenueAddressLabel:nil];
    [self setVenueIconImageView:nil];
//     [self setVenueUserProfileImageView:nil];
//    [self setTopUserImage:nil];
//    [self setTopUserName:nil];
//    [self setTopUserItems:nil];
//    [self setTopUserLabel:nil];
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
        
//        UILabel *venueLabel;
//        UIImageView *userImage;
//        UIButton *userBtn;
//        
//        venueLabel = (UILabel *)[cell1 viewWithTag:2];
//        [venueLabel setText:[_venue foursquareAddress]];
//        
//        venueLabel = (UILabel*)[cell1 viewWithTag:3];
//        [venueLabel setHidden:!hasTopUser];
//    
//        
//        userImage = (UIImageView*)[cell1 viewWithTag:4];
//        [userImage setImageWithURL:[NSURL URLWithString:[_venue topUserProfileImgUrl]]];
//        [userImage setHidden:!hasTopUser];
//        
//        userBtn = (UIButton*)[cell1 viewWithTag:5];
//        [userBtn setTitle:[NSString stringWithFormat:@"%@ %@",[_venue topUserFirstName],[_venue topUserLastName]] forState:UIControlStateNormal];
//        [userBtn setHidden:!hasTopUser];
//        
//        venueLabel = (UILabel*)[cell1 viewWithTag:6];
//        [venueLabel setText:[NSString stringWithFormat:@"Posted %@ items", [_venue topUserItems]]];
//        [venueLabel setHidden:!hasTopUser];

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
        UIImageView *userProfileImage;
        
        itemImage = (UIImageView *)[cell2 viewWithTag:1];
        [itemImage setImageWithURL:[NSURL URLWithString:[[_items objectAtIndex:indexPath.row] itemPhotoUrl]]];
        
        userProfileImage = (UIImageView *)[cell2 viewWithTag:2];
        [userProfileImage setHidden:NO];
        [userProfileImage setImageWithURL:[NSURL URLWithString:[[_items objectAtIndex:indexPath.row] userProfileImgUrl]]];
        
        
//        itemLabel = (UILabel *)[cell2 viewWithTag:2]; //description
//        [itemLabel setText:[[_items objectAtIndex:indexPath.row] itemDescription]];
//        
//        itemLabel = (UILabel *)[cell2 viewWithTag:3]; //venue
//        [itemLabel setText:[[_items objectAtIndex:indexPath.row] venueName_En]];
//        
//        itemLabel = (UILabel *)[cell2 viewWithTag:4]; //price
//        [itemLabel setText:[NSString stringWithFormat:@"%g %@",
//                            [[[_items objectAtIndex:indexPath.row] itemPrice] floatValue],
//                            [[_items objectAtIndex:indexPath.row] countryCurrencyShortName]                  
//                            ]];
        itemLabel = (UILabel *)[cell2 viewWithTag:7]; //itemName
        [itemLabel setText:[[_items objectAtIndex:indexPath.row] itemName]];

        
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
//        if(hasTopUser){
//            return CGSizeMake(300.0f, 150.0f);    
//        }else
        {
            return CGSizeMake(300.0f, 90.0f);
        }
        
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
        [self addWaitLoader];
        [self loadItems];
    }
}

-(void)addWaitLoader{
    UIActivityIndicatorView* pageLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [pageLoader setColor:[UIColor redColor]];
    [pageLoader setHidesWhenStopped:YES];
    [pageLoader startAnimating];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
    [pageLoader setCenter:[footerView center]];
    
    [footerView addSubview:pageLoader];
    
    [self.collectionView setCollectionFooterView:footerView];
}

-(void)removeWaitLoader{
    [self.collectionView setCollectionFooterView:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowItemView"]){
        olgotItemViewController *itemViewController = [segue destinationViewController];
        
        itemViewController.itemID = [[_items objectAtIndex:_selectedRowIndexPath.row] itemID];
        itemViewController.itemKey = [[_items objectAtIndex:_selectedRowIndexPath.row] itemKey];
    }else if ([[segue identifier] isEqual:@"ShowVenueMap"]) {
        olgotVenueMapViewController *mapViewController = [segue destinationViewController];
        
        mapViewController.venue = _venue;
    }else if ([[segue identifier] isEqual:@"ShowTopUserProfile"]) {
        olgotProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.userID = [_venue topUserId];
    }else if ([[segue identifier] isEqual:@"ShowItemDetails"]) {
        olgotAddItemDetailsViewController *itemDetailsController = [segue destinationViewController];
        
        itemDetailsController.venue = _venue;
        itemDetailsController.itemImage = image;
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

- (IBAction)userPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowTopUserProfile" sender:self];
}

-(void)showCamAnimated:(BOOL)animated source:(UIImagePickerControllerSourceType)sourceType
{
    self.cameraOverlayViewController = [[olgotCameraOverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
    self.cameraOverlayViewController.delegate = self;
    
    [self.cameraOverlayViewController setupImagePicker:sourceType];
    [self presentModalViewController:self.cameraOverlayViewController.imagePickerController animated:animated];
    
}



#pragma mark - olgotCameraOverlayControllerDelegate

-(void)tookPicture:(UIImage *)mImage
{
    UIImage* orImage = [mImage fixOrientation];
    
    
    
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:orImage];
	[cropper setDelegate:self];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:cropper animated:NO];
}

-(void)cancelled
{
    [self dismissModalViewControllerAnimated:NO];
    NSLog(@"cancelled");
}

-(void)wantsLibrary
{
    [self dismissModalViewControllerAnimated:NO];
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - addItemDetailsDelegate

-(void)wantsBack
{
    [self dismissModalViewControllerAnimated:NO];
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

-(void)exitAddItemFlow
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - olgotTrimEffectsDelegate

- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)editedImage
{
    olgotAddItemDetailsViewController *itemDetailsController = [[olgotAddItemDetailsViewController alloc] initWithNibName:@"addItemDetailsView" bundle:[NSBundle mainBundle]];
    
    //setup details controller
    itemDetailsController.venue = _venue;
    itemDetailsController.itemImage = editedImage;
    itemDetailsController.delegate = self;
    
    UINavigationController *camNavController = [[UINavigationController alloc] initWithRootViewController:itemDetailsController];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:camNavController animated:NO];
}

- (void)imageCropperDidCancel:(ImageCropper *)cropper {
	[self dismissModalViewControllerAnimated:NO];
	
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}


@end
