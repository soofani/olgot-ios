//
//  olgotCameraOverlayViewController.h
//  Olgot
//
//  Created by Raed Hamam on 8/16/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol olgotCameraOverlayViewControllerDelegate;

@interface olgotCameraOverlayViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    id <olgotCameraOverlayViewControllerDelegate> delegate;
    
    UIImagePickerController *imagePickerController;
    
@private
    UIButton *cancelButton;
    UIButton *takePictureButton;
}

@property (nonatomic, retain) id <olgotCameraOverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

// camera page (overlay view)
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@protocol olgotCameraOverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end