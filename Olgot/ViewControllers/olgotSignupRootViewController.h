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

@protocol signupRootViewDelegate;

@interface olgotSignupRootViewController : UIViewController<RKRequestDelegate, UIActionSheetDelegate, RKObjectLoaderDelegate,UIGestureRecognizerDelegate>
{
    
    NSString* _twitterName;
    NSData* _twitterResponse;
    NSArray* twitterAccounts;
    UIPickerView* accountsPicker;
    
    NSDictionary<FBGraphUser> *fbUser;
    
    id<signupRootViewDelegate> delegate;
}

@property (strong, nonatomic) UIImage *homeImage;

@property (nonatomic,retain) id<signupRootViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *dummyBgImageView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRecogniser;
- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UIButton *twitterSigninButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *facebookSigninButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sloganImageView;


@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
- (IBAction)hideSignup:(id)sender;

- (IBAction)twitterSignin:(id)sender;
- (IBAction)facebookSignin:(id)sender;
- (void)canTweetStatus;
- (void)checkTwitterName:(NSString *)text;


@end

@protocol signupRootViewDelegate

-(void)skippedSignup;
-(void)existingUser;

@end
