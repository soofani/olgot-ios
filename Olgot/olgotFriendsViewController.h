//
//  olgotFriendsViewController.h
//  Olgot
//
//  Created by Raed Hamam on 7/24/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@protocol olgotFriendsViewDelegate;

@interface olgotFriendsViewController : SSCollectionViewController<RKObjectLoaderDelegate,UIActionSheetDelegate>{
    NSArray* _myFriends;
    NSIndexPath* _selectedRowIndexPath;
    
    id <olgotFriendsViewDelegate> delegate;
}

@property (nonatomic, retain) id <olgotFriendsViewDelegate> delegate;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *headerCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *footerCell;

@end


@protocol olgotFriendsViewDelegate

-(void)showInviteTwitter;
-(void)showInviteFacebook;
-(void)dismissFriendsView;

@end