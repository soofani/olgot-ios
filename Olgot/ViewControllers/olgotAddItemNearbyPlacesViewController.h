//
//  olgotAddItemNearbyPlacesViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface olgotAddItemNearbyPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *placeNames;
}

@property (strong, nonatomic) NSArray *placeNames;

@end
