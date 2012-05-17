//
//  olgotExploreViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>

@interface olgotExploreViewController : SSCollectionViewController

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *boardBigTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *boardNormalTile;

@end
