//
//  UIImage+WBImage.h
//  Olgot
//
//  Created by Raed Hamam on 9/20/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#ifndef WBIMAGE_H
#define WBIMAGE_H

#import <UIKit/UIKit.h>

@interface UIImage (WBImage)

// rotate UIImage to any angle
-(UIImage*)rotate:(UIImageOrientation)orient;

// rotate and scale image from iphone camera
-(UIImage*)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize;

// scale this image to a given maximum width and height
-(UIImage*)scaleWithMaxSize:(CGFloat)maxSize;
-(UIImage*)scaleWithMaxSize:(CGFloat)maxSize
                    quality:(CGInterpolationQuality)quality;

@end

#endif  // WBIMAGE_H