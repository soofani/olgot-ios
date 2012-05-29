//
//  olgotLovelyViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@interface olgotLovelyViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    NSArray* _items;
    NSIndexPath* _selectedRowIndexPath;
}

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *itemTile;

@end
