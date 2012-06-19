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
    UIButton *openLibraryButton;

}

@property (nonatomic, strong) id <olgotCameraOverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *openLibraryButton;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

// camera page (overlay view)
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;
-(IBAction)openLibrary:(id)sender;

@end

@protocol olgotCameraOverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;

@end
