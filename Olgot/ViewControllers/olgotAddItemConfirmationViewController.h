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


@class olgotItem;

@protocol addItemConfirmationProtocol;
@protocol olgotEditItemProtocol;


@interface olgotAddItemConfirmationViewController : UIViewController<RKObjectLoaderDelegate>
{
    IBOutlet SSLineView *line1;
    IBOutlet SSLineView *line2;
    
    olgotItem* _item;
    
    id<addItemConfirmationProtocol> delegate;
          id <olgotEditItemProtocol> editDelegate;
}

@property (nonatomic,retain) id <addItemConfirmationProtocol> delegate;
@property (nonatomic,retain) id <olgotEditItemProtocol> editDelegate;

@property (nonatomic, assign) BOOL facebookShare;

//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) UIImage *capturedImage;

@property (strong, nonatomic) NSNumber *itemID;
@property (strong, nonatomic) NSString *itemKey;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *itemUrl;
@property (strong, nonatomic) NSNumber *venueID;
@property (strong, nonatomic) NSString *venueName;
@property (strong, nonatomic) NSNumber *venueItemCount;


@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UIButton *venueNameBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLabel;
//@property (strong, nonatomic) IBOutlet UIButton *gotButton;
//@property (strong, nonatomic) IBOutlet UIButton *wantButton;
//@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) IBOutlet UILabel *placeBigLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeItemCountLabel;

//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *waitingIndicator;
//@property (strong, nonatomic) IBOutlet UILabel *waitingUploadLabel;

//- (IBAction)gotPressed:(id)sender;
//- (IBAction)wantPressed:(id)sender;
//- (IBAction)likePressed:(id)sender;
- (IBAction)venueNamePressed:(id)sender;

@end

@protocol olgotEditItemProtocol

-(void)finishedEditItem;

@end

@protocol addItemConfirmationProtocol

-(void)finishedAddItem;

@end