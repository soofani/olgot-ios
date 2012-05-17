//
//  olgotMapViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotMapViewController.h"

@interface olgotMapViewController ()

@end

@implementation olgotMapViewController

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
    
    UIImage *boardImage30 = [UIImage imageNamed:@"btn-nav-board"];
    
    UIButton *boardBtn = [[UIButton alloc] init];
    boardBtn.frame=CGRectMake(0,0,35,30);
    [boardBtn setBackgroundImage:boardImage30 forState:UIControlStateNormal];
    [boardBtn addTarget:self action:@selector(showBoardView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:boardBtn];
}

- (void)showBoardView
{
//    [self performSegueWithIdentifier:@"ShowBoardView" sender:self];
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

- (IBAction)dismissMap:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
