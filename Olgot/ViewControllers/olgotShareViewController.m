//
//  olgotShareViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotShareViewController.h"
#import "olgotAddItemNearbyPlacesViewController.h"

@interface olgotShareViewController ()

@end

@implementation olgotShareViewController

@synthesize overlayViewController,image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void) viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//
//    
//}

-(void)loadView
{
    [super loadView];
    
    self.overlayViewController =
    [[olgotCameraOverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overlayViewController.delegate = self;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self takePicture:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.overlayViewController = nil;
    self.image = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (IBAction)takePicture:(id)sender {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
//    {
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        [imagePicker setAllowsEditing:YES];
//    }
//    else 
//    {
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//    
//    [imagePicker setDelegate:self];
//    
//    [self presentModalViewController:imagePicker animated:NO];
//}

- (IBAction)takePicture:(id)sender {
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayViewController.imagePickerController animated:NO];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowNearbyPlaces"]) {
        olgotAddItemNearbyPlacesViewController *nearbyController = [segue destinationViewController];
        
        nearbyController.capturedImage = image;
    }
}



//#pragma mark UIImagePickerDelegate
//
//-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    image = [info objectForKey:UIImagePickerControllerEditedImage];
//    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    if ([[defaults objectForKey:@"autoSavePhotos"] isEqual:@"yes"] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    }
//    
//    [self performSegueWithIdentifier:@"ShowNearbyPlaces" sender:self];
//    [self dismissModalViewControllerAnimated:NO];
//}
//
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self.tabBarController setSelectedIndex:0];
//    [self dismissModalViewControllerAnimated:NO];
//}

#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    self.image = picture;
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self.tabBarController setSelectedIndex:0];
    [self dismissModalViewControllerAnimated:NO];
    
}


@end
