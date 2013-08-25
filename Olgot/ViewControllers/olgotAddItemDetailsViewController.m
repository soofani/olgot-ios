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

#import "olgotCameraOverlayViewController.h"

#import "olgotProtocols.h"
#import <FacebookSDK/FBRequest.h>

@interface olgotAddItemDetailsViewController ()

@end

@implementation olgotAddItemDetailsViewController
@synthesize twitterShareBtn = _twitterShareBtn;
@synthesize facebookShareBtn = _facebookShareBtn;

@synthesize itemsBgImageView = _itemsBgImageView;
@synthesize expandableView = _expandableView;
@synthesize itemImageView = _itemImageView;
@synthesize itemImage = _itemImage;
@synthesize scrollView = _scrollView;
//@synthesize venueImageIV = _venueImageIV;
//@synthesize venueNameLabel = _venueNameLabel;
//@synthesize venueLocationLabel = _venueLocationLabel;
@synthesize itemPriceTF = _itemPriceTF;
@synthesize descriptionTF = _descriptionTF;
@synthesize itemNameTF = _itemNameTF;
@synthesize whereTxtField = _whereTxtField;
@synthesize postButton = _postButton;
@synthesize venue = _venue;
@synthesize delegate;
@synthesize cameraOverlayViewController;

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
                    
                    
                    [loadingUi hide:YES];
                    
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

    
    self.itemPriceTF.textColor = [UIColor lightGrayColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"autoTweetItems"] isEqual:@"yes"]) {
        twitterShare = YES;
    }else {
        twitterShare = NO;
    }
    
    facebookShare = NO;
    
    [self.itemImageView setImage:_itemImage];
    [self configureView];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+320)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 100, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    //description text area
    self.descriptionTF.clipsToBounds = YES;
    self.descriptionTF.layer.cornerRadius = 5.0f;
    [self.descriptionTF.layer setBorderColor:[[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.descriptionTF.layer setBorderWidth:1.0];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.descriptionTF.inputAccessoryView = numberToolbar;

}

-(void)doneWithNumberPad
{
    if ([self.descriptionTF.text isEqualToString:@""])
    {
        self.descriptionTF.text = @"Provide some details             Optional";
        [self.descriptionTF setTextColor:[UIColor lightGrayColor]];
    }
      [self.descriptionTF resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
        [self.scrollView scrollRectToVisible:CGRectMake(0, 100, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [UIView commitAnimations];
    
}

-(void)configureView
{
//    [self.venueImageIV setImageWithURL:[NSURL URLWithString:[_venue venueIcon]]];
//    [self.venueNameLabel setText:[_venue name_En]];
//    [self.venueLocationLabel setText:[_venue name_En]];
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

-(void)venueSelectedWithLocationObject:(olgotVenue*)venue
{
//    [self.venueNameLabel setText:[_venue name_En]];
//    [self.venueLocationLabel setText:[_venue name_En]];
    self.venue = venue;
    self.whereTxtField.text = [venue name_En];
//    NSLog(@"self.whereTxtField.text = %@ ", self.whereTxtField.text);
//    if(self.whereTxtField.text.length == 0)
//        self.whereTxtField.text = @"Where?                                  Optional";
}
-(IBAction)openLocationViewPressed:(id)sender
{
    olgotAddItemNearbyPlacesViewController* nearbyController = [[olgotAddItemNearbyPlacesViewController alloc] init];
    
//    nearbyController.capturedImage = editedImage;
    nearbyController.delegate = self;
    
    [self.navigationController pushViewController:nearbyController animated:YES];
    

}

-(void)backSim
{
//    [self.delegate wantsBack];
    
    [self wantsBack];
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
//    [self setVenueImageIV:nil];
//    [self setVenueNameLabel:nil];
//    [self setVenueLocationLabel:nil];
    [self setWhereTxtField:nil];
    [self setItemPriceTF:nil];
    [self setDescriptionTF:nil];
    [self setItemNameTF:nil];
    [self setPostButton:nil];
    [self setScrollView:nil];
    [self setItemImage:nil];
    [self setTwitterShareBtn:nil];
    [self setFacebookShareBtn:nil];
    [self setItemsBgImageView:nil];
    [self setExpandableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:self];
}

-(void)dismissKeyboard {
//    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.itemPriceTF resignFirstResponder];
    [self.descriptionTF resignFirstResponder];
    [self.itemNameTF resignFirstResponder];
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

-(IBAction)editImagePressed:(id)sender
{
    UIActionSheet *addImageAS = [[UIActionSheet alloc] initWithTitle:@"Take a photo for this item" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    
    addImageAS.actionSheetStyle = UIActionSheetStyleDefault;
    [addImageAS showInView:self.view];
    
}

-(void)showCamAnimated:(BOOL)animated source:(UIImagePickerControllerSourceType)sourceType
{
    self.cameraOverlayViewController = [[olgotCameraOverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
    self.cameraOverlayViewController.delegate = self;
    
    [self.cameraOverlayViewController setupImagePicker:sourceType];
    [self presentModalViewController:self.cameraOverlayViewController.imagePickerController animated:animated];
    
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        
        [self showCamAnimated:YES source:UIImagePickerControllerSourceTypeCamera];
	} else if (buttonIndex == 1) {
        [self wantsLibrary];
	}
    else if (buttonIndex == 3) {
        //cancel
    }
    
}
#pragma mark - olgotCameraOverlayControllerDelegate

-(void)tookPicture:(UIImage *)image
{
    //OPTIMIZE
    //    image = [image fixOrientation];
    //    image = [image rotateAndScaleFromCameraWithMaxSize:640.0];
    
    GPUImageLanczosResamplingFilter *resampler = [[GPUImageLanczosResamplingFilter alloc] init];
    
    [resampler forceProcessingAtSizeRespectingAspectRatio:CGSizeMake(900.0, 900.0)];
    
    UIImage *smallImage = [resampler imageByFilteringImage:image];
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:[smallImage fixOrientation]];
	[cropper setDelegate:self];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:cropper animated:NO];
}

-(void)cancelled
{
    [self dismissModalViewControllerAnimated:NO];
    NSLog(@"cancelled");
}

-(void)wantsLibrary
{
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - olgotTrimEffectsDelegate

- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)editedImage
{
    //    olgotAddItemNearbyPlacesViewController* nearbyController = [[olgotAddItemNearbyPlacesViewController alloc] init];
    
    //    nearbyController.capturedImage = editedImage;
    //    nearbyController.delegate = self;
    
    //    UINavigationController *camNavController = [[UINavigationController alloc] initWithRootViewController:nearbyController];
    [self.itemImageView setImage:editedImage];
    [self dismissModalViewControllerAnimated:NO];
    //    [self presentModalViewController:camNavController animated:NO];
}

- (void)imageCropperDidCancel:(ImageCropper *)cropper {
	[self dismissModalViewControllerAnimated:NO];
	
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - addItemNearbyDelegate

-(void)wantsBack
{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
//    }];

//    [self.navigationController popViewControllerAnimated:YES];
//                                              completion:^{
//        [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
//    }];
    
    [self exitAddItemFlow];
}

-(void)exitAddItemFlow
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(textView == self.itemPriceTF)
    {
    if([text isEqualToString:@"\n"]) {
        UITextView* priceTF = textView;
        if ([priceTF.text length] == 0 || [priceTF.text isEqualToString:@" "]) {
            [priceTF setText:@"What do you want for it? (example: $5, a Coffeee, nothing)"];
        }
        [textView resignFirstResponder];
        return NO;
    }
    }else if(textView == self.descriptionTF)
    {
        if((textView.text.length == 0 || textView.text.length == 1) && [text isEqualToString:@""])
        {
            //            [self.postButton setEnabled:NO];
            
            //            CGRect myCommentViewFrame = self.descriptionTF.frame;
            //            CGRect textViewFrame = textView.frame;
            //
            //            myCommentViewFrame.size.height = 50;
            //            myCommentViewFrame.origin.y = self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-myCommentViewFrame.size.height-172;
            //            [self.descriptionTF setFrame:myCommentViewFrame];
            //
            //            textViewFrame.origin.y = 8.0f;
            //            textViewFrame.size.height = 34;
            //            textView.frame = textViewFrame;
            
        }
        else
        {
            //            [self.postButton setEnabled:YES];
            
            
            CGRect descTfFrame = self.descriptionTF.frame;
            CGRect expandableViewFrame = self.expandableView.frame;
            CGRect textViewFrame = textView.frame;
            NSInteger oldH = textViewFrame.size.height;
            NSInteger newH = [textView contentSize].height;
            
            if(newH != oldH && newH <=142)//this equal to the height of 7 lines
            {
                //                textViewFrame.size.height = newH;
                //                textView.frame = textViewFrame;
                
                //       //reset to default size
//                CGRect ff = self.allItemsView.frame;
//                ff.size.height += (newH - oldH);
//                //                    ff.origin.y -= (newH - oldH);
//                [self.allItemsView setFrame:ff];
                
                descTfFrame.size.height = newH;//textView.frame.size.height + 16;
                descTfFrame.origin.y -= (newH - oldH) ;//self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-myCommentViewFrame.size.height-172;
                [self.descriptionTF setFrame:descTfFrame];
                
//                CGRect variableViewFrame = self.variableView.frame;
                expandableViewFrame.origin.y -= (newH - oldH);
                [self.expandableView setFrame:expandableViewFrame];
                
                //                CGRect scrollViewframe = self.scrollView.frame;
//                CGSize scrollViewSize = self.scrollView.contentSize;
//                scrollViewSize.height += (newH - oldH);
//                ////                scrollViewframe.origin.y += (newH - oldH);
//                ////                scrollViewframe.size.height += (newH - oldH);
//                [self.scrollView setContentSize:scrollViewSize];
                
                
                //                [self.scrollView setFrame:scrollViewframe];
                //                 scrollViewframe.origin.y += (newH - oldH);
                //                [self.scrollView setFrame:scrollViewframe];
                //                CGRect stretchableArea = self.scrollView.contentStretch;
                //                stretchableArea.origin.y += (newH - oldH);
                //                stretchableArea.size.height += (newH - oldH);
                //                 [self.scrollView setContentStretch:stretchableArea];
                
                //                CGPoint point = self.scrollView.contentOffset;
                //                point.y -= (newH - oldH)*2;
                //                [self.scrollView setContentOffset:point animated:YES];
                
                
                
                CGRect bgImageFrame = self.itemsBgImageView.frame;
                bgImageFrame.size.height += (newH - oldH);
                bgImageFrame.origin.y -= (newH - oldH);
                [self.itemsBgImageView setFrame:bgImageFrame];
                
                //                
                //                textViewFrame.origin.y = 8.0f;
                //                textView.frame = textViewFrame;
                
            }
            
            
        }
        
    }

    
    return YES;
}

//- (IBAction)addedPrice:(id)sender {
//    UITextField* priceTF = sender;
//
//    if ([priceTF.text length] == 0) {
//        [priceTF setText:@"0.00"];
//    }
//    [self performSelector:@selector(dismissKeyboard)];
//}

- (IBAction)addedName:(id)sender {
    
    [self performSelector:@selector(dismissKeyboard)];
}
- (IBAction)addedDescription:(id)sender {
    
    [self performSelector:@selector(dismissKeyboard)];
}

- (IBAction)postButtonPressed:(id)sender {
    if(![self verifyFields])
        return;
    
    [self.postButton setEnabled:NO];
    //    [self.itemPriceTF setEnabled:NO];
    //    [self.itemPriceTF setEditable:NO];
    [self.descriptionTF setEditable:NO];
    [self.itemNameTF setEnabled:NO];
    [self performSelector:@selector(dismissKeyboard)];
    [self performSelector:@selector(postItem)];
}

////to make a placeholder with gray color
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == self.itemPriceTF)
    {
    if([self.itemPriceTF.text isEqualToString:@"What do you want for it? (example: $5, a Coffeee, nothing)"])
        self.itemPriceTF.text = @"";
    self.itemPriceTF.textColor = [UIColor blackColor];
    }else if (textView == self.descriptionTF)
    {
        if ([self.descriptionTF.text isEqualToString:@"Provide some details             Optional"])
        {
            self.descriptionTF.text = @"";
        }
        self.descriptionTF.textColor = [UIColor blackColor];
                                                            //216 is the keyboard height
         [self.scrollView scrollRectToVisible:CGRectMake(0, 40+216, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        //        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        //        if ([defaults objectForKey:@"userid"] == nil) {
//        //            [self.descriptionTF resignFirstResponder];
//        //            olgotAppDelegate* appDelegate = (olgotAppDelegate*)[UIApplication sharedApplication].delegate;
//        //            [appDelegate showSignup];
//        //        }else
//        {
//            [self performSelector:@selector(reset)];
//            CGPoint pp = self.scrollView.contentOffset;
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//            
//            //            self.descriptionTF.frame = CGRectMake(0, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-50-172, self.view.frame.size.width, 50);
//            
//            if(self.view.frame.size.height>=500)
//                [self.scrollView setContentOffset:CGPointMake(0.0, (100.0 + self.descriptionTF.frame.size.height-34.0)) animated:YES];
//            else
//                [self.scrollView setContentOffset:CGPointMake(0.0, (180.0 + self.descriptionTF.frame.size.height-34.0)) animated:YES];
//            [UIView commitAnimations];
//            
//            
//        }
        
    }

    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView == self.itemPriceTF)
    {
    if(self.itemPriceTF.text.length == 0){
        self.itemPriceTF.textColor = [UIColor lightGrayColor];
        self.itemPriceTF.text = @"What do you want for it? (example: $5, a Coffeee, nothing)";
        [self.itemPriceTF resignFirstResponder];
    }
    }
}
/////


//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    UITextView* priceTF = textView;
//    
//    if ([priceTF.text isEqualToString:@"What do you want for it? (example: $5, a Coffeee, nothing)"]) {
//        [priceTF setText:@""];
//    }
//    [self.scrollView setContentOffset:CGPointMake(0.0, 50.0) animated:YES];
//}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.itemPriceTF)
    {
        if( [self.itemPriceTF.text isEqualToString:@"What do you want for it? (example: $5, a Coffeee, nothing)"])
            self.itemPriceTF.textColor = [UIColor lightGrayColor];
    }
}
//- (IBAction)editPrice:(id)sender {
//    UITextField* priceTF = sender;
//
//    if ([priceTF.text isEqualToString:@"0.00"]) {
//        [priceTF setText:@""];
//    }
//    [self.scrollView setContentOffset:CGPointMake(0.0, 100.0) animated:YES];
//}

//- (IBAction)editItemName:(id)sender {
//    [self.scrollView setContentOffset:CGPointMake(0.0, 100.0) animated:YES];
//}

- (IBAction)editDescription:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0.0, 150.0) animated:YES];
}

-(BOOL)verifyFields{
    if(self.itemNameTF.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter an item name." delegate:nil cancelButtonTitle:@"OK.." otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}


-(void)postItem
{
    
    loadingUi = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    loadingUi.mode = MBProgressHUDModeAnnularDeterminate;
    //    loadingUi.delegate = self;
    loadingUi.labelText = @"posting your item.....";
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    if([self.itemPriceTF.text isEqualToString:@"What do you want for it? (example: $5, a Coffeee, nothing)"]);
//       self.itemPriceTF.text = @"";
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [defaults objectForKey:@"userid"], @"id",
                            [_venue venueId], @"venue",
                            self.itemPriceTF.text,@"price",
                            self.descriptionTF.text,@"description",
                            self.itemNameTF.text,@"itemName",
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
    confirmationController.itemPrice = self.itemPriceTF.text;//[NSNumber numberWithFloat:[self.itemPriceTF.text floatValue]];
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
//    [self.delegate exitAddItemFlow];
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:YES];
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
