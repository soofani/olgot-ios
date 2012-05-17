//
//  olgotVenueViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>

@interface olgotVenueViewController : SSCollectionViewController

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueCardTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueItemTile;

@end
