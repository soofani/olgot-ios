//
//  olgotAddItemNearbyPlacesViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SSToolkit/SSToolkit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol addItemNearbyProtocol;

@interface olgotAddItemNearbyPlacesViewController : SSCollectionViewController <RKObjectLoaderDelegate,CLLocationManagerDelegate, UISearchBarDelegate>
{
    NSMutableArray* _places;
    NSIndexPath* _selectedRowIndexPath;
    CLLocationManager* locationManager;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
    
    id <addItemNearbyProtocol> delegate;
}

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *placeCell;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,retain) id <addItemNearbyProtocol> delegate;

@end

@protocol addItemNearbyProtocol

-(void)wantsBack;
-(void)exitAddItemFlow;

@end