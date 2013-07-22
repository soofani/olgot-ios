//
//  olgotItem.h
//  Olgot
//
//  Created by Raed Hamam on 5/27/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//


@interface olgotItem : NSObject

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSNumber* itemID;
@property (nonatomic, retain) NSString* itemDescription;
@property (nonatomic, retain) NSString* itemPrice;
@property (nonatomic, retain) NSNumber* itemDiscount;
@property (nonatomic, retain) NSString* itemDate;
@property (nonatomic, retain) NSString* itemDateNatural;
@property (nonatomic, retain) NSString* itemUrl;
@property (nonatomic, retain) NSNumber* itemKey;
@property (nonatomic, retain) NSNumber* itemPublished;
@property (nonatomic, retain) NSNumber* userID;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userFirstName;
@property (nonatomic, retain) NSString* userLastName;
@property (nonatomic, retain) NSString* userProfileImgUrl;
@property (nonatomic, retain) NSString* userTwitterName;
@property (nonatomic, retain) NSString* itemPhotoId;
@property (nonatomic, retain) NSString* itemPhotoUrl;
@property (nonatomic, retain) NSNumber* itemStatsLikes;
@property (nonatomic, retain) NSNumber* itemStatsWants;
@property (nonatomic, retain) NSNumber* itemStatsGots;
@property (nonatomic, retain) NSNumber* itemStatsComments;
@property (nonatomic, retain) NSNumber* venueId;
@property (nonatomic, retain) NSString* venueName_En;
@property (nonatomic, retain) NSString* name_Ar;
@property (nonatomic, retain) NSNumber* venueGeoLat;
@property (nonatomic, retain) NSNumber* venueGeoLong;
@property (nonatomic, retain) NSString* venueTwitterName;
@property (nonatomic, retain) NSNumber* cityId;
@property (nonatomic, retain) NSString* cityName_En;
@property (nonatomic, retain) NSString* countryCurrencyShortName;
@property (nonatomic, retain) NSNumber* itemScore;
@property (nonatomic, retain) NSArray* comments;
@property (nonatomic, retain) NSArray* likes;
@property (nonatomic, retain) NSArray* wants;
@property (nonatomic, retain) NSArray* gots;
@property (nonatomic,retain) NSNumber* iLike;
@property (nonatomic,retain) NSNumber* iWant;
@property (nonatomic,retain) NSNumber* iGot;


@end
