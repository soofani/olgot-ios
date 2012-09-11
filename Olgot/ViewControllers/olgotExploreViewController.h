//
//  olgotExploreViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SSPullToRefresh.h"
#import "olgotSignupRootViewController.h"

@interface olgotExploreViewController : SSCollectionViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate,SSPullToRefreshViewDelegate>{
    NSString *firstRun;
    NSArray* _categories;
    NSIndexPath* _selectedRowIndexPath;
    NSUserDefaults* defaults;
    CLLocationManager* locationManager;
    NSString* feedImage;
    NSString* feedSummary;
    NSString* nearbyImage;
    NSString* wantsImage;
    
    UIButton* noteButton;
    
    BOOL loadingCategories;
    
    NSDate *updateTime;
    
}

@property (nonatomic, strong) olgotSignupRootViewController *signupRootVC;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *boardBigTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *boardNormalTile;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end
