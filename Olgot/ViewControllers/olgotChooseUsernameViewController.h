//
//  olgotChooseUsernameViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface olgotChooseUsernameViewController : UIViewController<RKRequestDelegate>
{
    id _twitterJson;
    NSString* _userID;
    
    NSDictionary<FBGraphUser> *fbUser;
   
    UIToolbar* numberToolbar;
     UITextField *selectedTextField;
}

@property (strong, nonatomic) NSDictionary<FBGraphUser> *fbUser;
@property (strong, nonatomic) NSData *twitterResponseData;
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userPhone;
@property (strong, nonatomic) IBOutlet UIButton *createAccountBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)pressedNext:(id)sender;
- (IBAction)pressedDone:(id)sender;

- (IBAction)createAccount:(id)sender;


@end
