//
//  olgotAddItemDetailsViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "UIImage+fixOrientation.h"

#import "olgotItem.h"
#import "olgotTabBarViewController.h"

#import "DejalActivityView.h"

#import "olgotProtocols.h"
#import <FacebookSDK/FBRequest.h>

@interface olgotAddItemDetailsViewController ()

@end

@implementation olgotAddItemDetailsViewController
@synthesize twitterShareBtn = _twitterShareBtn;
@synthesize facebookShareBtn = _facebookShareBtn;

@synthesize itemImageView = _itemImageView;
@synthesize itemImage = _itemImage;
@synthesize scrollView = _scrollView;
@synthesize venueImageIV = _venueImageIV;
@synthesize venueNameLabel = _venueNameLabel;
@synthesize venueLocationLabel = _venueLocationLabel;
@synthesize itemPriceTF = _itemPriceTF;
@synthesize descriptionTF = _descriptionTF;
@synthesize postButton = _postButton;
@synthesize venue = _venue;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Add Item";
    }
    return self;
}

-(void)setVenue:(olgotVenue *)venue
{
    if (_venue != venue) {
        
        _venue = venue;
        NSLog(@"set venue %@",_venue);
        [self configureView];
    }
}

-(void)addBackButton{
    UIImage *backImage = [UIImage imageNamed:@"btn-nav-back"];
    
    UIButton *customBackBtn = [[UIButton alloc] init];
    
    customBackBtn.frame=CGRectMake(0,0,55,30);
    [customBackBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [customBackBtn addTarget:self action:@selector(backSim) forControlEvents:UIControlEventTouchUpInside];
    [customBackBtn setTitle:@"  Back" forState:UIControlStateNormal];
    [customBackBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:customBackBtn];
    
    self.navigationItem.leftBarButtonItem = button;
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"resource path: %@",[request resourcePath]);
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    if ([request isPOST]) {  
        
        if ([response isJSON]) {
            
            if([response isOK]){
                if ([[request userData] isEqual:@"postItem"]) {
                    NSLog(@"posted item");
                    NSError *jsonError = nil;
                    
                    id _itemJsonResponse = [NSJSONSerialization JSONObjectWithData:[response body]
                                                                   options:0
                                                                     error:&jsonError];
                    
                    _itemID = [_itemJsonResponse objectForKey:@"id"];
                    _itemKey = [_itemJsonResponse objectForKey:@"key"];
                    _itemUrl = [_itemJsonResponse objectForKey:@"itemUrl"];
//                    [self performSelector:@selector(postPhoto)];
//                    [self performSegueWithIdentifier:@"ShowAddItemConfirmation" sender:self];
                    [self showAddItemConfirmation];
                }else if ([[request userData] isEqual:@"uploadPhoto"]) {
                    NSLog(@"posted photo");
                    [self performSegueWithIdentifier:@"ShowAddItemConfirmation" sender:self];
                }
            }else {
                
            }
        }  
        
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {

}

- (void)requestDidStartLoad:(RKRequest *)request {
//    NSLog(@"request started with user data %@",[request userData]);
//    if ([[request userData] isEqual:@"uploadPhoto"]) {
//        _progressView.hidden = NO;
//        NSLog(@"started uploading photo");
//    }
}

//- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
//    NSLog(@"user data: %@",[request userData]);
//    NSNumber* uploaded = [NSNumber numberWithInteger:totalBytesWritten];
//    NSNumber* total = [NSNumber numberWithInteger:totalBytesExpectedToWrite];
//    float progress = ([uploaded floatValue] / [total floatValue] );
//    NSLog(@"progress: %f", progress);
//    [_progressView setProgress:progress animated:YES];
//    NSLog(@"sent bytes: %d of %d",totalBytesWritten,totalBytesExpectedToWrite);
//}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"autoTweetItems"] isEqual:@"yes"]) {
        twitterShare = YES;
    }else {
        twitterShare = NO;
    }
    
    facebookShare = NO;
    
    [self.itemImageView setImage:_itemImage];
    [self configureView];
}

