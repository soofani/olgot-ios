//
//  olgotAppDelegate.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "olgotSignupRootViewController.h"
#import "olgotChooseUsernameViewController.h"
#import "olgotChooseFriends.h"
#import "DejalActivityView.h"
#import "olgotTabBarViewController.h"

@protocol olgotTwitterDelegate;
@protocol olgotFacebookDelegate;

@interface olgotAppDelegate : UIResponder <UIApplicationDelegate,signupRootViewDelegate, chooseFriendsDelegate,UIActionSheetDelegate>{
    
    NSArray *twitterAccounts;
    
    id<olgotTwitterDelegate> twitterDelegate;
    id<olgotFacebookDelegate> facebookDelegate;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) id<olgotTwitterDelegate> twitterDelegate;
@property (nonatomic,retain) id<olgotFacebookDelegate> facebookDelegate;

-(void)configureRestkit;
-(void)openFBSession;
-(void)showSignup;
-(void)twitterConnect;

@end


@protocol olgotTwitterDelegate

-(void)loadingAccounts;
-(void)loadedAccounts;
-(void)didChooseAccount;
-(void)cancelledTwitter;

@end

@protocol olgotFacebookDelegate

-(void)facebookSuccess;
-(void)facebookFailed;
-(void)facebookCancelled;

@end
