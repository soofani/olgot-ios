//
//  olgotCameraViewController.m
//  Olgot
//
//  Created by Raed Hamam on 8/29/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCameraViewController.h"
#import "olgotAddItemNearbyPlacesViewController.h"


@interface olgotCameraViewController ()

@end

@implementation olgotCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self){
        [self setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self setAllowsEditing:NO];
        [self setShowsCameraControls:NO];
        
        if ([[self.cameraOverlayView subviews] count] == 0)
        {
            olgotCameraOverlayViewController *mOverlay = [[olgotCameraOverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:[NSBundle mainBundle]];

            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect newFrame = CGRectMake(0.0f,
                                         0.0f,
                                         320.0f,
                                         480.0f);
            self.view.frame = newFrame;
            
            [self.cameraOverlayView addSubview:mOverlay.view];
        }

    }
    return self;
}

-(void)openLibrary{
    NSLog(@"Library");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
