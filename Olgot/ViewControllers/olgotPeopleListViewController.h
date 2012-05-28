//
//  olgotPeopleListViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>

@interface olgotPeopleListViewController : SSCollectionViewController

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personListHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personCell;

@end
