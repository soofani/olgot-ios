//
//  olgotItemViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotItemViewController.h"
#import "olgotItem.h"

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
        [self loadItemData];
    }
}

-(void)loadItemData
{
    
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
    NSLog(@"Loaded items: %@", objects);
    if([objectLoader.response isOK]){
        [self.collectionView reloadData];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 6;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if(section == 0){
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 3;
    }
    else if (section == 3) {
        return 1;
    }
    else if (section == 4){
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
        
        return cell;
    }
    else if (indexPath.section == 1) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myFinderTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewFinderTile" owner:self options:nil];
            cell = _finderCell;
            self.finderCell = nil;
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPeopleTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"itemViewPeopleRow" owner:self options:nil];
            cell = _peopleRowCell;
            self.peopleRowCell = nil;
        }
        
        return cell;
    }
    else if (indexPath.section == 3) {

        [[NSBundle mainBundle] loadNibNamed:@"itemViewCommentsHeader" owner:self options:nil];
        
        return commentsHeader;
    }
    else if (indexPath.section == 4) {
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
    
    if (section == 3) {
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
        return CGSizeMake(300.0f, 30.0f);
    }
    else if (section == 4){
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
    else if (indexPath.section == 5) {
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
@end
