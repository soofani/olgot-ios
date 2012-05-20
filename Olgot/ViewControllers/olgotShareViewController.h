//
//  olgotShareViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotCameraOverlayViewController.h"
#import "olgotAddItemDetailsViewController.h"

@interface olgotShareViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, olgotCameraOverlayViewControllerDelegate>
{
    UIImageView *imageView;
//    UIToolbar *myToolbar;
    
    NSMutableArray *capturedImages; // the list of images captures from the camera (either 1 or multiple)
    
    BOOL newMedia;
    olgotCameraOverlayViewController *mOverlayController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
//@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;

@property (nonatomic, retain) NSMutableArray *capturedImages;

@property (nonatomic, retain) olgotCameraOverlayViewController *mOverlayViewController;

-(void)useCamera;

// toolbar buttons
- (IBAction)photoLibraryAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

@end
