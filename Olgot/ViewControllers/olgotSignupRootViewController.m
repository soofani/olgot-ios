//
//  olgotSignupRootViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotSignupRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "olgotChooseUsernameViewController.h"


@interface olgotSignupRootViewController ()

@end

@implementation olgotSignupRootViewController
@synthesize activityIndicator;
@synthesize twitterSigninButton,accountsPicker;


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
       
    //title logo
//    UIImage *titleImage = [UIImage imageNamed:@"logo-140x74"];
//    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
//    [self.navigationController.navigationBar.topItem setTitleView:titleImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidUnload
{
    [self setTwitterSigninButton:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-(void)hideAccountPicker{
//    [self.twitterSigninButton setEnabled:YES];
//    [UIView animateWithDuration:0.5 animations:^{
//        accountsPicker.frame = CGRectMake(0, 460, 320, 216);
//    }completion:^(BOOL finished){
//        [accountsPicker removeFromSuperview];    
//    }];
//    
//}

- (IBAction)hideSignup:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"firstRun"];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)twitterSignin:(id)sender {
    [self.twitterSigninButton setEnabled:NO];
    [self.activityIndicator startAnimating];
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Remember that twitterType was instantiated above
            twitterAccounts = [store accountsWithAccountType:twitterType];
            
            // If there are no accounts, we need to pop up an alert
            if(twitterAccounts != nil && [twitterAccounts count] > 0) {
                // Get the list of Twitter accounts.
                
                NSLog(@"accounts: %@",twitterAccounts);
                
                
//                accountsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 460, 320, 216)];
//                
//                accountsPicker.delegate = self;
//                accountsPicker.dataSource = self;
//                
//                accountsPicker.showsSelectionIndicator = YES;
//                [accountsPicker selectRow:-1 inComponent:0 animated:NO];
                
//                [self.view addSubview:accountsPicker];
                
                [self.activityIndicator stopAnimating];
                
                UIActionSheet* twitterActionSheet;
                NSMutableArray* actionSheetButtons = [[NSMutableArray alloc] init];
                for (ACAccount* ac in twitterAccounts) {
                    [actionSheetButtons addObject:[ac accountDescription]];
                }
                
                NSLog(@"buttons: %@",actionSheetButtons);
                
                if ([actionSheetButtons count] == 1) {
                    twitterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[actionSheetButtons objectAtIndex:0], nil];
                } else {
                     twitterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[actionSheetButtons componentsJoinedByString:@","], nil];       
                }
                
                
                [twitterActionSheet showInView:self.view];
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//                accountsPicker.frame = CGRectMake(0, 244, 320, 216);
//                [UIView commitAnimations];
            } 
            
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                                message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        // Handle any error state here as you wish
    }];
}

-(void)checkTwitterName:(NSString *)text
{
    //TEMP: add check available method;
    _twitterName = text;
    [self performSegueWithIdentifier:@"ShowChooseUsername" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqual:@"ShowChooseUsername"]){
        olgotChooseUsernameViewController* chooseUsernameVC = [segue destinationViewController];
        chooseUsernameVC.twitterResponseData = _twitterResponse;
    }
}


- (void)canTweetStatus {
    if ([TWTweetComposeViewController canSendTweet]) {
        self.twitterSigninButton.enabled = YES;
        self.twitterSigninButton.alpha = 1.0f;
    } else {
        self.twitterSigninButton.enabled = NO;
        self.twitterSigninButton.alpha = 0.3f;
    }
}

- (void) chooseTwitterAccount:(int)accountNumber
{
    [self.activityIndicator startAnimating];
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            [self.activityIndicator stopAnimating];
            twitterAccounts = [store accountsWithAccountType:twitterType];
            ACAccount *account = [twitterAccounts objectAtIndex:accountNumber];
            // Do something with their Twitter account
            NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/account/verify_credentials.json"];
            TWRequest *req = [[TWRequest alloc] initWithURL:url
                                                 parameters:nil
                                              requestMethod:TWRequestMethodGET];
            
            // Important: attach the user's Twitter ACAccount object to the request
            req.account = account;
            
            [req performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse,
                                             NSError *error) {
                
                // If there was an error making the request, display a message to the user
                if(error != nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                    message:@"There was an error talking to Twitter. Please try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                // Parse the JSON response
                NSError *jsonError = nil;
                id resp = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:0
                                                            error:&jsonError];
                
                // If there was an error decoding the JSON, display a message to the user
                if(jsonError != nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                    message:@"Twitter is not acting properly right now. Please try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                _twitterResponse = responseData;
                NSString *screenName = [resp objectForKey:@"screen_name"];
                
                // Make sure to perform our operation back on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Do something with the fetched data
                    [self.twitterSigninButton setEnabled:YES];
                    [self performSelectorOnMainThread:@selector(checkTwitterName:) withObject:screenName waitUntilDone:NO];
                });
            }];

        }
    }];
    
}

#pragma mark -
#pragma mark UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"selected index %d",buttonIndex);
    if (buttonIndex < ([actionSheet numberOfButtons] - 1)) {
        [self chooseTwitterAccount:buttonIndex];
    }else {
        [self.twitterSigninButton setEnabled:YES];
    }
    
}

@end
