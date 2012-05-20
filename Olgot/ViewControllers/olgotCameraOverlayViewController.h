//
//  olgotCameraOverlayViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol olgotCameraOverlayViewControllerDelegate;

@interface olgotCameraOverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <olgotCameraOverlayViewControllerDelegate> delegate;
    
    UIImagePickerController *imagePickerController;
    
@private
    UIButton *takePictureButton;
    UIButton *cancelButton;
    
//    UIBarButtonItem *takePictureButton;
    UIBarButtonItem *startStopButton;
    UIBarButtonItem *timedButton;
//    UIBarButtonItem *cancelButton;
    
    NSTimer *tickTimer;
    NSTimer *cameraTimer;
}

@property (nonatomic, strong) id <olgotCameraOverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

//@property (nonatomic, retain) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *timedButton;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic, retain) NSTimer *tickTimer;
@property (nonatomic, retain) NSTimer *cameraTimer;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

// camera page (overlay view)
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)startStop:(id)sender;
- (IBAction)timedTakePhoto:(id)sender;

@end

@protocol olgotCameraOverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;

@end
