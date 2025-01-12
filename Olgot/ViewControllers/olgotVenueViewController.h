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
#import "SSPullToRefresh.h"

#import "olgotAddItemDetailsViewController.h"
#import "olgotCameraOverlayViewController.h"

#import "ImageCropper.h"
#import "UIImage+fixOrientation.h"

@interface olgotVenueViewController : SSCollectionViewController<RKObjectLoaderDelegate, SSPullToRefreshViewDelegate,olgotCameraOverlayViewControllerDelegate, addItemDetailsProtocol, ImageCropperDelegate>{
    olgotVenue* _venue;
    NSMutableArray* _items;
    NSIndexPath* _selectedRowIndexPath;
    
    UIImage *image;
    
    int _pageSize;
    int _currentPage;
    BOOL loadingNew;
//    BOOL hasTopUser;
}

@property (nonatomic,retain) olgotCameraOverlayViewController *cameraOverlayViewController;

@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueCardTile;
@property (nonatomic, strong) IBOutlet SSCollectionViewItem *venueItemTile;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (strong, nonatomic) IBOutlet UIButton *venueLocationBtn;
@property (strong, nonatomic) IBOutlet UIButton *venueMapButton;
@property (strong, nonatomic) IBOutlet UILabel *venueAddressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *venueIconImageView;
//@property (strong, nonatomic) IBOutlet UIImageView *venueUserProfileImageView;
//@property (strong, nonatomic) IBOutlet UIImageView *topUserImage;
//@property (strong, nonatomic) IBOutlet UIButton *topUserName;
//@property (strong, nonatomic) IBOutlet UILabel *topUserItems;
//@property (strong, nonatomic) IBOutlet UILabel *topUserLabel;


- (IBAction)showVenueMap:(id)sender;
- (IBAction)userPressed:(id)sender;

@end
