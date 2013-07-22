//
//  PreviewItemImageViewController.m
//  Olgot
//
//  Created by Belal Jaradat on 7/8/13.
//  Copyright (c) 2013 Not Another Fruit. All rights reserved.
//

#import "PreviewItemImageViewController.h"

@interface PreviewItemImageViewController ()

@end

@implementation PreviewItemImageViewController
@synthesize slideShowImageViewScrollView = _slideShowImageViewScrollView;
@synthesize itemImage = _itemImage;
@synthesize itemTitle = _itemTitle;

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
    tapBarIsShown = YES;
    [itemImageView setImage:self.itemImage];
    CGRect frame = itemImageView.frame;
    frame.size = self.itemImage.size;
//    NSInteger var = self.view.frame.size.width - frame.size.width;
    
//    frame.size.width = self.view.frame.size.width;
//    frame.size.height = frame.size.height + var;
    
    [itemImageView setFrame:frame];
    itemImageView.center = self.view.center;
    frame = itemImageView.frame;
    frame.origin.y = frame.origin.y-self.navigationController.navigationBar.frame.size.height/2;
     [itemImageView setFrame:frame];
    if(!self.itemTitle || [self.itemTitle isEqualToString:@""])
        self.navigationItem.title = @"Preview";
        else
    self.navigationItem.title = self.itemTitle;
    
//    slideShowImageViewScrollView = (UIScrollView*)[cell viewWithTag:33];
    self.slideShowImageViewScrollView.maximumZoomScale = 4.0;
    self.slideShowImageViewScrollView.minimumZoomScale = 1.0;
    self.slideShowImageViewScrollView.clipsToBounds = YES;
    self.slideShowImageViewScrollView.delegate = self;
    self.slideShowImageViewScrollView.scrollEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(tapBarIsShown)
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//        tapBarIsShown = NO;
//    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        tapBarIsShown = YES;
//    }
//}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale!=1.0)
    {
        self.slideShowImageViewScrollView.scrollEnabled = YES;
    }
    else
    {
        self.slideShowImageViewScrollView.scrollEnabled = NO;
    }
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return itemImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
