//
//  olgotActionUser.h
//  Olgot
//
//  Created by Raed Hamam on 5/28/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface olgotActionUser : NSObject
{
    
}

@property (nonatomic, retain) NSNumber* itemId;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userFirstName;
@property (nonatomic, retain) NSString* userLastName;
@property (nonatomic, retain) NSString* userProfileImgUrl;
@property (nonatomic, retain) NSNumber* venueId;
@property (nonatomic, retain) NSString* venueName_En;
@property (nonatomic, retain) NSString* venueName_Ar;
@property (nonatomic, retain) NSNumber* itemPhotoId;
@property (nonatomic, retain) NSString* itemPhotoUrl;
@property (nonatomic, retain) NSNumber* itemPhotoKey;

@end
