//
//  olgotComment.h
//  Olgot
//
//  Created by Raed Hamam on 5/28/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotComment : NSObject

@property (nonatomic, strong) NSNumber* itemId;
@property (nonatomic, strong) NSNumber* Id;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSString* commentDate;
@property (nonatomic, strong) NSNumber* published;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userFirstName;
@property (nonatomic, strong) NSString* userLastName;
@property (nonatomic, strong) NSString* userProfileImgUrl;

@end
