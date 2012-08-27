//
//  olgotCameraOverlayViewController.m
//  Olgot
//
//  Created by Raed Hamam on 8/16/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCameraOverlayViewController.h"

@interface olgotCameraOverlayViewController ()

@end

@implementation olgotCameraOverlayViewController
@synthesize cancelButton;
@synthesize takePictureButton;

@synthesize delegate, imagePickerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setTakePictureButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        
        self.imagePickerController.showsCameraControls = NO;

        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         self.view.frame.size.height,
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
    [self.delegate didFinishWithCamera];  // tell our delegate we are done with the camera
}

#pragma mark -
#pragma mark Camera Actions

- (IBAction)done:(id)sender
{
    // dismiss the camera

    [self finishAndUpdate];
}

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];
    
    [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
}

@end
