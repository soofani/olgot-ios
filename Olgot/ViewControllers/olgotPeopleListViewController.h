//
//  olgotPeopleListViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@interface olgotPeopleListViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    NSMutableArray* _userActions;
    NSIndexPath* _selectedRowIndexPath;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
}

@property (strong, nonatomic) NSNumber *itemID;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSNumber *actionStats;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personListHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personCell;

@end
