//
//  olgotAddItemConfirmationViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemConfirmationViewController.h"
#import "olgotItem.h"

#import "olgotProtocols.h"
#import <FacebookSDK/FBRequest.h>

@interface olgotAddItemConfirmationViewController ()

@end

@implementation olgotAddItemConfirmationViewController
//@synthesize scrollView;
@synthesize progressView = _progressView;
@synthesize itemImage;
@synthesize venueNameBtn;
@synthesize itemPriceLabel;
//@synthesize gotButton;
//@synthesize wantButton;
//@synthesize likeButton;
@synthesize placeBigLabel;
@synthesize placeItemCountLabel;
@synthesize capturedImage = _capturedImage;
@synthesize delegate;
@synthesize facebookShare = _facebookShare;
@synthesize itemUrl = _itemUrl;

@synthesize itemID = _itemID, itemKey = _itemKey, venueID = _venueID, venueItemCount = _venueItemCount, venueName = _venueName;
@synthesize itemPrice = _itemPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Great!";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *finishImage30 = [UIImage imageNamed:@"btn-nav-finish"];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    finishBtn.frame=CGRectMake(0,0,50,30);
    [finishBtn setBackgroundImage:finishImage30 forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishUpload) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    
    self.navigationItem.hidesBackButton = YES;
    
    [self configureItem];
    [self configureView];
}

-(void)configureItem
{
    _item = [[olgotItem alloc] init];
    [_item setItemID:_itemID];
    [_item setVenueId:_venueID];
    [_item setVenueName_En:_venueName];
    [_item setItemPrice:_itemPrice];
    [_item setILike:[NSNumber numberWithInt:0]];
    [_item setIWant:[NSNumber numberWithInt:0]];
    [_item setIGot:[NSNumber numberWithInt:0]];
    [_item setItemUrl:@"www.olgot.com"];
}

-(void)configureView
{
    [self.venueNameBtn setTitle:[_item venueName_En] forState:UIControlStateNormal];
    [self.itemPriceLabel setText:[_item itemPrice]];//[NSString stringWithFormat:@"%@ %@",[_item itemPrice],@"JOD"]];
    [self.itemImage setImage:_capturedImage];
    
//    if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
//        NSLog(@"user likes this");
//        [self.likeButton setImage:[UIImage imageNamed:@"icon-item-action-like-active"] forState:UIControlStateNormal];
//    }else {
//        [self.likeButton setImage:[UIImage imageNamed:@"icon-item-action-like"] forState:UIControlStateNormal];
//    }
//    
//    if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
//        NSLog(@"user wants this");
//        [self.wantButton setImage:[UIImage imageNamed:@"icon-item-action-want-active"] forState:UIControlStateNormal];
//    }else {
//        [self.wantButton setImage:[UIImage imageNamed:@"icon-item-action-want"] forState:UIControlStateNormal];
//    }
//    
//    if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
//        NSLog(@"user got this");
//        [self.gotButton setImage:[UIImage imageNamed:@"icon-item-action-got-active"] forState:UIControlStateNormal];
//    }else {
//        [self.gotButton setImage:[UIImage imageNamed:@"icon-item-action-got"] forState:UIControlStateNormal];
//    }
    
    [self.placeBigLabel setText:[_item venueName_En]];
    [self.placeItemCountLabel setText:[NSString stringWithFormat:@"See more items here (%@ items)",_venueItemCount]];
}

-(void)finishUpload
{
//    self.tabBarController.selectedIndex = 0;
//   [self.navigationController popToRootViewControllerAnimated:YES];
    if(self.editDelegate)
    {
        [self.editDelegate finishedEditItem];
    }else
    [self.delegate finishedAddItem];
}

