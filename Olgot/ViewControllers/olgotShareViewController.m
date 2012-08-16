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
    [self takePicture:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];
    }
    else 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ShowNearbyPlaces"]) {
        olgotAddItemNearbyPlacesViewController *nearbyController = [segue destinationViewController];
        
        nearbyController.capturedImage = image;
    }
}

#pragma mark UIImagePickerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"autoSavePhotos"] isEqual:@"yes"] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self performSegueWithIdentifier:@"ShowNearbyPlaces" sender:self];
    [self dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.tabBarController setSelectedIndex:0];
    [self dismissModalViewControllerAnimated:NO];
}

@end
