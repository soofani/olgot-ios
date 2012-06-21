//
//  olgotAddItemConfirmationViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import "UIImageView+AFNetworking.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@class olgotItem;

@interface olgotAddItemConfirmationViewController : UIViewController<RKObjectLoaderDelegate>
{
    IBOutlet SSLineView *line1;
    IBOutlet SSLineView *line2;
    
    NSArray* accountsArray;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSString *itemKey;
@property (strong, nonatomic) NSNumber *venueID;
@property (strong, nonatomic) NSNumber *venueItemCount;
@property (nonatomic, strong) olgotItem *item;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UIButton *venueNameBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *gotButton;
@property (strong, nonatomic) IBOutlet UIButton *wantButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) IBOutlet UILabel *placeBigLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeItemCountLabel;

- (IBAction)gotPressed:(id)sender;
- (IBAction)wantPressed:(id)sender;
- (IBAction)likePressed:(id)sender;
- (IBAction)venueNamePressed:(id)sender;



@end