- (void)viewDidUnload
{
    [self setItemImage:nil];
    [self setVenueNameBtn:nil];
    [self setItemPriceLabel:nil];
//    [self setGotButton:nil];
//    [self setWantButton:nil];
//    [self setLikeButton:nil];
    [self setPlaceBigLabel:nil];
    [self setPlaceItemCountLabel:nil];
//    [self setScrollView:nil];
    [self setProgressView:nil];
    [self setCapturedImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
   

    
    NSLog(@"user data: %@",[request userData]);
    NSNumber* uploaded = [NSNumber numberWithInteger:totalBytesWritten];
    NSNumber* total = [NSNumber numberWithInteger:totalBytesExpectedToWrite];
    float progress = ([uploaded floatValue] / [total floatValue] );
    NSLog(@"progress: %f", progress);
    [_progressView setProgress:progress animated:YES];
    if (progress == 1.0) {
//        [request setDelegate:nil];
        
    }
    NSLog(@"sent bytes: %d of %d",totalBytesWritten,totalBytesExpectedToWrite);
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
    NSLog(@"user data: %@ response: %@", [request userData],[response bodyAsString]);
    if ([[request userData] isEqual:@"uploadPhoto"]) {
        if(_facebookShare){
            [self shareOnFacebook];
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
 
    }
}

-(void)showPopup:(NSString*)sender
{
    NSLog(@"show action popup");
    UIImageView* actionPopup;
    if ([sender isEqualToString:@"like"]) {
        if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-like"]];
    } else if([sender isEqualToString:@"want"]){
        if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-want"]];       
    } else if([sender isEqualToString:@"got"]){
        if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-got"]];
    }else {
        return;
    }
    
    CGRect b = self.view.bounds;
    
    actionPopup.frame = CGRectMake((b.size.width - 0) / 2, (b.size.height - 0) / 2, 0, 0);
    [self.view addSubview: actionPopup];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    actionPopup.frame = CGRectMake((b.size.width - 113) / 2, (b.size.height - 113) / 2, 113, 113);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationCurveEaseOut animations:^{
        actionPopup.alpha = 0.0;} completion:^(BOOL finished){[actionPopup removeFromSuperview];}];
    
}

-(void)sendItemAction:(NSString*)sender
{
    NSLog(@"%@ item with id %@", sender, [_item itemID]);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [_item itemID], @"item",
                            [defaults objectForKey:@"userid"], @"id",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if ([sender isEqualToString:@"like"]) {
        if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
            [_item setILike:[NSNumber numberWithInt:0]];
            [[[RKClient sharedClient] delete:[@"/likeitem/" stringByAppendingQueryParameters:params] delegate:nil] setUserData:@"unlike"];
        }else {
            [_item setILike:[NSNumber numberWithInt:1]];
            [[RKClient sharedClient] post:@"/likeitem/" params:params delegate:nil];
        }
        
    } else if([sender isEqualToString:@"want"]){
        if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
            [_item setIWant:[NSNumber numberWithInt:0]];
            [[[RKClient sharedClient] delete:[@"/wantitem/" stringByAppendingQueryParameters:params] delegate:nil]  setUserData:@"unwant"];
        }else {
            [_item setIWant:[NSNumber numberWithInt:1]];
            [[RKClient sharedClient] post:@"/wantitem/" params:params delegate:nil];
        }
    } else if([sender isEqualToString:@"got"]){
        if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
            [_item setIGot:[NSNumber numberWithInt:0]];
            [[[RKClient sharedClient] delete:[@"/gotitem/" stringByAppendingQueryParameters:params] delegate:nil]  setUserData:@"ungot"];
        }else {
            [_item setIGot:[NSNumber numberWithInt:1]];
            [[RKClient sharedClient] post:@"/gotitem/" params:params delegate:nil];
        }
    }else {
        return;
    }
    
    [self configureView];
    
}


//- (IBAction)gotPressed:(id)sender {
//    [self performSelector:@selector(showPopup:) withObject:@"got"];
//    [self performSelector:@selector(sendItemAction:) withObject:@"got"];
//}
//
//- (IBAction)wantPressed:(id)sender {
//    [self performSelector:@selector(showPopup:) withObject:@"want"];
//    [self performSelector:@selector(sendItemAction:) withObject:@"want"];
//}
//
//- (IBAction)likePressed:(id)sender {
//    [self performSelector:@selector(showPopup:) withObject:@"like"];
//    [self performSelector:@selector(sendItemAction:) withObject:@"like"];
//}

- (IBAction)venueNamePressed:(id)sender {
    
}

-(void)shareOnFacebook{
    //    id<olgotOgItem> itemObject = [self itemObjectForItem];
    id<olgotOgItem> itemObject = [self itemObjectForItem:@"dummy"];
    
    id<olgotOgFindItem> action = (id<olgotOgFindItem>)[FBGraphObject graphObject];
    
    action.item = itemObject;
    
    [FBSettings setLoggingBehavior:[NSSet
                                    setWithObjects:FBLoggingBehaviorFBRequests,
                                    FBLoggingBehaviorFBURLConnections,
                                    nil]];
    
    // Create the request and post the action to the "me/fb_sample_scrumps:eat" path.
    [FBRequestConnection startForPostWithGraphPath:@"me/olgotapp:add"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     [self.view setUserInteractionEnabled:YES];
                                     
                                     NSString *alertText;
                                     if (!error) {
                                         alertText = [NSString stringWithFormat:@"Posted Open Graph action, id: %@",
                                                      [result objectForKey:@"id"]];
                                         
                                         
                                     } else {
                                         alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d",
                                                      error.domain, error.code];
                                     }
                                     
                                     NSLog(@"Facebook: %@",alertText);
                                     //                                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                     //                                                                 message:alertText
                                     //                                                                delegate:nil
                                     //                                                       cancelButtonTitle:@"Thanks!"
                                     //                                                       otherButtonTitles:nil]
                                     //                                      show];
                                 }];
    
    
}

- (id<olgotOgItem>)itemObjectForItem:(NSString*)mItem
{
    id<olgotOgItem> result = (id<olgotOgItem>)[FBGraphObject graphObject];
    
    result.url = _itemUrl;
    
    return result;
}

@end
