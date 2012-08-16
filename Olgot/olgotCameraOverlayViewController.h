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

    
}

@property (nonatomic, retain) id <olgotCameraOverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;



@end

@protocol olgotCameraOverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end