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

@interface olgotAddItemNearbyPlacesViewController : SSCollectionViewController <RKObjectLoaderDelegate>
{
    NSArray* _places;
    NSIndexPath* _selectedRowIndexPath;
}

@property (nonatomic, strong) IBOutlet SSCollectionViewItem *placeCell;
@property (strong, nonatomic) UIImage *capturedImage;

@end
