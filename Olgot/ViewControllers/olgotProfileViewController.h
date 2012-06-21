//
//  olgotProfileViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import "olgotUser.h"
#import "SSPullToRefresh.h"

@interface olgotProfileViewController : SSCollectionViewController<RKObjectLoaderDelegate, SSPullToRefreshViewDelegate>{
    NSMutableArray* _items;
    olgotUser* _user;
    NSIndexPath* _selectedRowIndexPath;
    NSUserDefaults* defaults;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
}

@property (strong, nonatomic) NSNumber *userID;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *profileCardTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *profileItemTile;
- (IBAction)showFollowersAction:(id)sender;
- (IBAction)showFollowingAction:(id)sender;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end
