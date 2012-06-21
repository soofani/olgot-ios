//
//  olgotVenueViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import "olgotVenue.h"

@interface olgotVenueViewController : SSCollectionViewController<RKObjectLoaderDelegate>{
    olgotVenue* _venue;
    NSMutableArray* _items;
    NSIndexPath* _selectedRowIndexPath;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
}

@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueCardTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueItemTile;

@end