-(void)configureView
{
    [self.venueImageIV setImageWithURL:[NSURL URLWithString:[_venue venueIcon]]];
    [self.venueNameLabel setText:[_venue name_En]];
    [self.venueLocationLabel setText:[_venue name_En]];
    [self configureSharingBtns];
    
    
    //if view controller is coming from add venue, count is 1 -- no nearby controller
    if([[self.navigationController viewControllers] count] == 1){
        UIImage *backImage = [UIImage imageNamed:@"btn-nav-back"];
        
        UIButton *customBackBtn = [[UIButton alloc] init];
        
        customBackBtn.frame=CGRectMake(0,0,55,30);
        [customBackBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        [customBackBtn addTarget:self action:@selector(backSim) forControlEvents:UIControlEventTouchUpInside];
        [customBackBtn setTitle:@"  Back" forState:UIControlStateNormal];
        [customBackBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
        
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:customBackBtn];
        
        self.navigationItem.leftBarButtonItem = button;
    }
}

-(void)backSim
{
    [self.delegate wantsBack];
}

-(void)configureSharingBtns
{
    if (twitterShare) {
        [_twitterShareBtn setImage:[UIImage imageNamed:@"btn-share-twitter-on"] forState:UIControlStateNormal];
    } else {
        [_twitterShareBtn setImage:[UIImage imageNamed:@"btn-share-twitter"] forState:UIControlStateNormal];
    }
    
    if (facebookShare) {
        [_facebookShareBtn setImage:[UIImage imageNamed:@"btn-share-facebook-on"] forState:UIControlStateNormal];
    } else {
        [_facebookShareBtn setImage:[UIImage imageNamed:@"btn-share-facebook"] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [self setVenueImageIV:nil];
    [self setVenueNameLabel:nil];
    [self setVenueLocationLabel:nil];
    [self setItemPriceTF:nil];
    [self setDescriptionTF:nil];
    [self setPostButton:nil];
    [self setScrollView:nil];
    [self setItemImage:nil];
    [self setTwitterShareBtn:nil];
    [self setFacebookShareBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:self];
}

-(void)dismissKeyboard {
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.itemPriceTF resignFirstResponder];
    [self.descriptionTF resignFirstResponder];
}

-(void)tweetItem{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* twitterAccountIndex = [defaults objectForKey:@"twitterAccountIndex"];
    
    // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:[twitterAccountIndex intValue]];
                
                // Create a request, which in this example, posts a tweet to the user's timeline.
                // This example uses version 1 of the Twitter API.
                // This may need to be changed to whichever version is currently appropriate.
                
                NSString *venueTwitterName = [_venue twitterName];
                
                if ([venueTwitterName isEqual:@"@"]) {
                    venueTwitterName = @"";
                }
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:
                                                                     @"https://upload.twitter.com/1/statuses/update_with_media.json"]
                                                         parameters:nil
                                                      requestMethod:TWRequestMethodPOST];
                
                [request setAccount:twitterAccount];
                
                NSData *imageData = UIImagePNGRepresentation(self.itemImage);
                
                [request addMultiPartData:imageData
                                 withName:@"media[]"
                                     type:@"multipart/form-data"];
                
                NSString *status = [NSString stringWithFormat:@"Just posted this  at %@ using #Olgot %@ %@", [_venue name_En], venueTwitterName,_itemUrl];
                
                [request addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding]
                                 withName:@"status"
                                     type:@"multipart/form-data"];
                
                [request performRequestWithHandler:
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     NSDictionary *dict =
                     (NSDictionary *)[NSJSONSerialization
                                      JSONObjectWithData:responseData options:0 error:nil];
                     
                     // Log the result
                     NSLog(@"%@", dict);
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // perform an action that updates the UI...
                     });
                 }];
            }
        }
    }];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addedPrice:(id)sender {
    UITextField* priceTF = sender;
    
    if ([priceTF.text length] == 0) {
        [priceTF setText:@"0.00"];
    }
    [self performSelector:@selector(dismissKeyboard)];
}

- (IBAction)addedDescription:(id)sender {
    
    [self performSelector:@selector(dismissKeyboard)];
}

- (IBAction)postButtonPressed:(id)sender {
    [self.postButton setEnabled:NO];
    [self.itemPriceTF setEnabled:NO];
    [self.descriptionTF setEnabled:NO];
    [self performSelector:@selector(dismissKeyboard)];
    [self performSelector:@selector(postItem)];
}

- (IBAction)editPrice:(id)sender {
    UITextField* priceTF = sender;
    
    if ([priceTF.text isEqualToString:@"0.00"]) {
        [priceTF setText:@""];
    }
    [self.scrollView setContentOffset:CGPointMake(0.0, 100.0) animated:YES];
}

- (IBAction)editDescription:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0.0, 100.0) animated:YES];
}

-(void)postItem
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [defaults objectForKey:@"userid"], @"id",
                            [_venue venueId], @"venue",
                            self.itemPriceTF.text,@"price",
                            self.descriptionTF.text,@"description",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [[[RKClient sharedClient] post:@"/item/" params:params delegate:self] setUserData:@"postItem"];

}

