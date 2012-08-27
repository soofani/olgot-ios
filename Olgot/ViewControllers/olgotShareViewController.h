//
//  olgotShareViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotCameraOverlayViewController.h"

@interface olgotShareViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,olgotCameraOverlayViewControllerDelegate>
{
    UIImage *image;
    
    olgotCameraOverlayViewController *overlayViewController; // the camera custom overlay view
}



- (IBAction)takePicture:(id)sender;

@property (nonatomic,retain) UIImage *image;
@property (nonatomic, retain) olgotCameraOverlayViewController *overlayViewController;

@end
