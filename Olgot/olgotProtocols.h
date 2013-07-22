//
//  olgotProtocols.h
//  Olgot
//
//  Created by Raed Hamam on 9/5/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol olgotOgItem<FBGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *url;

@end


@protocol olgotOgFindItem<FBOpenGraphAction>

@property (retain, nonatomic) id<olgotOgItem> item;

@end
