//
//  olgotCommentsListViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/24/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCommentsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "olgotComment.h"

@interface olgotCommentsListViewController ()

@end

@implementation olgotCommentsListViewController

@synthesize commentCell = _commentCell, commentsListHeader = _commentsListHeader;

@synthesize itemID = _itemID, commentsNumber = _commentsNumber;

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
        [self loadComments];
    }
}

- (void)loadComments {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];

    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: _itemID, @"item", nil];
    NSString* resourcePath = @"/comments/";
    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
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
    NSLog(@"Loaded comments: %@", objects);
    _comments = objects;
    [self.collectionView reloadData];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
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
        return [_comments count];
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myPersonListHeaderIdentifier = @"commentListHeader";
    static NSString *myPersonTileIdentifier = @"commentTileID";  
    
    if(indexPath.section == 0){
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonListHeaderIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"commentsListHeaderCell" owner:self options:nil];
            cell = _commentsListHeader;
            self.commentsListHeader = nil;
        }
        
        UILabel* commentsHeader;
        
        commentsHeader = (UILabel*)[cell viewWithTag:1];
        [commentsHeader setText:[NSString stringWithFormat:@"%d comments", [_commentsNumber intValue]]];
        
        return cell;
    }
    else{
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"commentsViewCommentRow" owner:self options:nil];
            cell = _commentCell;
            self.commentCell = nil;
        }
        
        UIImageView* commentImage;
        UILabel* commentLabel;
        
        commentImage = (UIImageView*)[cell viewWithTag:1];
        [commentImage setImageWithURL:[NSURL URLWithString:[[_comments objectAtIndex:indexPath.row] userProfileImgUrl]]];
        
        commentLabel = (UILabel*)[cell viewWithTag:2]; //user name
        [commentLabel setText:[NSString stringWithFormat:@"%@ %@",[[_comments objectAtIndex:indexPath.row] userFirstName],[[_comments objectAtIndex:indexPath.row] userLastName]]];
        
        commentLabel = (UILabel*)[cell viewWithTag:3]; //comment time
        [commentLabel setText:[[_comments objectAtIndex:indexPath.row] date]];
        
        commentLabel = (UILabel*)[cell viewWithTag:4]; //comment text
        [commentLabel setText:[[_comments objectAtIndex:indexPath.row] body]];
        
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
    
    if (section == 0) {
        return CGSizeMake(300.0f, 44.0f);
            } else {
                return CGSizeMake(300.0f, 86.0f);
                    }
    
    
    
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        //        [self performSegueWithIdentifier:@"showProfile" sender:self];
    }
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}




@end
