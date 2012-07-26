//
//  olgotNotificationsViewController.h
//  Olgot
//
//  Created by Raed Hamam on 7/26/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "SSPullToRefresh.h"

@interface olgotNotificationsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,RKObjectLoaderDelegate, SSPullToRefreshViewDelegate>{
    
    NSArray* _notifications;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
- (IBAction)doneBtnPressed:(id)sender;

@end
