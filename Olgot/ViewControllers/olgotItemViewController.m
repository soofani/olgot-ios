//
//  olgotItemViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotItemViewController.h"
#import "UIImageView+AFNetworking.h"
#import "olgotCommentsListViewController.h"
#import "olgotPeopleListViewController.h"
#import "olgotItem.h"
#import "olgotActionUser.h"
#import "olgotComment.h"


@interface olgotItemViewController ()

@end

@implementation olgotItemViewController

@synthesize itemCell = _itemCell, finderCell = _finderCell, peopleRowCell = _peopleRowCell,  commentsHeader, commentCell = _commentCell, commentsFooter = _commentsFooter;

@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setItem:(olgotItem *)item
{
    if(_item != item){
        _item = item;
        self.navigationItem.title = [_item itemDescription];
        NSLog(@"item ID = %d", [[_item itemID] intValue]);
        [self loadItemData];
    }
}

-(void)loadItemData
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: [_item itemID], @"item", nil];
    
    
    
    //likes
    NSString* resourcePath = @"/itemlikes/";
//    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
    RKObjectLoader* likesLoader = [objectManager loaderWithResourcePath:[resourcePath stringByAppendingQueryParameters:myParams]];
    likesLoader.userData = @"likes shit";
    [likesLoader send];
//    [objectManager configureObjectLoader:likesLoader];
    

    
    //wants
    resourcePath = @"/itemwants/";
//    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
    
    //gots
    resourcePath = @"/itemgots/";
//    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
    
    //comments
    resourcePath = @"/comments/";
