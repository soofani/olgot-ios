//
//  olgotCustomAnnotationView.h
//  Olgot
//
//  Created by Raed Hamam on 7/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "olgotItemLocation.h"

#define kHeight 50
#define kWidth 50
#define kBorder 2

@interface olgotCustomAnnotationView : MKAnnotationView
{
    
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSNumber *itemID;
@property (nonatomic, retain) NSNumber *itemKey;

@end
