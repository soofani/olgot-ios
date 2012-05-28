//
//  DTCustomColoredAccessory.h
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end