//    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//    if([objectLoader.userData isEqual:@"likes"]){
//        NSLog(@"got likes");
//    }else if ([objectLoader.userData isEqual:@"wants"]) {
//        NSLog(@"got wants");
//    }else {
//        NSLog(@"got something else");
//    }
    NSLog(@"user data: %@", objectLoader.userData);
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 8;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if(section == 0){
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 1;
    }
    else if (section == 3) {
        return 1;
    }
    else if (section == 4) {
        return 1;
    }
    else if (section == 5) {
        return 1;
    }
    else if (section == 6){
        return 2;
    }
    else {
        return 1;
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *myItemTileIdentifier = @"itemViewHeaderID";
    static NSString *myFinderTileIdentifier = @"itemViewFinderID";
    static NSString *myPeopleTileIdentifier = @"itemViewPeopleRowID";
    static NSString *myCommentTileIdentifier = @"itemViewCommentRowID";
    static NSString *myCommentsFooterIdentifier = @"commentsFooter";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myItemTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewHeaderTile" owner:self options:nil];
            cell = _itemCell;
            self.itemCell = nil;
        }
        
        UIImageView* itemImage;
        UILabel* itemDescription;
        
        itemImage = (UIImageView*)[cell viewWithTag:1];
        itemDescription = (UILabel*)[cell viewWithTag:2];
        
        [itemImage setImageWithURL:[NSURL URLWithString:[_item itemPhotoUrl]]];
        [itemDescription setText:[_item itemDescription]];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myFinderTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewFinderTile" owner:self options:nil];
            cell = _finderCell;
            self.finderCell = nil;
        }
        
        UIImageView* finderImage;
        UILabel* finderLabel;
        UIButton* finderButton;
        
        finderImage = (UIImageView*)[cell viewWithTag:1];
        [finderImage setImageWithURL:[NSURL URLWithString:[_item userProfileImgUrl]]];
        
        finderLabel = (UILabel*)[cell viewWithTag:2]; //finder name
        [finderLabel setText:[NSString stringWithFormat:@"%@ %@",[_item userFirstName],[_item userLastName] ]];
        
        finderButton = (UIButton*)[cell viewWithTag:3]; //venue name
        [finderButton setTitle:[_item venueName_En] forState:UIControlStateNormal];
        
        finderLabel = (UILabel*)[cell viewWithTag:4]; //price
        [finderLabel setText:[NSString stringWithFormat:@"%@ %d",[_item countryCurrencyShortName],[[_item itemPrice] intValue]]];
        
        return cell;
    }
    else if (indexPath.section == 2) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPeopleTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewPeopleRow" owner:self options:nil];
            cell = _peopleRowCell;
            self.peopleRowCell = nil;
        }
        
        UILabel* peopleLabel;
        
        peopleLabel = (UILabel*)[cell viewWithTag:1];
        [peopleLabel setText:@"Like it"];
        
        return cell;
    }
    else if (indexPath.section == 3) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPeopleTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewPeopleRow" owner:self options:nil];
            cell = _peopleRowCell;
            self.peopleRowCell = nil;
        }
        
        UILabel* peopleLabel;
        
        peopleLabel = (UILabel*)[cell viewWithTag:1];
        [peopleLabel setText:@"Want it"];
        
        return cell;
    }
    else if (indexPath.section == 4) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPeopleTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewPeopleRow" owner:self options:nil];
            cell = _peopleRowCell;
            self.peopleRowCell = nil;
        }
        
        UILabel* peopleLabel;
        
        peopleLabel = (UILabel*)[cell viewWithTag:1];
        [peopleLabel setText:@"Got it"];
        
        return cell;
    }
    else if (indexPath.section == 5) {

        [[NSBundle mainBundle] loadNibNamed:@"itemViewCommentsHeader" owner:self options:nil];
        
        return commentsHeader;
    }
    else if (indexPath.section == 6) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myCommentTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewCommentRow" owner:self options:nil];
            cell = _commentCell;
            self.commentCell = nil;
        }
        
        return cell;
 
    }
    else {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myCommentsFooterIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewCommentsFooter" owner:self options:nil];
            cell = _commentsFooter;
            self.commentsFooter = nil;
        }
        
        UILabel* footerLabel;
        
        footerLabel = (UILabel*)[cell viewWithTag:1];
        [footerLabel setText:[NSString stringWithFormat:@"See all (%d) comments",[[_item itemStatsComments] intValue]]];
        
        return cell;
    }
	
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
    
    SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
	header.autoresizingMask = UIViewAutoresizingNone;
    header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 0.0f);
	header.backgroundColor = [UIColor whiteColor];
    
    if (section == 5) {
        header.text = @"Comments";
    }
	
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    if(section == 0){
        return CGSizeMake(300.0f, 370.0f);
    }
    else if (section == 1) {
        return CGSizeMake(300.0f, 44.0f);
    }
    else if (section == 2) {
        return CGSizeMake(300.0f, 85.0f);
    }
    else if (section == 3) {
        return CGSizeMake(300.0f, 85.0f);
    }
    else if (section == 4) {
        return CGSizeMake(300.0f, 85.0f);
    }
    else if (section == 5) {
        return CGSizeMake(300.0f, 30.0f);
    }
    else if (section == 6){
        return CGSizeMake(300.0f, 86.0f);
    }
    else {
        return CGSizeMake(300.0f, 44.0f);
    }
    
	
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"showLikes" sender:self];
    }
    else if (indexPath.section == 3) {
        [self performSegueWithIdentifier:@"showWants" sender:self];
    }
    else if (indexPath.section == 4) {
        [self performSegueWithIdentifier:@"showGots" sender:self];
    }
    else if (indexPath.section == 7) {
        [self performSegueWithIdentifier:@"showAllComments" sender:self];
    }
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    
    if (section == 3) {
        return 0.0f;
    }
    else{
        return 0.0f;
    }
	
}


- (IBAction)showVenue:(id)sender {
    [self performSegueWithIdentifier:@"showVenue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAllComments"]) {
        olgotCommentsListViewController *commentsViewController = [segue destinationViewController];
        
        commentsViewController.commentsNumber = [_item itemStatsComments];
        commentsViewController.itemID = [_item itemID];        
        
    }else if ([[segue identifier] isEqualToString:@"showLikes"]) {
        olgotPeopleListViewController *peopleViewController = [segue destinationViewController];
        
        peopleViewController.actionStats = [_item itemStatsLikes];
        peopleViewController.actionName = @"Likes";
        peopleViewController.itemID = [_item itemID];
    }
    else if ([[segue identifier] isEqualToString:@"showWants"]) {
       olgotPeopleListViewController *peopleViewController = [segue destinationViewController];
        
        peopleViewController.actionStats = [_item itemStatsWants];
        peopleViewController.actionName = @"Wants";
        peopleViewController.itemID = [_item itemID];
        
    }
    else if ([[segue identifier] isEqualToString:@"showGots"]) {
        olgotPeopleListViewController *peopleViewController = [segue destinationViewController];
        
        peopleViewController.actionStats = [_item itemStatsGots];
        peopleViewController.actionName = @"Gots";
        peopleViewController.itemID = [_item itemID];
    }
}


@end
