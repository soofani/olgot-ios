//
//  olgotShareViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotShareViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

-(void) viewWillAppear:(BOOL)animated
{
    [self useCamera];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        //        imagePicker.mediaTypes = [NSArray arrayWithObjects:
        //                                  (NSString *) kUTTypeImage,
        //                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:NO];
        newMedia = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissModalViewControllerAnimated:NO];
    
    
    UIImage *image = [info 
                      objectForKey:UIImagePickerControllerOriginalImage];
    
    if (newMedia)
        UIImageWriteToSavedPhotosAlbum(image, 
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    
    [self performSegueWithIdentifier:@"ShowNearbyPlaces" sender:self];
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
