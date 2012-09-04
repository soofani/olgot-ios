//
//  olgotAddItemDetailsViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotVenue.h"
#import <RestKit/RestKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "olgotAddItemConfirmationViewController.h"

@interface olgotAddItemDetailsViewController : UIViewController<RKObjectLoaderDelegate, UITextFieldDelegate, addItemConfirmationProtocol>
{
    UIImageView *itemImageView;
    NSNumber* _itemID;
    NSString* _itemKey;
    NSString* _itemUrl;
    
    NSArray* accountsArray;
    
    BOOL twitterShare;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *venueImageIV;
@property (strong, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *venueLocationLabel;
@property (strong, nonatomic) IBOutlet UITextField *itemPriceTF;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTF;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@property (nonatomic, retain) olgotVenue* venue;
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic,strong) UIImage *itemImage;
           
- (IBAction)addedPrice:(id)sender;
- (IBAction)addedDescription:(id)sender;
- (IBAction)postButtonPressed:(id)sender;

- (IBAction)editPrice:(id)sender;
- (IBAction)editDescription:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *twitterShareBtn;
- (IBAction)twitterSharePressed:(id)sender;

@end
