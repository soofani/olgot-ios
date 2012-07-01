//
//  olgotPeopleListViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotPeopleListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "olgotActionUser.h"
#import "olgotProfileViewController.h"

@interface olgotPeopleListViewController ()

@end

@implementation olgotPeopleListViewController

@synthesize personListHeader = _personListHeader ,personCell = _personCell;

@synthesize itemID = _itemID, actionName = _actionName, actionStats = _actionStats;

@synthesize userID = _userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setItemID:(NSNumber *)itemID
{
    if (_itemID != itemID) {
        _itemID = itemID;
        
        _userActions = [[NSMutableArray alloc] init];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        
        self.navigationItem.title = _actionName;
        [self loadActions];
    }
}

-(void)setUserID:(NSNumber *)userID
{
    if (_userID != userID) {
        _userID = userID;
        
        _userActions = [[NSMutableArray alloc] init];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        
        self.navigationItem.title = _actionName;
        [self loadActions];
    }
}

- (void)loadActions {
    loadingNew = YES;
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    if(_actionName == @"Likes"){
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _itemID, @"item", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/itemlikes/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else if (_actionName == @"Wants") {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _itemID, @"item", 
                                  @"0" , @"long", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/itemwants/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else if (_actionName == @"Gots") {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _itemID, @"item", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/itemgots/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }else if (_actionName == @"Followers") {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _userID, @"user", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/followers/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
        
    }
    else if (_actionName == @"Following") {
        NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  _userID, @"user", 
                                  [NSNumber numberWithInt:_currentPage], @"page",
                                  [NSNumber numberWithInt:_pageSize], @"pagesize",
                                  nil];
        NSString* resourcePath = [@"/followers/" appendQueryParams:myParams];
        [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
    }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded actions: %@", objects);
    if([objectLoader.response isOK]){
        loadingNew = NO;
        [_userActions addObjectsFromArray:objects];
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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 0.0f;
    
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
           
}

- (void)viewDidUnload
{
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

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 2;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if (section == 0) {
        return 1;
    } 
    else 
    {
        return [_userActions count];
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myPersonListHeaderIdentifier = @"personListHeader";
    static NSString *myPersonTileIdentifier = @"personTileID";  
    
    if(indexPath.section == 0){
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonListHeaderIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"peopleListHeaderCell" owner:self options:nil];
            cell = _personListHeader;
            self.personListHeader = nil;
        }
        
        UILabel* headerLabel;
        headerLabel = (UILabel*)[cell viewWithTag:1];
        if ([_actionName isEqualToString:@"Likes"] || [_actionName isEqualToString:@"Wants"] || [_actionName isEqualToString:@"Gots"]) {
            
            [headerLabel setText:[NSString stringWithFormat:@"%d people %@ this", [_actionStats intValue] ,_actionName]];;
        }else if ([_actionName isEqualToString:@"Followers"]) {
            [headerLabel setText:[NSString stringWithFormat:@"%d followers", [_actionStats intValue]]];;
        }else if ([_actionName isEqualToString:@"Following"]) {
            [headerLabel setText:[NSString stringWithFormat:@"Following %d people", [_actionStats intValue]]];;
        }
         
        
        return cell;
    }
    else{
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"peopleListPersonCell" owner:self options:nil];
            cell = _personCell;
            self.personCell = nil;
        }
        
        UIImageView* actionImage;
        UILabel* actionLabel;
        
        actionImage = (UIImageView*)[cell viewWithTag:1];
        [actionImage setImageWithURL:[NSURL URLWithString:[[_userActions objectAtIndex:indexPath.row] userProfileImgUrl]]];
        
        actionLabel = (UILabel*)[cell viewWithTag:2]; //user full name
        [actionLabel setText:[NSString stringWithFormat:@"%@ %@",[[_userActions objectAtIndex:indexPath.row] userFirstName],[[_userActions objectAtIndex:indexPath.row] userLastName]]];
        
        actionLabel = (UILabel*)[cell viewWithTag:3]; //username
        [actionLabel setText:[[_userActions objectAtIndex:indexPath.row] userName]];
        
        return cell;
    }
    
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
    
    return CGSizeMake(300.0f, 44.0f);

}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        _selectedRowIndexPath = indexPath;
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    }
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}

-(void)collectionView:(SSCollectionView *)aCollectionView willDisplayItem:(SSCollectionViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I want more");
    if (indexPath.row == ([_userActions count] - 1) && loadingNew == NO && indexPath.section == 1 && ([_userActions count] > 8)) {
        _currentPage++;
        NSLog(@"loading page %d",_currentPage);
        [self loadActions];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"showProfile"]){
        olgotProfileViewController *profileViewController = [segue destinationViewController];
        
        profileViewController.userID = [[_userActions objectAtIndex:_selectedRowIndexPath.row] userId];
    }
}

@end
