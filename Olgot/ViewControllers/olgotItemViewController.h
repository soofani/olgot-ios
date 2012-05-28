//
//  olgotItemViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>

@class olgotItem;

@interface olgotItemViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    SSCollectionViewItem *commentsHeader;
    NSArray* _likes;
    NSArray* _wants;
    NSArray* _gots;
}

@property (nonatomic, strong) olgotItem *item;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *itemCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *finderCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *peopleRowCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsHeader;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentCell;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *commentsFooter;

- (IBAction)showVenue:(id)sender;

@end
