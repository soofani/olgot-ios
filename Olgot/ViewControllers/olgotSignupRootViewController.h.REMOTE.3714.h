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
#import <FacebookSDK/FacebookSDK.h>

@interface olgotSignupRootViewController : UIViewController<RKRequestDelegate, UIActionSheetDelegate, RKObjectLoaderDelegate>
{
    
    NSString* _twitterName;
    NSData* _twitterResponse;
    NSArray* twitterAccounts;
    UIPickerView* accountsPicker;
    
    NSDictionary<FBGraphUser> *fbUser;
}

@property (strong, nonatomic) IBOutlet UIButton *twitterSigninButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *facebookSigninButton;

- (IBAction)hideSignup:(id)sender;

- (IBAction)twitterSignin:(id)sender;
- (IBAction)facebookSignin:(id)sender;
- (void)canTweetStatus;
- (void)checkTwitterName:(NSString *)text;


@end
