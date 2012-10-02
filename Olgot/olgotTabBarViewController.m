//
//  olgotTabBarViewController.m
//  Olgot
//
//  Created by Raed Hamam on 8/28/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotTabBarViewController.h"
#import "olgotShareViewController.h"
#import "olgotCameraViewController.h"


@interface olgotTabBarViewController ()

@end

@implementation olgotTabBarViewController

@synthesize cameraOverlayViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSLog(@"switched to: %@", [item title]);
//    if ([[item title] isEqual:@"Share"]) {
//        
//        olgotShareViewController *shareController = (olgotShareViewController*)[[self viewControllers] objectAtIndex:2];
//        
//        NSLog(@"the second one");
//        UIImagePickerController* myPicker = [[UIImagePickerController alloc] init];
//        [myPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        [myPicker setAllowsEditing:YES];
//        [myPicker setDelegate:shareController];
//        
//        [self presentModalViewController:myPicker animated:NO];
//        
//    }
//    
//}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage
{
    NSLog(@"subview %d", [[self.tabBar subviews] count]);
    if ([[self.tabBar subviews] count] == 7 || [[self.tabBar subviews] count] == 8) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        button.frame = CGRectMake(0.0, 0.0, 65.0, 58.0);
        [button setBackgroundImage:[UIImage imageNamed:@"btn-share-130x116"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn-share-130x116"] forState:UIControlStateHighlighted];
        
        CGFloat heightDifference = 58.0 - self.tabBar.frame.size.height;
        
        if (heightDifference < 0){
            button.center = self.tabBar.center;
        }else{
            CGPoint center = self.tabBar.center;
            center.y =self.tabBar.frame.size.height-(58.0/2.0) + 2.0;
            button.center = center;
        }
        
        // action for this button
        [button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
}

-(void)buttonEvent{
    
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

-(void)showCamAnimated:(BOOL)animated source:(UIImagePickerControllerSourceType)sourceType
{
//    olgotCameraViewController* myCam = [[olgotCameraViewController alloc] init];
//    [myCam setDelegate:self];
//    [self presentModalViewController:myCam animated:animated];
    self.cameraOverlayViewController = [[olgotCameraOverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
    self.cameraOverlayViewController.delegate = self;
    
    [self.cameraOverlayViewController setupImagePicker:sourceType];
    [self presentModalViewController:self.cameraOverlayViewController.imagePickerController animated:animated];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
//    NSLog(@"Took photo");
    
    
//    [self pushViewController:nearbyController animated:YES];
    //    [self dismissModalViewControllerAnimated:YES];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
}

#pragma mark - olgotCameraOverlayControllerDelegate

-(void)tookPicture:(UIImage *)image
{
    UIImage* orImage = [image fixOrientation];
    
    
    
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:orImage];
	[cropper setDelegate:self];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:cropper animated:NO];
}

-(void)cancelled
{
    [self dismissModalViewControllerAnimated:NO];
    NSLog(@"cancelled");
}

-(void)wantsLibrary
{
    [self dismissModalViewControllerAnimated:NO];
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - olgotTrimEffectsDelegate

- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)editedImage
{
    olgotAddItemNearbyPlacesViewController* nearbyController = [[olgotAddItemNearbyPlacesViewController alloc] init];
    
    nearbyController.capturedImage = editedImage;
    nearbyController.delegate = self;
    
    UINavigationController *camNavController = [[UINavigationController alloc] initWithRootViewController:nearbyController];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:camNavController animated:NO];
}

- (void)imageCropperDidCancel:(ImageCropper *)cropper {
	[self dismissModalViewControllerAnimated:NO];
	
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - addItemNearbyDelegate

-(void)wantsBack
{
    [self dismissModalViewControllerAnimated:NO];
    [self showCamAnimated:NO source:UIImagePickerControllerSourceTypeCamera];
}

-(void)exitAddItemFlow
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
