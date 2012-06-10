//
//  olgotUser.h
//  Olgot
//
//  Created by Raed Hamam on 6/2/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotUser : NSObject

@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* userProfileImageUrl;
@property (nonatomic, retain) NSNumber* followers;
@property (nonatomic, retain) NSNumber* following;
@property (nonatomic, retain) NSNumber* items;
@property (nonatomic, retain) NSNumber* iFollow;
@property (nonatomic, retain) NSNumber* followsMe;




@end
