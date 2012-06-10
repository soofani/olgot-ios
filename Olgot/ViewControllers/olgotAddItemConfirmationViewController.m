//
//  olgotAddItemConfirmationViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemConfirmationViewController.h"

@interface olgotAddItemConfirmationViewController ()

@end

@implementation olgotAddItemConfirmationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *finishImage30 = [UIImage imageNamed:@"btn-nav-finish"];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    finishBtn.frame=CGRectMake(0,0,50,30);
    [finishBtn setBackgroundImage:finishImage30 forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishUpload) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
}

-(void)finishUpload
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
