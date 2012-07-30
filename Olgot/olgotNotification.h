//
//  olgotNotification.h
//  Olgot
//
//  Created by Raed Hamam on 7/26/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "olgotNotificationUser.h"

@class olgotNotificationUser;

@interface olgotNotification : NSObject

@property (nonatomic, retain) NSNumber* noteID;
@property (nonatomic, retain) NSNumber* actionType;
@property (nonatomic, retain) NSString* noteDate;
@property (nonatomic, retain) NSNumber* noteStatus;
@property (nonatomic, retain) olgotNotificationUser* noteData;


@end
