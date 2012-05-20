//
//  olgotAddItemDetailsViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/17/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface olgotAddItemDetailsViewController : UIViewController
{
    UIImageView *itemImageView;
    __weak IBOutlet UITextField *whyCoolTF;
}

@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;

@end
