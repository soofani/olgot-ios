//
//  olgotChooseUsernameViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/14/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface olgotChooseUsernameViewController : UIViewController<RKRequestDelegate>
{
    id _twitterJson;
    NSString* _userID;
}

@property (strong, nonatomic) NSData *twitterResponseData;
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UIButton *createAccountBtn;
- (IBAction)pressedNext:(id)sender;
- (IBAction)pressedDone:(id)sender;

- (IBAction)createAccount:(id)sender;


@end
