//
//  olgotMoreViewController.h
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface olgotMoreViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *savePhotosSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *autoTweetSwitch;
- (IBAction)changeSavePhotos:(id)sender;
- (IBAction)changeAutoTweet:(id)sender;

@end
