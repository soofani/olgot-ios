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

@interface olgotCommentsListViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    NSArray* _comments;
    NSIndexPath* _selectedRowIndexPath;
}

@property (strong, nonatomic) NSNumber *itemID;
@property (strong, nonatomic) NSNumber *commentsNumber;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsListHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentCell;


@end
