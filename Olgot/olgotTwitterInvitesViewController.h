//
//  olgotTwitterInvitesViewController.h
//  Olgot
//
//  Created by Raed Hamam on 9/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotTwitterInviteCell.h"
#import <RestKit/RestKit.h>
#import "UIImageView+AFNetworking.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@protocol olgotTwitterInvitesDelegate;

@interface olgotTwitterInvitesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RKObjectLoaderDelegate>
{
    NSMutableArray* mPeople;
    
    id <olgotTwitterInvitesDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, retain) id <olgotTwitterInvitesDelegate> delegate;
- (IBAction)donePressed:(id)sender;
@property (strong, nonatomic) IBOutlet olgotTwitterInviteCell *mCell;

@end

@protocol olgotTwitterInvitesDelegate

-(void)finishedInvites;

@end
