//
//  olgotHelpViewController.m
//  Olgot
//
//  Created by Raed Hamam on 7/29/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotHelpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface olgotHelpViewController ()

@end

@implementation olgotHelpViewController
@synthesize navigationBar;
@synthesize webView;
@synthesize activityView;

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
    
    self.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationBar.layer.masksToBounds = NO;
    
    [webView setDelegate:self];
    
    NSString *urlAddress = @"http://olgot.com/olgot/m/help";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivityView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIWebView Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityView stopAnimating];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityView startAnimating];
}

- (IBAction)donePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
