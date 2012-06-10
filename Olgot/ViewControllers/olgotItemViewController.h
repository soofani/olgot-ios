//
//  olgotItemViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@class olgotItem;

@interface olgotItemViewController : SSCollectionViewController<RKObjectLoaderDelegate, UITextFieldDelegate>{
    SSCollectionViewItem *commentsHeader;
    NSArray* _likes;
    NSArray* _wants;
    NSArray* _gots;
    NSArray* _comments;
    NSIndexPath* _selectedRowIndexPath;
    
    UIView* myCommentView;
}
- (IBAction)showProfile:(id)sender;

@property (strong, nonatomic) NSNumber *itemID;
@property (strong, nonatomic) NSNumber *itemKey;
@property (nonatomic, strong) olgotItem *item;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *itemCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *finderCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *peopleRowCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsFooter;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *wantButton;
@property (strong, nonatomic) IBOutlet UIButton *gotButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

@property (strong, nonatomic) IBOutlet UIImageView *mySmallImage;
@property (strong, nonatomic) IBOutlet UITextField *myCommentTF;

- (IBAction)showVenue:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)wantAction:(id)sender;
- (IBAction)gotAction:(id)sender;

- (IBAction)touchedWriteComment:(id)sender;
- (IBAction)finishedComment:(id)sender;


@end
