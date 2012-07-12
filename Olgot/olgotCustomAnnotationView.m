//
//  olgotCustomAnnotationView.m
//  Olgot
//
//  Created by Raed Hamam on 7/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotCustomAnnotationView.h"
#import "UIImageView+AFNetworking.h"

@implementation olgotCustomAnnotationView

@synthesize imageView = _imageView;
@synthesize itemID = _itemID;
@synthesize itemKey = _itemKey;

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    olgotItemLocation* mAnnotation = (olgotItemLocation*)annotation;
    
    _itemID = mAnnotation.itemID;
    _itemKey = mAnnotation.itemKey;
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setImageWithURL:[NSURL URLWithString:mAnnotation.imageUrl]];
    
    _imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2 * kBorder, kWidth - 2 * kBorder);
    [self addSubview:_imageView];
    
    return self;
    
}

@end
