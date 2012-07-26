//
//  olgotNotificationUser.h
//  Olgot
//
//  Created by Raed Hamam on 7/26/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotNotificationUser : NSObject

@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* twitterName;
@property (nonatomic, retain) NSString* profileImgUrl;
@property (nonatomic, retain) NSNumber* itemId;
@property (nonatomic, retain) NSString* itemImgUrl;
@property (nonatomic, retain) NSNumber* itemVenueId;
@property (nonatomic, retain) NSString* itemVenueName;


@end
