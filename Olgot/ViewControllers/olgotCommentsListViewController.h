//
//  olgotCommentsListViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/24/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>

@interface olgotCommentsListViewController : SSCollectionViewController

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsListHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentCell;

@end
