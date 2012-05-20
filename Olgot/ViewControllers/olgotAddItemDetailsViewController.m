//
//  olgotAddItemDetailsViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface olgotAddItemDetailsViewController ()

@end

@implementation olgotAddItemDetailsViewController

@synthesize itemImageView;

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
    whyCoolTF.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:78.0/255.0 blue:32.0/255.0 alpha:1.0] CGColor];
    whyCoolTF.layer.borderWidth = 1.0f;
    
    whyCoolTF.layer.cornerRadius = 5;
    whyCoolTF.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    whyCoolTF = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
