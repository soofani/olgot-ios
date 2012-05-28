//
//  olgotSignupRootViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotSignupRootViewController.h"

@interface olgotSignupRootViewController ()

@end

@implementation olgotSignupRootViewController

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
       
    //title logo
//    UIImage *titleImage = [UIImage imageNamed:@"logo-140x74"];
//    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
//    [self.navigationController.navigationBar.topItem setTitleView:titleImageView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (IBAction)hideSignup:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
