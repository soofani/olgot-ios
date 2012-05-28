//
//  olgotCategory.h
//  Olgot
//
//  Created by Raed Hamam on 5/27/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

@interface olgotCategory : NSObject
{
    
}

@property (nonatomic, retain) NSNumber* categoryID;
@property (nonatomic, retain) NSString* name_Ar;
@property (nonatomic, retain) NSString* name_En;
@property (nonatomic, retain) NSNumber* cityID;
@property (nonatomic, retain) NSNumber* order;
@property (nonatomic, retain) NSNumber* items;
@property (nonatomic, retain) NSString* lastItemDate;

@end
