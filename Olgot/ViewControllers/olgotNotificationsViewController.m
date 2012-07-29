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
                              @"2", @"id",
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
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote actionUser] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ commented on your item at %@", 
                           [[mNote actionUser] username], [[mNote actionUser] itemVenueName]]];
        
        [cellDate setText:[mNote noteDate]];
        
        return commentCell;    
    }else if ([[mNote actionType] isEqualToNumber:[NSNumber numberWithInt:2]]) {
        UITableViewCell *commentCell = [mTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        UIImageView* cellImage = (UIImageView*)[commentCell viewWithTag:1];
        UILabel* cellText = (UILabel*)[commentCell viewWithTag:2];
        UILabel* cellDate = (UILabel*)[commentCell viewWithTag:3];
        
        [cellImage setImageWithURL:[NSURL URLWithString:[[mNote actionUser] profileImgUrl]]];
        
        [cellText setText:[NSString stringWithFormat:@"%@ also commented on an item at %@", 
                           [[mNote actionUser] username], [[mNote actionUser] itemVenueName]]];
        
        [cellDate setText:[mNote noteDate]];
        
        return commentCell;
    }else {
        UITableViewCell* dummyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dummyCell"];
        
        return dummyCell;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowItem"]) {
        olgotItemViewController *itemViewController = [segue destinationViewController];
        olgotNotification *mNote = [_notifications objectAtIndex:[tableView indexPathForSelectedRow].row];
        itemViewController.itemID = [[mNote actionUser] itemId];
        itemViewController.itemKey = [[mNote actionUser] itemKey];
        
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
