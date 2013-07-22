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
#import "olgotUser.h"

@interface olgotSignupRootViewController ()

@end

@implementation olgotSignupRootViewController
@synthesize activityIndicator;
@synthesize facebookSigninButton;
@synthesize twitterSigninButton;

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
    [self setFacebookSigninButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
                
                [self.activityIndicator stopAnimating];
                
                UIActionSheet* twitterActionSheet;
                twitterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                for (ACAccount* ac in twitterAccounts) {
                    [twitterActionSheet addButtonWithTitle:[ac accountDescription]];
                }
                
                [twitterActionSheet showInView:self.view];
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

- (IBAction)facebookSignin:(id)sender {
    [self openFBSession];
}

-(void)checkTwitterName:(NSString *)text
{
    _twitterName = text;
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: _twitterName, @"twittername", nil];
    NSString* resourcePath = [@"/userid/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

-(void)checkFacebookId:(NSString *)fbID
{
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: fbID, @"facebookid", nil];
    NSString* resourcePath = [@"/userid/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqual:@"ShowChooseUsername"]){
        olgotChooseUsernameViewController* chooseUsernameVC = [segue destinationViewController];
        if (_twitterResponse) {
            chooseUsernameVC.twitterResponseData = _twitterResponse;
        } else if(fbUser) {
            chooseUsernameVC.fbUser = fbUser;
        }
        
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
                    // Store the data
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:[NSNumber numberWithInt:accountNumber] forKey:@"twitterAccountIndex"];
                    
                    [defaults synchronize];
                    
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
    if (buttonIndex > 0) {
        [self chooseTwitterAccount:(buttonIndex - 1)];
    }else {
        [self.twitterSigninButton setEnabled:YES];
    }
    
}

#pragma mark Facebook methods

- (void)openFBSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions",
                            nil];
    
    [FBSession openActiveSessionWithPermissions:permissions
                                   allowLoginUI:YES
                              completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self FBsessionStateChanged:session state:state error:error];
     }];
}

- (void)FBsessionStateChanged:(FBSession *)session
                        state:(FBSessionState) state
                        error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"fb session open");
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     NSLog(@"my info %@ :",user);
                     fbUser = user;
                     NSLog(@"photo url: %@",[user objectForKey:@"picture"]);
                     [self checkFacebookId:user.id];
                 }
             }];
            
            
            
        }
            break;
        case FBSessionStateClosed:
            NSLog(@"Closed");
            
        case FBSessionStateClosedLoginFailed:
            NSLog(@"Failed");
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark RKObjectLoader Delegate


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    NSLog(@"Loaded payload: %@", [response bodyAsString]);  
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    NSLog(@"Loaded user: %@",[objects objectAtIndex:0]);
    olgotUser* myUser = [objects objectAtIndex:0];
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"yes" forKey:@"firstRun"];
    [defaults setObject:myUser.userId forKey:@"userid"];
    [defaults setObject:myUser.username forKey:@"username"];
    [defaults setObject:myUser.email forKey:@"email"];
    [defaults setObject:[NSString stringWithFormat:@"%@ %@", myUser.firstName, myUser.lastName] forKey:@"fullname"];
    [defaults setObject:myUser.twitterId forKey:@"twitterid"];
    [defaults setObject:myUser.twitterName forKey:@"twittername"];
    [defaults setObject:myUser.userProfileImageUrl forKey:@"userProfileImageUrl"];
    
    [defaults setObject:myUser.facebookId forKey:@"userFacebookId"];
    
    [defaults setObject:@"yes" forKey:@"autoSavePhotos"];
    [defaults setObject:@"yes" forKey:@"autoTweetItems"];
    
    [defaults setObject:@"no" forKey:@"hasNotifications"];
    [defaults setObject:0 forKey:@"lastNotification"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved: %@", defaults);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[NSString stringWithFormat:@"Welcome back %@",myUser.username]
                                                   delegate:nil
                                          cancelButtonTitle:@":)"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    id resp = [NSJSONSerialization JSONObjectWithData:[[objectLoader response] body]
                                              options:0
                                                error:nil];
    
    if ([[objectLoader response] statusCode] == 404) {
        //New User
        NSLog(@"server message %@", [resp objectForKey:@"message"]);
        [self performSegueWithIdentifier:@"ShowChooseUsername" sender:self];
    }else if ([[objectLoader response] statusCode] == 406) {
        //User needs invitation
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[resp objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    }
}


@end
