//  olgotExploreViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotExploreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "olgotBoardViewController.h"
#import "olgotCategory.h"
#import "olgotItem.h"
#import "olgotTabBarViewController.h"
#import "olgotAppDelegate.h"


@interface olgotExploreViewController ()

@end

@implementation olgotExploreViewController

@synthesize boardBigTile = _boardBigTile, boardNormalTile = _boardNormalTile;

@synthesize pullToRefreshView = _pullToRefreshView;

@synthesize signupRootVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadCategories {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    loadingCategories = YES;
    [objectManager loadObjectsAtResourcePath:@"/categories" delegate:self];
}

- (void)startStandardUpdates
{
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the stored data before the view loads
    defaults = [NSUserDefaults standardUserDefaults];
//
//    if ([defaults objectForKey:@"userid"] == nil) {
//        [defaults setObject:nil forKey:@"firstRun"];
//    }
    
//    NSLog(@"session user id = %@", [defaults objectForKey:@"userid"]);
    
    // background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    //start location updates
    [self startStandardUpdates];
    
    //title logo
    UIImage *titleImage = [UIImage imageNamed:@"logo-70x55"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [titleImageView setImage:titleImage];
    titleImageView.contentMode = UIViewContentModeBottom;
    
    [self.navigationController.navigationBar.topItem setTitleView:titleImageView];
    
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.collectionView.scrollView delegate:self];
    
    //    friends list button
    UIImage *friendsImage30 = [UIImage imageNamed:@"btn-nav-friends"];
    
    UIButton *friendsBtn = [[UIButton alloc] init];
    friendsBtn.frame=CGRectMake(0,0,35,29);
    [friendsBtn setBackgroundImage:friendsImage30 forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(showFriendsList) forControlEvents:UIControlEventTouchUpInside];

    noteButton = [[UIButton alloc] initWithFrame:CGRectMake(195, 11, 32, 21)];
    [noteButton setBackgroundImage:[UIImage imageNamed:@"icon-notifications-off"] forState:UIControlStateNormal];
    [noteButton addTarget:self 
                   action:@selector(showNotifications)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *friendsBarBtn = [[UIBarButtonItem alloc] initWithCustomView:friendsBtn];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:friendsBarBtn, nil];
    
    [self.navigationController.navigationBar addSubview:noteButton];
    
    //    info button
    UIImage *infoImage30 = [UIImage imageNamed:@"icon-help"];
    
    UIButton *infoBtn = [[UIButton alloc] init];
    infoBtn.frame=CGRectMake(0,0,27,27);
    [infoBtn setBackgroundImage:infoImage30 forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:infoBtn];

    
//    [self.navigationItem.titleView insertSubview:noteButton atIndex:1];
    [self loadCategories];
}

-(void)showNotifications
{
    [self performSegueWithIdentifier:@"ShowNotifications" sender:self];
}

-(void)showFriendsList
{
    [self performSegueWithIdentifier:@"ShowFriendsList" sender:self];
}

