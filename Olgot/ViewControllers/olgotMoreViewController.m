//
//  olgotMoreViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotMoreViewController.h"

@interface olgotMoreViewController ()

@end

@implementation olgotMoreViewController
@synthesize savePhotosSwitch;
@synthesize autoTweetSwitch;
@synthesize facebookConnectSwitch;

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
    
    self.clearsSelectionOnViewWillAppear = YES;
    
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
    self.tableView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"autoSavePhotos"] isEqual:@"yes"]) {
        [self.savePhotosSwitch setOn:YES];
    }else {
        [self.savePhotosSwitch setOn:NO];
    }
    
    if ([[defaults objectForKey:@"autoTweetItems"] isEqual:@"yes"]) {
        [self.autoTweetSwitch setOn:YES];
    }else {
        [self.autoTweetSwitch setOn:NO];
    }
    
    //    check for facebook session
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        // Yes, so just open the session (this won't display any UX).
        [self.facebookConnectSwitch setOn:YES];
    }else{
        [self.facebookConnectSwitch setOn:NO];
    }
}

- (void)viewDidUnload
{
    [self setSavePhotosSwitch:nil];
    [self setAutoTweetSwitch:nil];
    [self setFacebookConnectSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 0) {
        NSLog(@"logout");
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:nil forKey:@"firstRun"];
        [defaults setObject:nil forKey:@"userid"];
        [defaults setObject:nil forKey:@"username"];
        [defaults setObject:nil forKey:@"email"];
        [defaults setObject:nil forKey:@"fullname"];
        [defaults setObject:nil forKey:@"twitterid"];
        [defaults setObject:nil forKey:@"twittername"];
        
        [defaults synchronize];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"You have been logged out."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
        
        [self.tabBarController setSelectedIndex:0];
//        [alert show];
    }
}

- (IBAction)changeSavePhotos:(id)sender {
    NSLog(@"user changing auto save photos");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UISwitch* photosSwitch = (UISwitch*)sender;
    if (photosSwitch.isOn) {
        NSLog(@"switched on");
        [defaults setObject:@"yes" forKey:@"autoSavePhotos"];
    }else {
        NSLog(@"switched off");
        [defaults setObject:@"no" forKey:@"autoSavePhotos"];
    }
    
    [defaults synchronize];
}

- (IBAction)changeAutoTweet:(id)sender {
    NSLog(@"user changing auto tweet items");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UISwitch* tweetSwitch = (UISwitch*)sender;
    if (tweetSwitch.isOn) {
        NSLog(@"switched on");
        [defaults setObject:@"yes" forKey:@"autoTweetItems"];
    }else {
        NSLog(@"switched off");
        [defaults setObject:@"no" forKey:@"autoTweetItems"];
    }
    
    [defaults synchronize];
}

- (IBAction)changeFacebookConnect:(id)sender {
    NSLog(@"changing facebook connect status");
    
    if (facebookConnectSwitch.isOn) {
//        user wants to connect with facebook
        olgotAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate openFBSession];
        
    } else {
//        user wants to disconnect facebook
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
}




@end
