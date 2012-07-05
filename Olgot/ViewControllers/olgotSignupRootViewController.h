//
//  olgotSignupRootViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <RestKit/RestKit.h>

@interface olgotSignupRootViewController : UIViewController<RKRequestDelegate, UIActionSheetDelegate, RKObjectLoaderDelegate>
{
    
    NSString* _twitterName;
    NSData* _twitterResponse;
    NSArray* twitterAccounts;
    UIPickerView* accountsPicker;
}

@property (strong, nonatomic) IBOutlet UIButton *twitterSigninButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)hideSignup:(id)sender;

- (IBAction)twitterSignin:(id)sender;
- (void)canTweetStatus;
- (void)checkTwitterName:(NSString *)text;


@end
