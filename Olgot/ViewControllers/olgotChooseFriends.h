//
//  olgotChooseFriends.h
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@interface olgotChooseFriends : SSCollectionViewController<RKObjectLoaderDelegate>
{
    NSArray* _myFriends;
    NSIndexPath* _selectedRowIndexPath;
}

@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *headerCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *personCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *footerCell;


@end
