//
//  olgotMyFriend.m
//  Olgot
//
//  Created by Raed Hamam on 5/31/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotMyFriend.h"

@implementation olgotMyFriend

@synthesize userId = _userId,
username = _username,
firstName = _firstName,
lastName = _lastName,
facebookFriend = _facebookFriend,
twitterFriend = _twitterFriend,
foursqaureFriend = _foursqaureFriend,
userProfileImgUrl = _userProfileImgUrl,
iFollow = _iFollow;

-(void)setUserId:(NSNumber *)userId
{
    _userId = userId;
}

-(id)init{
    _iFollow = 0;
    return self;
}

@end
