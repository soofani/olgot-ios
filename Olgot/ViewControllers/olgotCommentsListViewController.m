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
#import "olgotProfileViewController.h"

@interface olgotCommentsListViewController ()

@end

@implementation olgotCommentsListViewController

@synthesize commentCell = _commentCell, commentsListHeader = _commentsListHeader;

@synthesize itemID = _itemID, commentsNumber = _commentsNumber;

@synthesize mySmallImage = _mySmallImage;
@synthesize myCommentTF = _myCommentTF;

@synthesize pullToRefreshView = _pullToRefreshView;

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
        
        _comments = [[NSMutableArray alloc] init];
        _currentPage = 1;
        _pageSize = 10;
        loadingNew = NO;
        
        [self loadComments];
    }
}

- (void)loadComments {
    loadingNew = YES;
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];

    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                              _itemID, @"item", 
                              [NSNumber numberWithInt:_currentPage], @"page",
                              [NSNumber numberWithInt:_pageSize], @"pagesize",
                              nil];
    NSString* resourcePath = @"/comments/";
    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
}

-(void)dismissKeyboard {
    [self.myCommentTF resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    myCommentView.frame = CGRectMake(0, 378, 320, 40);
    [UIView commitAnimations];
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
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.collectionView.scrollView delegate:self];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    myCommentView = [[[NSBundle mainBundle] loadNibNamed:@"commentsViewWriteCommentView" owner:self options:nil] objectAtIndex:0];
    
    myCommentView.frame = CGRectMake(0, 378, 320, 40);
    
    [self.mySmallImage setImageWithURL:[NSURL URLWithString:[defaults objectForKey:@"userProfileImageUrl"]]];
    [self.view addSubview:myCommentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    addedComment = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pullToRefreshView = nil;
    [self setMySmallImage:nil];
    [self setMyCommentTF:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowUserProfile"]) {
        olgotProfileViewController *profileViewController = [segue destinationViewController];
        [profileViewController setUserID:[[_comments objectAtIndex:_selectedRowIndexPath.row] userId]];
    }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    if ([request isPOST]) {  
        
        if ([response isJSON]) {
            
            if([response isOK]){
                if ([[request resourcePath] isEqual:@"/comment/"]) {
                    addedComment = YES;
                    [self loadComments];
                }
                NSLog(@"Got a JSON response back from our POST! %@", [response bodyAsString]);
                
                [self.collectionView reloadData];
            }else {
                
            }
        }  
        
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded comments: %@", objects);
    loadingNew = NO;
    
    if (self.pullToRefreshView.isExpanded || addedComment == YES) {
        addedComment = NO;
        _comments = [[NSMutableArray alloc] initWithArray:objects];
    } else {
        [_comments addObjectsFromArray:objects];    
    }
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
        [commentLabel setText:[[_comments objectAtIndex:indexPath.row] commentDate]];
        
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
        _selectedRowIndexPath = indexPath;
        [self performSegueWithIdentifier:@"ShowUserProfile" sender:self];
    }
    
}

-(void)collectionView:(SSCollectionView *)aCollectionView willDisplayItem:(SSCollectionViewItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I want more");
    if (indexPath.row == ([_comments count] - 1) && loadingNew == NO && indexPath.section == 1 && ([_comments count] > 3)) {
        _currentPage++;
        NSLog(@"loading page %d",_currentPage);
        [self loadComments];
    }
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
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
    
    [self loadComments];
    
}

- (IBAction)touchedWriteComment:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //    [UIView setAnimationDelay:0.1];
    myCommentView.frame = CGRectMake(0, 160, 320, 40);
    [UIView commitAnimations];
}

- (IBAction)finishedComment:(id)sender {
    [self performSelector:@selector(dismissKeyboard)];
    NSLog(@"user finished commenting: %@", self.myCommentTF.text);
    
    NSString* commentBody = self.myCommentTF.text;
    NSString *trimmedBody = [commentBody stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![trimmedBody isEqualToString:@""]) {
        NSLog(@"sending comment");
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                _itemID, @"item",
                                [defaults objectForKey:@"userid"], @"id",
                                commentBody, @"body",
                                nil];
        
        [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [[RKClient sharedClient] post:@"/comment/" params:params delegate:self];
    }else {
        NSLog(@"empty comment, not sending");
    }
    
    self.myCommentTF.text = nil;
    
}

@end
