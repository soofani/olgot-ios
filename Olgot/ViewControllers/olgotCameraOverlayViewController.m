//
//  olgotCameraOverlayViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCameraOverlayViewController.h"

enum
{
    kOneShot,       // user wants to take a delayed single shot
    kRepeatingShot  // user wants to take repeating shots
};

@interface olgotCameraOverlayViewController ()

@end

@implementation olgotCameraOverlayViewController

@synthesize delegate, takePictureButton,
cancelButton, imagePickerController, openLibraryButton,flashButton;

#pragma mark -
#pragma mark OverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidUnload
{
    self.takePictureButton = nil;
    self.cancelButton = nil;
    self.openLibraryButton = nil;
    self.flashButton = nil;
    self.imagePickerController = nil;
    [super viewDidUnload];
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = NO;
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
//            CGRect newFrame = CGRectMake(0.0,
//                                         CGRectGetHeight(overlayViewFrame) -
//                                         self.view.frame.size.height - 10.0,
//                                         CGRectGetWidth(overlayViewFrame),
//                                         self.view.frame.size.height + 10.0);
            
            CGRect newFrame = CGRectMake(0.0,
                                        0.0,
                                         CGRectGetWidth(overlayViewFrame),
                                         self.view.frame.size.height);
            
            self.view.frame = newFrame;
            
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
}

// update the UI after an image has been chosen or picture taken
//
- (void)finishAndUpdate
{
    NSLog(@"finish and update");
    [self.delegate didFinishWithCamera];  // tell our delegate we are done with the camera
}

#pragma mark -
#pragma mark Camera Actions

- (IBAction)done:(id)sender
{
    NSLog(@"pressed done/cancel button");
    // dismiss the camera
    [self finishAndUpdate];
}

- (IBAction)takePhoto:(id)sender
{
    NSLog(@"Pressed camera button");
    [self.imagePickerController takePicture];
}

-(IBAction)openLibrary:(id)sender
{
    NSLog(@"open library");
    UIImagePickerController* libraryPicker = [[UIImagePickerController alloc] init];
    libraryPicker.delegate = self;
    libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:libraryPicker animated:YES];
}

-(IBAction)changeFlash:(id)sender
{
    if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
        
        [self.flashButton setImage:[UIImage imageNamed:@"btn-cam-flash-on"] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"btn-cam-flash-off"] forState:UIControlStateSelected];
        

    }else if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
        
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        
        [self.flashButton setImage:[UIImage imageNamed:@"btn-cam-flash-off"] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"btn-cam-flash-on"] forState:UIControlStateSelected];
        
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finished picking media with info %@",info);
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];
    
//    if (![self.cameraTimer isValid])
        [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"image picker controller did cancel");
    [self dismissViewControllerAnimated:YES completion:^(void){
//            [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
        NSLog(@"cancelled library option");
    }];
    
}

@end
