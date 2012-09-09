//
//  olgotNotificationsViewController.m
//  Olgot
//
//  Created by Raed Hamam on 7/26/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotNotificationsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "olgotNotification.h"
#import "olgotNotificationUser.h"
#import "olgotItemViewController.h"
#import "olgotProfileViewController.h"

@interface olgotNotificationsViewController ()

@end

@implementation olgotNotificationsViewController
@synthesize activityView;
@synthesize tableView;
@synthesize doneBtn;
@synthesize pullToRefreshView = _pullToRefreshView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footerView];
    
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    
    [self loadNotifications];
}

- (void)viewDidUnload
{
    self.pullToRefreshView = nil;
    [self setTableView:nil];
    [self setDoneBtn:nil];
    [self setActivityView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneBtnPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loadNotifications
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: 
                              [defaults objectForKey:@"userid"], @"id",
                              nil];
    NSString* resourcePath = @"/notifications/";
    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
    
}

#pragma mark RKObjectLoaderDelegate methods

-(void)requestDidStartLoad:(RKRequest *)request
{
    [activityView startAnimating];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
   [activityView stopAnimating];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded notifications: %@", objects);
    
    _notifications = objects;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[[_notifications objectAtIndex:0] noteID] forKey:@"lastNotification"];
    [defaults setObject:@"no" forKey:@"hasNotifications"];
    
    [defaults synchronize];
    
    [self.pullToRefreshView finishLoading];
    [self.tableView reloadData];
    
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
    return [_notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellIdentifier = @"noteCommentCell";
    static NSString *userCellIdentifier = @"noteUserCell";
    
    olgotNotification* mNote = [_notifications objectAtIndex:indexPath.row];
    
    if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ commented on your item at %@", 
                           [[mNote noteData] username], [[mNote noteData] itemVenueName]]];
        
        [cellDate setText:[mNote noteDate]];
        
        cellImage = (UIImageView*)[commentCell viewWithTag:4];
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] itemImgUrl]]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[commentCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[commentCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return commentCell;    
    }else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:2]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ also commented on an item at %@", 
                           [[mNote noteData] username], [[mNote noteData] itemVenueName]]];
        
        [cellDate setText:[mNote noteDate]];
        
        cellImage = (UIImageView*)[commentCell viewWithTag:4];
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] itemImgUrl]]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[commentCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[commentCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return commentCell;
    }else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:3]]) {
        UITableViewCell *userCell = [mTableView dequeueReusableCellWithIdentifier:userCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[userCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[userCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[userCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ started following you on Olgot!", 
                           [[mNote noteData] username]]];
        
        [cellDate setText:[mNote noteDate]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[userCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[userCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return userCell;
    }
    else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:4]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ likes your item", 
                           [[mNote noteData] username]]];
        
        [cellDate setText:[mNote noteDate]];
        
        cellImage = (UIImageView*)[commentCell viewWithTag:4];
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] itemImgUrl]]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[commentCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[commentCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return commentCell;
    }
    else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:5]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ wants your item",
                           [[mNote noteData] username]]];
        
        [cellDate setText:[mNote noteDate]];
        
        cellImage = (UIImageView*)[commentCell viewWithTag:4];
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] itemImgUrl]]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[commentCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[commentCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return commentCell;
    }
    else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:6]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ got your item",
                           [[mNote noteData] username]]];
        
        [cellDate setText:[mNote noteDate]];
        
        cellImage = (UIImageView*)[commentCell viewWithTag:4];
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] itemImgUrl]]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[commentCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[commentCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return commentCell;
    }
    else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:7]]) {
        UITableViewCell *userCell = [mTableView dequeueReusableCellWithIdentifier:userCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[userCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[userCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[userCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote noteData] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"Your friend %@ just joined Olgot as %@" 
                           ,[[mNote noteData] firstName],[[mNote noteData] username]]];
        
        [cellDate setText:[mNote noteDate]];
        
        if ([[mNote noteStatus] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [[userCell contentView] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        } else {
            [[userCell contentView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        return userCell;
    }
    else {
        UITableViewCell* dummyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dummyCell"];
        
        return dummyCell;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    olgotNotification *mNote = [_notifications objectAtIndex:[tableView indexPathForSelectedRow].row];
    //change viewed state to 1 and notify server
    [mNote setNoteStatus:[NSNumber numberWithInt:1]];
    
    [tableView reloadData];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [defaults objectForKey:@"userid"], @"id",
                            [mNote noteID],@"notid",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [[RKClient sharedClient] post:@"/viewnotification/" params:params delegate:nil];
    
    // prepare segues
    if ([[segue identifier] isEqual:@"ShowItem"]) {
        olgotItemViewController *itemViewController = [segue destinationViewController];
        
        itemViewController.itemID = [[mNote noteData] itemId];
        itemViewController.itemKey = [[mNote noteData] itemKey];
    }else if ([[segue identifier] isEqual:@"ShowUserProfile"]) {
        olgotProfileViewController *profileViewController = [segue destinationViewController];
        
        profileViewController.userID = [[mNote noteData] userId];
    }
}

#pragma mark SSPullToRefreshViewDelegate
-(void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view{
    [self refresh];
}

-(void)refresh{
    [self.pullToRefreshView startLoading];
    
    [self loadNotifications];
    
}

@end
