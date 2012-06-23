//
//  olgotChooseFriends.m
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotChooseFriends.h"
#import "UIImageView+AFNetworking.h"
#import "olgotMyFriend.h"
#import <QuartzCore/QuartzCore.h>

@implementation olgotChooseFriends

@synthesize headerCell = _headerCell, personCell = _personCell, footerCell = _footerCell;
@synthesize userID = _userID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUserID:(NSString *)userID
{
    if (_userID != userID) {
        _userID = userID;
        [self loadFriends];
    }
}

-(void)loadFriends{
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: _userID, @"user", nil];
    NSString* resourcePath = [@"/friends/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

-(void)followFriend:(UIButton*)sender
{
    SSCollectionViewItem* cell = (SSCollectionViewItem*)[sender superview];
    
//    [sender setHidden:YES];
    NSLog(@"follow %@ with id %@", [[_myFriends objectAtIndex:cell.tag] username], [[_myFriends objectAtIndex:cell.tag] userId]);
    
    [[_myFriends objectAtIndex:cell.tag] setIFollow:[NSNumber numberWithInt:1]];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _userID, @"id",
                            [[_myFriends objectAtIndex:cell.tag] userId], @"user",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [[RKClient sharedClient] post:@"/follower/" params:params delegate:self];
  
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload %@", [response bodyAsString]);
    
    if ([request isGET]) {   
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isPOST]) {  
        
        if ([response isJSON]) {
            id resp = [NSJSONSerialization JSONObjectWithData:[response body]
                                                      options:0
                                                        error:nil];
            if([response isOK]){
                NSLog(@"Got a JSON response back from our POST! %@", [response bodyAsString]);
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [self.collectionView reloadData];
            }else {
                
            }
        }  
        
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded actions: %@", objects);
    if([objectLoader.response isOK]){
        _myFriends = objects;
        [self.collectionView reloadData];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    
    UIImage *finishImage30 = [UIImage imageNamed:@"btn-nav-finish"];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    finishBtn.frame=CGRectMake(0,0,50,30);
    [finishBtn setBackgroundImage:finishImage30 forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishSignup) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)finishSignup
{
    [self dismissModalViewControllerAnimated:YES];
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

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 3;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if(section == 0){
        return 1;
    }else if (section == 2) {
        return 0;   //reset to 1 to show "invite more people"
    }else {
        return [_myFriends count];
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *myHeaderTileIdentifier = @"headerTileID";
    static NSString *myPersonTileIdentifier = @"personTileID";
    static NSString *myFooterTileIdentifier = @"footerTileID";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myHeaderTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsHeaderCell" owner:self options:nil];
            cell = _headerCell;
            self.headerCell = nil;
        }
        
        return cell;
    }else if (indexPath.section == 2) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myFooterTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsFooterCell" owner:self options:nil];
            cell = _footerCell;
            self.footerCell = nil;
        }
        
        return cell;
    }else{
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsPersonCell" owner:self options:nil];
            cell = _personCell;
            self.personCell = nil;
        }
        
        UIImageView* friendImage;
        UILabel* friendLabel;
        UIButton* followButton;
        
        friendImage = (UIImageView*)[cell viewWithTag:1];
        [friendImage setImageWithURL:[NSURL URLWithString:[[_myFriends objectAtIndex:indexPath.row
                                                            ] userProfileImgUrl]]];
        
        friendLabel = (UILabel*)[cell viewWithTag:2]; // Full Name
        friendLabel.text = [NSString stringWithFormat:@"%@ %@", 
                            [[_myFriends objectAtIndex:indexPath.row] firstName],
                            [[_myFriends objectAtIndex:indexPath.row] lastName]
                            ];
        
        friendLabel = (UILabel*)[cell viewWithTag:3]; // username
        friendLabel.text = [[_myFriends objectAtIndex:indexPath.row] username];
        
        followButton = (UIButton*)[cell viewWithTag:4]; //follow
        [followButton addTarget:self action:@selector(followFriend:) forControlEvents:UIControlEventTouchUpInside];
        
        if([[_myFriends objectAtIndex:indexPath.row] iFollow] == 0){
            [followButton addTarget:self action:@selector(followFriend:) forControlEvents:UIControlEventTouchUpInside];
            [followButton setImage:[UIImage imageNamed:@"btn-user-list-follow"] forState:UIControlStateNormal];
        }else {
            [followButton removeTarget:self action:@selector(followFriend:) forControlEvents:UIControlEventTouchUpInside];
            [followButton setImage:[UIImage imageNamed:@"btn-user-list-following"] forState:UIControlStateNormal];
        }
        
        [cell setTag:indexPath.row];
        return cell;
    }
	
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
    if(section == 0){
        return CGSizeMake(300.0f, 60.0f);
    }else if (section == 2) {
        return CGSizeMake(300.0f, 44.0f);
    }else {
       return CGSizeMake(300.0f, 44.0f);
    }
    
	
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}





@end