-(void)showInfoView
{
    [self performSegueWithIdentifier:@"ShowInfoView" sender:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"User id: %@",[defaults objectForKey:@"userid"]);
    
    if([defaults objectForKey:@"firstRun"] == nil){
        olgotAppDelegate* appDelegate = (olgotAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate showSignup];
    }else if ([[defaults objectForKey:@"firstRun"] isEqual:@"yes"]) {
        [defaults setObject:@"no" forKey:@"firstRun"];
        [self loadCategories]; 
        [locationManager startUpdatingLocation];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [noteButton setHidden:NO];
    }];
    
    [self updateNotificationButton];
    [self checkNotifications];
    
    //reload categories if previous load was cancelled
    if (([_categories count] == 0) && !loadingCategories) {
        [self loadCategories];
    }
    
    //reload view if certain interval has passed
    NSDate *nowTime = [NSDate date];
    if ([nowTime compare:updateTime] == NSOrderedDescending) {
        [self loadCategories];
        [locationManager startUpdatingLocation];
        [self checkNotifications];
    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    olgotTabBarViewController* myTabBar = (olgotTabBarViewController*)self.tabBarController;
    [myTabBar addCenterButtonWithImage];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
    [self.pullToRefreshView finishLoading];
    
    [UIView animateWithDuration:0.5 animations:^{
        [noteButton setHidden:YES];
    }];
    
    loadingCategories = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pullToRefreshView = nil;
    self.boardBigTile = nil;
    self.boardNormalTile = nil;
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
    NSLog(@"Loaded categories: %@", objects);
    _categories = objects;
    loadingCategories = NO;
    updateTime = [NSDate dateWithTimeIntervalSinceNow:60];
    [self.pullToRefreshView finishLoading];
    [self.collectionView reloadData];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 3;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if (section == 0) {
        if ([defaults objectForKey:@"userid"] != nil) {
            return 1;
        } else {
            return 0;
        }

    }else if(section == 1) {
        if ([defaults objectForKey:@"userid"] != nil) {
            return 2;
        } else {
            return 0;
        }
    }else{
        return [_categories count];
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myNormalTileIdentifier = @"NormalBoardTile";
    static NSString *myBigTileIdentifier = @"BigBoardTile";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell1 = [aCollectionView dequeueReusableItemWithIdentifier:myBigTileIdentifier];
        
        if (cell1 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BoardBigTile" owner:self options:nil];
            cell1 = _boardBigTile;
            self.boardBigTile = nil;
        }
        
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        UILabel *tileSummaryLabel;
        
        tileImage = (UIImageView *)[cell1 viewWithTag:1];
        tileLabel = (UILabel *)[cell1 viewWithTag:2];
        tileSummaryLabel = (UILabel *)[cell1 viewWithTag:3];
        
        [tileImage setImageWithURL:[NSURL URLWithString:feedImage]];
        
        tileLabel.text = @"Following";
        [tileSummaryLabel setText:feedSummary];
        
        //tileSummaryLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-gradient.png"]];

        
        return cell1;
    }
    else if (indexPath.section == 1) {
        SSCollectionViewItem *cell2 = [aCollectionView dequeueReusableItemWithIdentifier:myNormalTileIdentifier];
        
        if (cell2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BoardNormalTile" owner:self options:nil];
            cell2 = _boardNormalTile;
            self.boardNormalTile = nil;
        }
        
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        
        tileImage = (UIImageView *)[cell2 viewWithTag:1];
        tileLabel = (UILabel *)[cell2 viewWithTag:2];
        
        if (indexPath.row == 0) {
            [tileImage setImageWithURL:[NSURL URLWithString:nearbyImage]];
            tileLabel.text = @"Nearby";
        }else if (indexPath.row == 1) {
            [tileImage setImageWithURL:[NSURL URLWithString:wantsImage]];
            tileLabel.text = @"My Wants";
        }
        
        return cell2;
    }
    else {
        SSCollectionViewItem *cell3 = [aCollectionView dequeueReusableItemWithIdentifier:myNormalTileIdentifier];
        
        if (cell3 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BoardNormalTile" owner:self options:nil];
            cell3 = _boardNormalTile;
            self.boardNormalTile = nil;
        }
        
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        
        tileImage = (UIImageView *)[cell3 viewWithTag:1];
        tileLabel = (UILabel *)[cell3 viewWithTag:2];
        
        [tileImage setImageWithURL:[NSURL URLWithString:[[[_categories objectAtIndex:indexPath.row] lastItem] itemPhotoUrl]]];
        tileLabel.text = [[_categories objectAtIndex:indexPath.row] name_En];
        
        return cell3;
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
        return CGSizeMake(300.0f, 130.0f);
    }else{
        return CGSizeMake(145.0f, 130.0f);
    }
	
}

- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedRowIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ShowBoardView" sender:self];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 0.0f;
    }
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowBoardView"]) {
        olgotBoardViewController *boardViewController = [segue destinationViewController];
        
        if (_selectedRowIndexPath.section == 0) {
            boardViewController.categoryID = 0;
            
            boardViewController.boardName = @"Following";
            
        }else if (_selectedRowIndexPath.section == 1) {
            if (_selectedRowIndexPath.row == 0) {
                boardViewController.categoryID = 0;
                boardViewController.boardName = @"Nearby";
            } else if(_selectedRowIndexPath.row == 1) {
                boardViewController.categoryID = 0;
                boardViewController.boardName = @"My Wants";  
            }
        }
        else {
            boardViewController.categoryID = [[_categories objectAtIndex:_selectedRowIndexPath.row] categoryID];
            
            boardViewController.boardName = [[_categories objectAtIndex:_selectedRowIndexPath.row] name_En];
        }
   
    }else if ([[segue identifier] isEqual:@"ShowFriendsList"]) {
        olgotFriendsViewController *friendsViewController = [segue destinationViewController];
        [friendsViewController setUserID:[defaults objectForKey:@"userid"]];
        [friendsViewController setDelegate:self];
    }else if ([[segue identifier] isEqual:@"ShowSignupFlow"]){
        UINavigationController* signupNavController = (UINavigationController*)[segue destinationViewController];
        self.signupRootVC = [[signupNavController viewControllers] objectAtIndex:0];
        
        UIGraphicsBeginImageContext(CGSizeMake(self.tabBarController.view.bounds.size.width, self.tabBarController.view.bounds.size.height));
        

        [self.tabBarController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.signupRootVC setHomeImage:myImage];

    }
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        
        [defaults setObject:[NSNumber numberWithFloat:newLocation.coordinate.latitude] forKey:@"lastestLatitude"];
        [defaults setObject:[NSNumber numberWithFloat:newLocation.coordinate.longitude] forKey:@"lastestLongitude"];
        
        [defaults synchronize];
    
        [self loadFixedCategories];
        [locationManager stopUpdatingLocation];
    }else{
        [self loadFixedCategories];
    }
    // else skip the event and process the next one.
}

