//
//  olgotEditItemViewController.m
//  Olgot
//
//  Created by Belal Jaradat on 9/26/13.
//  Copyright (c) 2013 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotVenue.h"
#import <RestKit/RestKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "olgotAddItemConfirmationViewController.h"
#import "olgotAppDelegate.h"
#import "MBProgressHUD.h"
#import "olgotItem.h"

@protocol addItemDetailsProtocol;
@protocol olgotEditItemProtocol;

@interface olgotEditItemViewController : UIViewController<RKObjectLoaderDelegate, UITextFieldDelegate, addItemNearbyProtocol, addItemConfirmationProtocol, olgotTwitterDelegate,olgotFacebookDelegate, olgotCameraOverlayViewControllerDelegate, ImageCropperDelegate, UITextViewDelegate>
{
    UIImageView *itemImageView;
//    NSNumber* _itemID;
//    NSString* _itemKey;
//    NSString* _itemUrl;
    
    MBProgressHUD *loadingUi;
    
    NSArray* accountsArray;
    
    BOOL twitterShare;
    BOOL facebookShare;
    
    id <addItemDetailsProtocol> delegate;
       id <olgotEditItemProtocol> editDelegate;
}
@property (strong, nonatomic) olgotItem *itemToView;
@property (nonatomic,retain) olgotCameraOverlayViewController *cameraOverlayViewController;

@property (nonatomic, retain) id <addItemDetailsProtocol> delegate;
@property (nonatomic, retain) id <olgotEditItemProtocol> editDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *whereTxtField;

//@property (strong, nonatomic) IBOutlet UIImageView *venueImageIV;
//@property (strong, nonatomic) IBOutlet UILabel *venueNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *venueLocationLabel;
//@property (strong, nonatomic) IBOutlet UITextField *itemPriceTF;
@property (nonatomic, strong) IBOutlet UIImageView *itemsBgImageView;
@property (nonatomic, strong) IBOutlet UIView *expandableView;
@property (strong, nonatomic) IBOutlet UITextView *itemPriceTF;
@property (strong, nonatomic) IBOutlet UITextField *itemNameTF;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTF;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@property (nonatomic, retain) olgotVenue* venue;
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic,strong) UIImage *itemImage;

-(IBAction)openLocationViewPressed:(id)sender;
-(IBAction)editImagePressed:(id)sender;
//- (IBAction)addedPrice:(id)sender;
- (IBAction)addedName:(id)sender;
- (IBAction)addedDescription:(id)sender;
- (IBAction)postButtonPressed:(id)sender;

//- (IBAction)editPrice:(id)sender;
//- (IBAction)editItemName:(id)sender;
- (IBAction)editDescription:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *twitterShareBtn;
- (IBAction)twitterSharePressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookShareBtn;
- (IBAction)facebookSharePressed:(id)sender;

@end


