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

@interface olgotProfileViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    NSArray* _items;
    olgotUser* _user;
    NSIndexPath* _selectedRowIndexPath;
    NSUserDefaults* defaults;
}

@property (strong, nonatomic) NSNumber *userID;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *profileCardTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *profileItemTile;

@end
