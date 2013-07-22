//
//  olgotHelpViewController.h
//  Olgot
//
//  Created by Raed Hamam on 7/29/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface olgotHelpViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (IBAction)donePressed:(id)sender;
@end