-(void)loadFixedCategories
{
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [defaults objectForKey:@"userid"], @"id",
                            [NSNumber numberWithDouble:locationManager.location.coordinate.latitude],@"lat",
                            [NSNumber numberWithDouble:locationManager.location.coordinate.longitude],@"long",
                            nil];
    
    NSURL *url = [NSURL URLWithString:[@"http://www.olgot.com/olgot/index.php/api/fixedcategories/" stringByAppendingQueryParameters:params]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[[[JSON valueForKeyPath:@"feed"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] count] > 0) {
            feedImage = [[[[JSON valueForKeyPath:@"feed"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] objectAtIndex:0];
        }
        
        if ([[[[JSON valueForKeyPath:@"nearby"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] count] > 0) {
            nearbyImage = [[[[JSON valueForKeyPath:@"nearby"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] objectAtIndex:0];
        }
        
        if ([[[[JSON valueForKeyPath:@"wants"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] count] > 0) {
                wantsImage = [[[[JSON valueForKeyPath:@"wants"] valueForKeyPath:@"items"] valueForKeyPath:@"itemPhotoUrl"] objectAtIndex:0];
        }
        
        feedSummary = [[JSON valueForKeyPath:@"feed"] valueForKeyPath:@"summary"];
        
        [self.collectionView reloadData];
        
        
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON){
        NSLog(@"AFNetowkring failed from %@", [request URL]);
    }];
    
    [operation start];
}

-(void)checkNotifications
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [defaults objectForKey:@"userid"], @"id",
                            [defaults objectForKey:@"lastNotification"],@"notid",
                            nil];
    
    NSURL *url = [NSURL URLWithString:[@"http://www.olgot.com/olgot/index.php/api/checknotifications/" stringByAppendingQueryParameters:params]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        

        if ([[JSON valueForKeyPath:@"count"] isEqual:@"0"]) {
            [defaults setObject:@"no" forKey:@"hasNotifications"];           
        }else {
            [defaults setObject:@"yes" forKey:@"hasNotifications"];
        }
        
        [defaults synchronize];
        NSLog(@"check notifications from %@", [request URL]);
        [self updateNotificationButton];
        
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON){
        NSLog(@"AFNetowkring failed from %@", [request URL]);
    }];
    
    [operation start];
}

-(void)updateNotificationButton
{
    if ([[defaults objectForKey:@"hasNotifications"] isEqual:@"yes"]) {
        [noteButton setBackgroundImage:[UIImage imageNamed:@"icon-notifications-on"] forState:UIControlStateNormal];
    }else {
        [noteButton setBackgroundImage:[UIImage imageNamed:@"icon-notifications-off"] forState:UIControlStateNormal];
    }
}

#pragma mark SSPullToRefreshViewDelegate
-(void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view{
    [self refresh];
}

-(void)refresh{
    [self.pullToRefreshView startLoading];
    [self loadCategories];
    [self loadFixedCategories];
    [self checkNotifications];
}

#pragma mark friends view delegate

-(void)dismissFriendsView{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)showInviteTwitter{
    olgotTwitterInvitesViewController* twitterInviteController = [[olgotTwitterInvitesViewController alloc] initWithNibName:@"TwitterInvitesVC" bundle:nil];
    [twitterInviteController setDelegate:self];
    [twitterInviteController setUserId:[defaults objectForKey:@"userid"]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentModalViewController:twitterInviteController animated:YES];
    }];
    
}

-(void)showInviteFacebook{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark twitter invites delegate

-(void)finishedInvites{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

