//
//  olgotFeedbackViewController.m
//  Olgot
//
//  Created by Raed Hamam on 6/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotFeedbackViewController.h"
#import "DejalActivityView.h"

@interface olgotFeedbackViewController ()

@end

@implementation olgotFeedbackViewController
@synthesize feedbackTextView;
@synthesize scrollView;
@synthesize postFeedbackButton;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[RKObjectManager sharedManager] requestQueue] cancelRequestsWithDelegate:self];
}

-(void)dismissKeyboard {
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.feedbackTextView resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setFeedbackTextView:nil];
    [self setScrollView:nil];
    [self setPostFeedbackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"adding feedback");
    [self.scrollView setContentOffset:CGPointMake(0.0, 50.0) animated:YES];
}

-(void)sendFeedback{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending..."];
    NSString* feedbackText = self.feedbackTextView.text;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber* userID = [defaults objectForKey:@"userid"];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"id",
                            feedbackText, @"message",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [[[RKClient sharedClient] post:@"/feedback/" params:params delegate:self] setUserData:@"postFeedback"];
}

- (IBAction)postFeedbackButtonPressed:(id)sender {
    [self performSelector:@selector(dismissKeyboard)];
    [self.postFeedbackButton setEnabled:NO];
    [self performSelector:@selector(sendFeedback)];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"resource path: %@",[request resourcePath]);
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    [DejalBezelActivityView removeViewAnimated:YES];
    if ([request isPOST]) {  
        
        if ([response isJSON]) {
            
            if([response isOK]){
                if ([[request userData] isEqual:@"postFeedback"]) {
                    NSLog(@"posted feedback");
                    NSError *jsonError = nil;
                    
                    id _feedbackJsonResponse = [NSJSONSerialization JSONObjectWithData:[response body]
                                                                           options:0
                                                                             error:&jsonError];
                    
                    
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[_feedbackJsonResponse objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }else {
                
            }
        }  
        
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
}

- (void)requestDidStartLoad:(RKRequest *)request {

}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}

@end
