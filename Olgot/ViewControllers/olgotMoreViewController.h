//
//  olgotMoreViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "olgotAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>


@interface olgotMoreViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *savePhotosSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *autoTweetSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *facebookConnectSwitch;


- (IBAction)changeSavePhotos:(id)sender;
- (IBAction)changeAutoTweet:(id)sender;
- (IBAction)changeFacebookConnect:(id)sender;

@end
