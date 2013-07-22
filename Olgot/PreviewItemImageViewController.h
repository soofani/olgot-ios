//
//  PreviewItemImageViewController.h
//  Olgot
//
//  Created by Belal Jaradat on 7/8/13.
//  Copyright (c) 2013 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewItemImageViewController : UIViewController<UIScrollViewDelegate>
{
   
    IBOutlet UIImageView *itemImageView;
    BOOL tapBarIsShown;

}
@property (strong, nonatomic)NSString *itemTitle;
@property (strong, nonatomic)UIImage *itemImage;
@property (strong, nonatomic) IBOutlet UIScrollView *slideShowImageViewScrollView;
@end
