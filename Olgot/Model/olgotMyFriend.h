//
//  olgotMyFriend.h
//  Olgot
//
//  Created by Raed Hamam on 5/31/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotMyFriend : NSObject

@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSNumber* facebookFriend;
@property (nonatomic, strong) NSNumber* twitterFriend;
@property (nonatomic, strong) NSNumber* foursqaureFriend;
@property (nonatomic, strong) NSString* userProfileImgUrl;
@property (nonatomic, strong) NSNumber* iFollow;
@property (nonatomic, strong) NSNumber* followsMe;

@end
