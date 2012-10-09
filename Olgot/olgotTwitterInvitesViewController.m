//
//  olgotTwitterInvitesViewController.m
//  Olgot
//
//  Created by Raed Hamam on 9/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotTwitterInvitesViewController.h"
#import "olgotMyFriend.h"
#import "DejalActivityView.h"

@interface olgotTwitterInvitesViewController ()

@end

@implementation olgotTwitterInvitesViewController
@synthesize mCell;
@synthesize mTableView;
@synthesize delegate;
@synthesize userId = _userId;


-(void)setUserId:(NSNumber *)newUserId{
    if (_userId != newUserId) {
        _userId = newUserId;
        [self loadUsers];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mTableView setBackgroundColor:[UIColor clearColor]];
    if (!mPeople) {
        [self loadUsers];
    }
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setMCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadUsers
{
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys:
                              _userId, @"id",
                              @"twitter", @"network",
                              @"1",@"page",
                              @"1000",@"pagesize",
                              nil];
    NSString* resourcePath = [@"/networkfriends/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload %@", [response bodyAsString]);
    
    if ([request isGET]) {

        
    } else if ([request isPOST]) {
        
        
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded actions: %@", objects);
    if([objectLoader.response isOK]){
        mPeople = [[NSMutableArray alloc] initWithArray:objects];
        [self.mTableView reloadData];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    NSLog(@"Hit error: %@", error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mPeople count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"twitCell";
    olgotTwitterInviteCell *cell = (olgotTwitterInviteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        // Loads the xib into [self cell]
        [[NSBundle mainBundle] loadNibNamed:@"TwitterInviteCell"
                                      owner:self
                                    options:nil];
        // Assigns [self cell] to the local variable
        cell = [self mCell];
        // Clears [self cell] for future use/reuse
        [self setMCell:nil];
    }
    
    // Configure the cell...
    olgotMyFriend *mFriend = (olgotMyFriend*)[mPeople objectAtIndex:indexPath.row];
    
    [[cell userImage] setImageWithURL:[NSURL URLWithString:[mFriend userProfileImgUrl]]];
    
    [[cell userFullName] setText:[mFriend firstName]];
    
    [[cell userScreenName] setText:[mFriend username]];
    
    
    [[cell inviteUserBtn] addTarget:self action:@selector(inviteUser:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView *whiteCell = [[UIView alloc] initWithFrame:CGRectZero];
    [whiteCell setBackgroundColor:[UIColor whiteColor]];
    [cell setBackgroundView:whiteCell];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clearSpace = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 10.0)];
    [clearSpace setBackgroundColor:[UIColor clearColor]];
    [clearSpace setOpaque:NO];
    [clearSpace setAlpha:0.0];
    return clearSpace;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *clearSpace = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 10.0)];
    [clearSpace setBackgroundColor:[UIColor clearColor]];
    [clearSpace setOpaque:NO];
    [clearSpace setAlpha:0.0];
    return clearSpace;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -

- (IBAction)donePressed:(id)sender {
    [self.delegate finishedInvites];
}

-(void)inviteUser:(id)sender
{
    UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
    
    NSIndexPath *pathToCell = [self.mTableView indexPathForCell:owningCell];
    
    olgotMyFriend* mInvitee = (olgotMyFriend*)[mPeople objectAtIndex:pathToCell.row];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _userId, @"id",
                            @"twitter",@"network",
                            [mInvitee username],@"networkid",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [[RKClient sharedClient] post:@"/invite/" params:params delegate:nil];
    
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:[NSString stringWithFormat:@"@%@ I just sent you an invitation to join Olgot. Download it now: http://olgot.com", [mInvitee username]]];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentViewController:tweetViewController animated:YES completion:^{

    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

@end
