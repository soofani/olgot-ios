//
//  olgotCameraOverlayViewController.m
//  Olgot
//
//  Created by Raed Hamam on 8/16/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCameraOverlayViewController.h"

@implementation olgotCameraOverlayViewController

@synthesize shootBtn;
@synthesize libraryBtn;
@synthesize closeBtn;
@synthesize flashBtn;
@synthesize imagePickerController;                                                       
@synthesize delegate;
@synthesize bottomImageView;


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

    [self setShootBtn:nil];
    [self setLibraryBtn:nil];
    [self setCloseBtn:nil];
    [self setFlashBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return NO;
//}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    
    @try {
        self.imagePickerController.sourceType = sourceType;
  

    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {

        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = NO;
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            
            CGRect frame = self.view.frame;
            CGRect frame2 = self.imagePickerController.cameraOverlayView.frame;
            frame.size.height = frame2.size.height;
            frame.origin.y = 0;
            [self.view setFrame:frame];
            
            if(self.view.frame.size.height >= 500)
            {
                [self.bottomImageView setFrame:CGRectMake(0, self.bottomImageView.frame.origin.y-42, self.bottomImageView.frame.size.width, self.bottomImageView.frame.size.height + 42.0)];
                [self.shootBtn setCenter:self.bottomImageView.center];
                [self.libraryBtn setFrame:CGRectMake(self.libraryBtn.frame.origin.x, self.bottomImageView.center.y-self.libraryBtn.frame.size.height/2, self.libraryBtn.frame.size.width, self.libraryBtn.frame.size.height)];
                
            }
//            frame2.size.height = 600;
//            [self.imagePickerController.cameraOverlayView setFrame:frame2];
//            self.imagePickerController.navigationBarHidden = YES;
//            self.imagePickerController.wantsFullScreenLayout = YES;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
        
        [self configureFlashButton];
    }
    
        }
    @catch (NSException *exception) {
        NSLog(@"Open Cam ERROR %@", exception.reason);
    }
    //    @finally {
    //
    //    }
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
 
//    UIImage *cropImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(320.0f, 320.0f)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"autoSavePhotos"] isEqual:@"yes"] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    NSLog(@"image size %f,%f",image.size.width, image.size.height);
    
    [self.delegate tookPicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate cancelled];
}

- (IBAction)shootAction:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)libraryAction:(id)sender {
    [self.delegate wantsLibrary];
}

- (IBAction)closeAction:(id)sender {
    [self.delegate cancelled];
}

- (IBAction)flashAction:(id)sender {
    if ([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeAuto) {
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
    } else if([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeOn) {
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    } else if([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeOff) {
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
    }
    
    [self configureFlashButton];
    
}

-(void)configureFlashButton{
    if ([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeAuto) {
            [self.flashBtn setImage:[UIImage imageNamed:@"btn-cam-flash-off"] forState:UIControlStateNormal];
        [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    } else if([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeOn) {
        [self.flashBtn setImage:[UIImage imageNamed:@"btn-cam-flash-on"] forState:UIControlStateNormal];
           [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
    } else if([self.imagePickerController cameraFlashMode] == UIImagePickerControllerCameraFlashModeOff) {
        [self.flashBtn setImage:[UIImage imageNamed:@"btn-cam-flash-off"] forState:UIControlStateNormal];
           [self.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    }
    NSLog(@"flash: %d",[self.imagePickerController cameraFlashMode]);
}
@end
