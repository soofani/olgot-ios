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
#import "SSPullToRefresh.h"
#import <CoreLocation/CoreLocation.h>

@interface olgotLovelyViewController : SSCollectionViewController<RKObjectLoaderDelegate, SSPullToRefreshViewDelegate, CLLocationManagerDelegate>{
    NSMutableArray* _items;
    NSIndexPath* _selectedRowIndexPath;
    
    CLLocationManager* locationManager;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
}

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *itemTile;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) UIActivityIndicatorView* loadingMoreView;

@end
