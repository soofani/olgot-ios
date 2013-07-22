//
//  olgotCommentsListViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/24/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import "SSPullToRefresh.h"

@interface olgotCommentsListViewController : SSCollectionViewController<RKObjectLoaderDelegate, SSPullToRefreshViewDelegate>{
    NSMutableArray* _comments;
    NSIndexPath* _selectedRowIndexPath;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
    BOOL addedComment;
    
    UIView* myCommentView;
}

@property (strong, nonatomic) NSNumber *itemID;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *commentsNumber;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsListHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentCell;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@property (strong, nonatomic) IBOutlet UIImageView *mySmallImage;
@property (strong, nonatomic) IBOutlet UITextField *myCommentTF;

- (IBAction)touchedWriteComment:(id)sender;
- (IBAction)finishedComment:(id)sender;

@end
