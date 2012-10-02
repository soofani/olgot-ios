//
//  ImageCropper.h
//  Olgot
//
//  Created by Raed Hamam on 9/20/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+WBImage.h"

@protocol ImageCropperDelegate;

@interface ImageCropper : UIViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIImageView *imageView;
    UIImage *rawImage;
    UIImage *filteredImage;
	UIImage *thumbImage;
    
    CIContext *context;
    
	id <ImageCropperDelegate> delegate;
    
    NSMutableArray *filterButtons;
    NSMutableArray *filtersArray;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;


@property (nonatomic, retain) id <ImageCropperDelegate> delegate;

- (id)initWithImage:(UIImage *)image;

@end

@protocol ImageCropperDelegate <NSObject>
- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image;
- (void)imageCropperDidCancel:(ImageCropper *)cropper;
@end
