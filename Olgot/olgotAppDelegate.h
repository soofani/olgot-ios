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
#import "olgotSignupRootViewController.h"
#import "olgotChooseUsernameViewController.h"
#import "olgotChooseFriends.h"

@interface olgotAppDelegate : UIResponder <UIApplicationDelegate,signupRootViewDelegate, chooseFriendsDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)configureRestkit;
-(void)openFBSession;
-(void)showSignup;

@end