-(void)showAddItemConfirmation
{
    olgotAddItemConfirmationViewController* confirmationController = [[olgotAddItemConfirmationViewController alloc] initWithNibName:@"addItemConfirmationView" bundle:[NSBundle mainBundle]];
    
    confirmationController.itemID = _itemID;
    confirmationController.itemKey = _itemKey;
    confirmationController.itemUrl = _itemUrl;
    confirmationController.capturedImage = _itemImage;
    confirmationController.itemPrice = [NSNumber numberWithFloat:[self.itemPriceTF.text floatValue]];
    confirmationController.venueID = [_venue venueId];
    confirmationController.venueName = [_venue name_En];
    confirmationController.venueItemCount = [_venue items];
    
    //        fire photo uploading
    NSLog(@"Got image: %@", [_itemImageView image]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    RKParams* params = [RKParams params];
    [params setValue:[defaults objectForKey:@"userid"] forParam:@"id"];
    [params setValue:_itemID forParam:@"item"];
    
    //    NSData* imageData = UIImagePNGRepresentation(_itemImage);
    NSData* imageData = UIImageJPEGRepresentation([_itemImage fixOrientation], 0.8);
    //    [params setData:imageData MIMEType:@"image/jpeg" forParam:@"file"];
    [params setData:imageData MIMEType:@"image/jpeg" fileName:@"myimage.jpg" forParam:@"file"];
    
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
    
    [[[RKClient sharedClient] post:@"/photo/" params:params delegate:confirmationController] setUserData:@"uploadPhoto"];
    
    [[[RKClient sharedClient] requestWithResourcePath:@"/photo/"] setDelegate:nil];
    
    if (twitterShare) {
        [self tweetItem];
    }
    
    
    confirmationController.facebookShare = facebookShare;
    
    
    confirmationController.delegate = [self.navigationController.viewControllers objectAtIndex:0];
    
    [self.navigationController pushViewController:confirmationController animated:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"ShowAddItemConfirmation"]){
        olgotAddItemConfirmationViewController* confirmationController = [segue destinationViewController];
        
        confirmationController.itemID = _itemID;
        confirmationController.itemKey = _itemKey;
        confirmationController.capturedImage = _itemImage;
        confirmationController.itemPrice = [NSNumber numberWithFloat:[self.itemPriceTF.text floatValue]];
        confirmationController.venueID = [_venue venueId];
        confirmationController.venueName = [_venue name_En];
        confirmationController.venueItemCount = [_venue items];
        
//        fire photo uploading
        NSLog(@"Got image: %@", [_itemImageView image]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        RKParams* params = [RKParams params];
        [params setValue:[defaults objectForKey:@"userid"] forParam:@"id"];
        [params setValue:_itemID forParam:@"item"];
        
        //    NSData* imageData = UIImagePNGRepresentation(_itemImage);
        NSData* imageData = UIImageJPEGRepresentation(_itemImage, 1.0);
        //    [params setData:imageData MIMEType:@"image/jpeg" forParam:@"file"];
        [params setData:imageData MIMEType:@"image/jpeg" fileName:@"myimage.jpg" forParam:@"file"];
        
        NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
        NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
        
        [[[RKClient sharedClient] post:@"/photo/" params:params delegate:confirmationController] setUserData:@"uploadPhoto"];
        
        [[[RKClient sharedClient] requestWithResourcePath:@"/photo/"] setDelegate:nil];
        
        if (twitterShare) {
            [self tweetItem];
        }
        
    }
}

- (IBAction)twitterSharePressed:(id)sender {
    
    twitterShare = !twitterShare;
    if (twitterShare) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* twitterAccountIndex = [defaults objectForKey:@"twitterAccountIndex"];
        
        if([TWTweetComposeViewController canSendTweet] && twitterAccountIndex != nil){
            //user can tweet, seebo b7alo
            NSLog(@"can tweet");
            
        }else{
            //user can't tweet
            twitterShare = NO;
            olgotAppDelegate *appDelegate = (olgotAppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.twitterDelegate = self;
            [appDelegate twitterConnect];
        }
    }

    [self configureSharingBtns];
}

- (IBAction)facebookSharePressed:(id)sender {
    
    facebookShare = !facebookShare;
    if (facebookShare) {
        if (FBSession.activeSession.state == FBSessionStateOpen) {
            // Yes, so just open the session (this won't display any UX).
            facebookShare = YES;
        }else{
            facebookShare = NO;
            olgotAppDelegate* appDelegate =  (olgotAppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.facebookDelegate = self;
            [appDelegate openFBSession];
        }
    }
    
    [self configureSharingBtns];
}

#pragma mark - addItemConfirmationProtocol

-(void)finishedAddItem
{
    [self.delegate exitAddItemFlow];
}

#pragma mark olgotTwitterDelegate;

-(void)loadingAccounts
{
    [DejalBezelActivityView activityViewForView:self.view];
}

-(void)loadedAccounts
{
    [DejalBezelActivityView removeView];
}

-(void)didChooseAccount
{
    twitterShare = YES;
    [self configureSharingBtns];
}

-(void)cancelledTwitter
{
    [DejalBezelActivityView removeView];
}

#pragma mark olgotFacebookDelegate

-(void)facebookSuccess
{
    facebookShare = YES;
    [self configureSharingBtns];
}

-(void)facebookFailed
{
    
}

-(void)facebookCancelled{
    
}




@end
