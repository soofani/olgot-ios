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

@end
