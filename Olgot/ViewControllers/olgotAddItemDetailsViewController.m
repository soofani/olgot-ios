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
#import "olgotAddItemConfirmationViewController.h"

@interface olgotAddItemDetailsViewController ()

@end

@implementation olgotAddItemDetailsViewController

@synthesize itemImageView = _itemImageView;
@synthesize itemImage = _itemImage;
@synthesize progressView = _progressView;
@synthesize scrollView = _scrollView;
@synthesize venueImageIV = _venueImageIV;
@synthesize venueNameLabel = _venueNameLabel;
@synthesize venueLocationLabel = _venueLocationLabel;
@synthesize itemPriceTF = _itemPriceTF;
@synthesize descriptionTF = _descriptionTF;
@synthesize postButton = _postButton;
@synthesize venue = _venue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
                    [_progressView setProgress:0.0];
                    [_progressView setHidden:NO];
                    [self performSelector:@selector(postPhoto)];
                    
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

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"user data: %@",[request userData]);
    NSNumber* uploaded = [NSNumber numberWithInteger:totalBytesWritten];
    NSNumber* total = [NSNumber numberWithInteger:totalBytesExpectedToWrite];
    float progress = ([uploaded floatValue] / [total floatValue] );
    NSLog(@"progress: %f", progress);
    [_progressView setProgress:progress animated:YES];
    NSLog(@"sent bytes: %d of %d",totalBytesWritten,totalBytesExpectedToWrite);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    whyCoolTF.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:78.0/255.0 blue:32.0/255.0 alpha:1.0] CGColor];
//    whyCoolTF.layer.borderWidth = 1.0f;
//    
//    whyCoolTF.layer.cornerRadius = 5;
//    whyCoolTF.clipsToBounds = YES;
    
    [self.itemImageView setImage:_itemImage];
    [self configureView];
    _progressView.progress = 0.0f;
    [_progressView setHidden:YES];
}

-(void)configureView
{
    [self.venueImageIV setImageWithURL:[NSURL URLWithString:[_venue venueIcon]]];
    [self.venueNameLabel setText:[_venue name_En]];
    [self.venueLocationLabel setText:[_venue name_En]];
}

- (void)viewDidUnload
{
    [self setVenueImageIV:nil];
    [self setVenueNameLabel:nil];
    [self setVenueLocationLabel:nil];
    [self setItemPriceTF:nil];
    [self setDescriptionTF:nil];
    [self setPostButton:nil];
    [self setProgressView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dismissKeyboard {
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.itemPriceTF resignFirstResponder];
    [self.descriptionTF resignFirstResponder];
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

-(void)postPhoto
{
    NSLog(@"Got image: %@", [_itemImageView image]);
    RKParams* params = [RKParams params];
    [params setValue:_itemID forParam:@"item"];
    
//    NSData* imageData = UIImagePNGRepresentation(_itemImage);
    NSData* imageData = UIImageJPEGRepresentation([_itemImage fixOrientation], 0.2);
//    [params setData:imageData MIMEType:@"image/jpeg" forParam:@"file"];
    [params setData:imageData MIMEType:@"image/jpeg" fileName:@"myimage.jpg" forParam:@"file"];
    
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
    
    [[[RKClient sharedClient] post:@"/photo/" params:params delegate:self] setUserData:@"uploadPhoto"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"ShowAddItemConfirmation"]){
        olgotAddItemConfirmationViewController* confirmationController = [segue destinationViewController];
        
        confirmationController.itemID = _itemID;
        confirmationController.itemKey = _itemKey;
        confirmationController.venueID = [_venue venueId];
        confirmationController.venueItemCount = [_venue items];
        
    }
}

@end
