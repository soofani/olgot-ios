//
//  olgotCameraOverlayViewController.h
//  Olgot
//
//  Created by Raed Hamam on 8/16/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol olgotCameraOverlayViewControllerDelegate;

@interface olgotCameraOverlayViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    id <olgotCameraOverlayViewControllerDelegate> delegate;
    
    UIImagePickerController *imagePickerController;
    
}

@property (nonatomic, retain) id <olgotCameraOverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@property (strong, nonatomic) IBOutlet UIButton *shootBtn;
@property (strong, nonatomic) IBOutlet UIButton *libraryBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIButton *flashBtn;

- (IBAction)shootAction:(id)sender;
- (IBAction)libraryAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)flashAction:(id)sender;

@end

@protocol olgotCameraOverlayViewControllerDelegate
-(void)tookPicture:(UIImage*)image;
-(void)cancelled;
-(void)wantsLibrary;
@end