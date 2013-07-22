//
//  olgotTwitterInviteCell.h
//  Olgot
//
//  Created by Raed Hamam on 9/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface olgotTwitterInviteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userFullName;
@property (strong, nonatomic) IBOutlet UILabel *userScreenName;
@property (strong, nonatomic) IBOutlet UIButton *inviteUserBtn;

@end
