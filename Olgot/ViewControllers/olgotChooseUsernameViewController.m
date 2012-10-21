//
//  olgotChooseUsernameViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotChooseUsernameViewController.h"
#import "olgotChooseFriends.h"
#import <QuartzCore/QuartzCore.h>
#import "DejalActivityView.h"
#import "olgotAppDelegate.h"

@interface olgotChooseUsernameViewController ()

@end

@implementation olgotChooseUsernameViewController
@synthesize usernameTF;
@synthesize userEmail;
@synthesize createAccountBtn;
@synthesize twitterResponseData = _twitterResponseData;
@synthesize fbUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setTwitterResponseData:(NSData *)twitterResponseData
{
    if(_twitterResponseData != twitterResponseData){
        _twitterResponseData = twitterResponseData;
        NSError *jsonError = nil;
        _twitterJson = [NSJSONSerialization JSONObjectWithData:_twitterResponseData
                                                       options:0
                                                         error:&jsonError];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(self.twitterResponseData){
        [self.usernameTF setText:[_twitterJson objectForKey:@"screen_name"]];
    }else if (self.fbUser){
        NSLog(@"facebook");
        [self.usernameTF setText:[NSString stringWithFormat:@"%@%@", self.fbUser.first_name, self.fbUser.last_name]];
        [self.userEmail setText:[fbUser objectForKey:@"email"]];
        
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidUnload
{
    [self setUsernameTF:nil];
    [self setUserEmail:nil];
    [self setCreateAccountBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dismissKeyboard {
    [self.usernameTF resignFirstResponder];
    [self.userEmail resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressedNext:(id)sender {
    [self.userEmail becomeFirstResponder];
}

- (IBAction)pressedDone:(id)sender {
    [self dismissKeyboard];
}

-(BOOL)verifyFields{
    if(self.usernameTF.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please choose a Username." delegate:nil cancelButtonTitle:@"OK.." otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(self.usernameTF.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please type in your Email address." delegate:nil cancelButtonTitle:@"OK.." otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    return YES;
}

- (IBAction)createAccount:(id)sender {

    if ([self verifyFields]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
        
        if (_twitterResponseData) {
            NSString* completeResponse = [[NSString alloc] initWithData:_twitterResponseData encoding:NSUTF8StringEncoding];
            
            NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.usernameTF.text,@"username",
                                    @"nopass",@"password",
                                    self.userEmail.text, @"email",
                                    [_twitterJson objectForKey:@"name"],@"fullname",
                                    [_twitterJson objectForKey:@"id"],@"twitterid",
                                    [_twitterJson objectForKey:@"screen_name"],@"twittername",
                                    completeResponse,@"array",
                                    nil];
            
            [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [[[RKClient sharedClient] post:@"/user/" params:params delegate:self] setUserData:@"twitter"];
        }else if (self.fbUser){
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"picture",@"fields",nil];
            FBRequest *picRequest = [FBRequest requestWithGraphPath:@"me" parameters:params HTTPMethod:nil];
            
            [picRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                NSString* userProfileImageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                
                NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.usernameTF.text,@"username",
                                        @"nopass",@"password",
                                        self.userEmail.text, @"email",
                                        self.fbUser.name,@"fullname",
                                        self.fbUser.id,@"facebookid",
                                        userProfileImageUrl, @"facebookimg",
                                        nil];
                NSLog(@"facebook id: %@", self.fbUser.id);
                
                [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [[[RKClient sharedClient] post:@"/user/" params:params delegate:self] setUserData:@"facebook"];

                
            }];
            
        }
        
    }
    
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    
    NSLog(@"Retrieved: %@", [response bodyAsString]);  
    
    if ([request isGET]) {   
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            
        }  
        
    } else if ([request isPOST]) {  
        [DejalBezelActivityView removeViewAnimated:YES];
        if ([response isJSON]) {
            id resp = [NSJSONSerialization JSONObjectWithData:[response body]
                                                      options:0
                                                        error:nil];
            if([response isOK]){
                NSLog(@"Got a JSON response back from our POST! %@", [response bodyAsString]);
                _userID = [resp objectForKey:@"id"];
                
                if ([[request userData] isEqual:@"facebook"]) {
                    NSLog(@"facebook");
                        
                        // Store the data
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:@"yes" forKey:@"firstRun"];
                        [defaults setObject:_userID forKey:@"userid"];
                        [defaults setObject:self.usernameTF.text forKey:@"username"];
                        [defaults setObject:self.userEmail.text forKey:@"email"];
                        [defaults setObject:[resp objectForKey:@"profileImgUrl"] forKey:@"userProfileImageUrl"];
                        [defaults setObject:[self.fbUser name] forKey:@"fullname"];
                        [defaults setObject:0 forKey:@"twitterid"];
                        [defaults setObject:0 forKey:@"twittername"];
                        [defaults setObject:[resp objectForKey:@"facebookId"] forKey:@"userFacebookId"];
                        
                        [defaults setObject:@"yes" forKey:@"autoSavePhotos"];
                        [defaults setObject:@"no" forKey:@"autoTweetItems"];
                        
                        [defaults setObject:@"no" forKey:@"hasNotifications"];
                        [defaults setObject:0 forKey:@"lastNotification"];
                        
                        [defaults synchronize];
                        
                        NSLog(@"Data saved");
                        
//                        [self performSegueWithIdentifier:@"ShowChooseFriends" sender:self];
                    [self showChooseFriends];

                } else if ([[request userData] isEqual:@"twitter"]) {
                    NSLog(@"twitter");
                    NSString* userProfileImageUrl = [resp objectForKey:@"profileImgUrl"];
                    // Store the data
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:@"yes" forKey:@"firstRun"];
                    [defaults setObject:_userID forKey:@"userid"];
                    [defaults setObject:self.usernameTF.text forKey:@"username"];
                    [defaults setObject:self.userEmail.text forKey:@"email"];
                    [defaults setObject:userProfileImageUrl forKey:@"userProfileImageUrl"];
                    [defaults setObject:[_twitterJson objectForKey:@"name"] forKey:@"fullname"];
                    [defaults setObject:[_twitterJson objectForKey:@"id"] forKey:@"twitterid"];
                    [defaults setObject:[_twitterJson objectForKey:@"screen_name"] forKey:@"twittername"];
                    
                    [defaults setObject:0 forKey:@"userFacebookId"];
                    
                    [defaults setObject:@"yes" forKey:@"autoSavePhotos"];
                    [defaults setObject:@"no" forKey:@"autoTweetItems"];
                    
                    [defaults setObject:@"no" forKey:@"hasNotifications"];
                    [defaults setObject:0 forKey:@"lastNotification"];
                    
                    [defaults synchronize];
                    
                    NSLog(@"Data saved");
                    
//                    [self performSegueWithIdentifier:@"ShowChooseFriends" sender:self];
                    [self showChooseFriends];
                }
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup Error"
                                                                message:[resp objectForKey:@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }  
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowChooseFriends"]) {
        olgotChooseFriends* chooseFriendsVC = [segue destinationViewController];
        chooseFriendsVC.userID = _userID;
    }
}

-(void)showChooseFriends
{
    olgotChooseFriends* chooseFriendsVC = [[olgotChooseFriends alloc] init];
    chooseFriendsVC.userID = _userID;
    chooseFriendsVC.delegate = (olgotAppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationController pushViewController:chooseFriendsVC animated:YES];
}

@end
