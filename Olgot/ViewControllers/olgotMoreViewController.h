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


@interface olgotMoreViewController : UITableViewController{
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UISwitch *savePhotosSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *autoTweetSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *facebookConnectSwitch;
@property (strong, nonatomic) IBOutlet UILabel *sessionStatusLbl;


- (IBAction)changeSavePhotos:(id)sender;
- (IBAction)changeAutoTweet:(id)sender;
- (IBAction)changeFacebookConnect:(id)sender;

@end
