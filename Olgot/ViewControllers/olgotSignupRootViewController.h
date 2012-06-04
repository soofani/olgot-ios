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

@interface olgotSignupRootViewController : UIViewController<RKRequestDelegate>
{
    NSString* _twitterName;
    NSData* _twitterResponse;
}

@property (strong, nonatomic) IBOutlet UIButton *twitterSigninButton;


- (IBAction)hideSignup:(id)sender;

- (IBAction)twitterSignin:(id)sender;
- (void)canTweetStatus;
- (void)checkTwitterName:(NSString *)text;

@end
