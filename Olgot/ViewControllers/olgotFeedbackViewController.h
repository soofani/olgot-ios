//
//  olgotFeedbackViewController.h
//  Olgot
//
//  Created by Raed Hamam on 6/12/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface olgotFeedbackViewController : UIViewController <UITextViewDelegate, RKObjectLoaderDelegate>
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *postFeedbackButton;
- (IBAction)postFeedbackButtonPressed:(id)sender;

@end
