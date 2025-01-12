//
//  olgotAppDelegate.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "olgotCategory.h"
#import "olgotItem.h"
#import "olgotUser.h"
#import "olgotActionUser.h"
#import "olgotVenue.h"
#import "olgotComment.h"
#import "olgotMyFriend.h"
#import "olgotNotification.h"
#import "olgotNotificationUser.h"
#import "LocalyticsSession.h"



@implementation olgotAppDelegate

@synthesize window = _window;

@synthesize twitterDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LocalyticsSession sharedLocalyticsSession] startSession:@"79e9cf2757a4dbe32bfda7c-8361ac6a-8e30-11e1-356e-00ef75f32667"];
    
    [self configureRestkit];
    
//    check for facebook session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openFBSession];
    }
    
        // Setup custom tab view
        CGRect frame = CGRectMake(0, 0, 480, 49);
        UIView *tabBarView = [[UIView alloc] initWithFrame:frame];
        UIColor *tabBarColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-tab-bar"]];
        
        [tabBarView setBackgroundColor:tabBarColor];
        
        UITabBarController *tabbarController = (UITabBarController *) self.window.rootViewController;
        
        [tabbarController.tabBar insertSubview:tabBarView atIndex:1];
        
    [[UIApplication sharedApplication] 
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
        // customize navigation bar
        UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"bg-nav-bar"] 
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground 
                                           forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor colorWithRed:232.0/255.0 green:78.0/255.0 blue:32.0/255.0 alpha:1.0], 
          UITextAttributeTextColor, 
          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0], 
          UITextAttributeTextShadowColor, 
          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], 
          UITextAttributeTextShadowOffset, 
          [UIFont fontWithName:@"Helvetica-Neue-Bold" size:18.0], 
          UITextAttributeFont, 
          nil]];
        
        UIImage *backButton30 = [[UIImage imageNamed:@"btn-nav-back"] 
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 10)];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton30 
                                                          forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], 
          UITextAttributeTextColor, 
          [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0], 
          UITextAttributeTextShadowColor, 
          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], 
          UITextAttributeTextShadowOffset, 
          [UIFont fontWithName:@"Helvetica-Neue-Bold" size:0.0], 
          UITextAttributeFont, 
          nil] 
                                                    forState:UIControlStateNormal];
        
        // Cast all navigation controllers
        UINavigationController *exploreNavigationController = (UINavigationController *) [[tabbarController viewControllers] objectAtIndex:0];
        UINavigationController *lovelyNavigationController = (UINavigationController *) [[tabbarController viewControllers] objectAtIndex:1];
        UINavigationController *shareNavigationController = (UINavigationController *) [[tabbarController viewControllers] objectAtIndex:2];
        UINavigationController *profileNavigationController = (UINavigationController *) [[tabbarController viewControllers] objectAtIndex:3];
        UINavigationController *moreNavigationController = (UINavigationController *) [[tabbarController viewControllers] objectAtIndex:4];
        
        for (UINavigationController *navC in tabbarController.viewControllers) {
            navC.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
            navC.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            navC.navigationBar.layer.shadowOpacity = 0.5;
            navC.navigationBar.layer.masksToBounds = NO;
        }
        
        // Configure navigation controllers and tab icons
        UIImage *exploreSelected = [UIImage imageNamed:@"icon-tab-bar-explore-active"];
        UIImage *lovelySelected = [UIImage imageNamed:@"icon-tab-bar-lovely-active"];
//        UIImage *shareSelected = [UIImage imageNamed:@"btn-share-130x116"];
        UIImage *profileSelected = [UIImage imageNamed:@"icon-tab-bar-profile-active"];
        UIImage *moreSelected = [UIImage imageNamed:@"icon-tab-bar-more-active"];
        
        UIImage *exploreUnSelected = [UIImage imageNamed:@"icon-tab-bar-explore"];
        UIImage *lovelyUnSelected = [UIImage imageNamed:@"icon-tab-bar-lovely"];
//        UIImage *shareUnSelected = [UIImage imageNamed:@"btn-share-130x116"];
        UIImage *profileUnSelected = [UIImage imageNamed:@"icon-tab-bar-profile"];
        UIImage *moreUnSelected = [UIImage imageNamed:@"icon-tab-bar-more"];
        
        [[exploreNavigationController tabBarItem] setTitle:@"Explore"];
        [[exploreNavigationController tabBarItem] setFinishedSelectedImage:exploreSelected withFinishedUnselectedImage:exploreUnSelected];
        
        
        [[lovelyNavigationController tabBarItem] setTitle:@"Hot"];
        [[lovelyNavigationController tabBarItem] setFinishedSelectedImage:lovelySelected withFinishedUnselectedImage:lovelyUnSelected];
        
        
        
        [[shareNavigationController tabBarItem] setTitle:@"Share"];
//        [[shareNavigationController tabBarItem] setFinishedSelectedImage:shareSelected withFinishedUnselectedImage:shareUnSelected];
        
        
        [[profileNavigationController tabBarItem] setTitle:@"Profile"];
        [[profileNavigationController tabBarItem] setFinishedSelectedImage:profileSelected withFinishedUnselectedImage:profileUnSelected];
        
        
        [[moreNavigationController tabBarItem] setTitle:@"More"];
        [[moreNavigationController tabBarItem] setFinishedSelectedImage:moreSelected withFinishedUnselectedImage:moreUnSelected];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:168.0f/255.0f green:168.0f/255.0f blue:168.0f/255.0f alpha:255.0f/255.0f], UITextAttributeTextColor,
                                                           nil] 
                                                 forState:UIControlStateNormal];
        
        [[UITabBarItem appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor colorWithRed:232.0f/255.0f green:78.0f/255.0f blue:32.0f/255.0f alpha:255.0f/255.0f], UITextAttributeTextColor,
                                                            nil] 
                                                  forState:UIControlStateSelected];
    
    [self showSignup];
    
    return YES;
}

-(void)configureRestkit
{
    // Initialize RestKit
    RKClient* client = [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://olgot.com/olgot/index.php/api"]];  
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://olgot.com/olgot/index.php/api"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    //setup category mapping
    RKObjectMapping* categoryMapping = [RKObjectMapping mappingForClass:[olgotCategory class]];
    
    [categoryMapping mapKeyPathsToAttributes:
     @"id", @"categoryID",
     @"name_En", @"name_En",
     @"name_Ar", @"name_Ar",
     @"cityId", @"cityID",
     @"order", @"order",
     @"items", @"items",
     @"lastItemDate", @"lastItemDate",
     nil];
    
    
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[olgotItem class]];
    
    [itemMapping mapKeyPathsToAttributes:
     @"itemName",@"itemName",
     @"itemId",@"itemID",
     @"itemDescription",@"itemDescription",
     @"itemPrice",@"itemPrice",
     @"itemDiscount",@"itemDiscount",
     @"itemDate",@"itemDate",
     @"itemDateNatural",@"itemDateNatural",
     @"itemKey",@"itemKey",
     @"itemUrl",@"itemUrl",
     @"itemPublished",@"itemPublished",
     @"userId",@"userID",
     @"userName",@"userName",
     @"userFirstName",@"userFirstName",
     @"userLastName",@"userLastName",
     @"userProfileImgUrl",@"userProfileImgUrl",
     @"userTwitterName", @"userTwitterName",
     @"itemPhotoId",@"itemPhotoId",
     @"itemPhotoUrl",@"itemPhotoUrl",
     @"itemStatsLikes",@"itemStatsLikes",
     @"itemStatsWants",@"itemStatsWants",
     @"itemStatsGots",@"itemStatsGots",
     @"itemStatsComments",@"itemStatsComments",
     @"venueId",@"venueId",
     @"venueName_En",@"venueName_En",
     @"name_Ar",@"name_Ar",
     @"venueGeoLat",@"venueGeoLat",
     @"venueGeoLong",@"venueGeoLong",
     @"venueTwitterName",@"venueTwitterName",
     @"cityId",@"cityId",
     @"cityName_En",@"cityName_En",
     @"countryCurrencyShortName",@"countryCurrencyShortName",
     @"itemScore",@"itemScore",
     @"userActions.Like",@"iLike",
     @"userActions.want",@"iWant",
     @"userActions.got",@"iGot",
     nil];
    
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[olgotUser class]];
    
    [userMapping mapKeyPathsToAttributes:
     @"id", @"userId",
     @"username", @"username",
     @"firstName", @"firstName",
     @"lastName", @"lastName",
     @"profileImgUrl",@"userProfileImageUrl",
     @"followers",@"followers",
     @"following", @"following",
     @"items",@"items",
     @"iFollow",@"iFollow",
     @"followsMe",@"followsMe",
     @"email", @"email",
     @"twitterId", @"twitterId",
     @"twitterName", @"twitterName",
     @"facebookid",@"facebookId",
     nil];
    
    RKObjectMapping* actionUserMapping = [RKObjectMapping mappingForClass:[olgotActionUser class]];
    
    [actionUserMapping mapKeyPathsToAttributes:
     @"itemId", @"itemId",
     @"date", @"date",
     @"userId",@"userId",
     @"userName",@"userName",
     @"userFirstName",@"userFirstName",
     @"userLastName",@"userLastName",
     @"userProfileImgUrl",@"userProfileImgUrl",
     @"venueId",@"venueId",
     @"venueName_En",@"venueName_En",
     @"venueName_Ar",@"venueName_Ar",
     @"itemPhotoId",@"itemPhotoId",
     @"itemPhotoUrl",@"itemPhotoUrl",
     @"itemPhotoKey",@"itemPhotoKey",
     @"iFollow",@"iFollow",
     @"followsMe",@"followsMe",
     nil];
    
    RKObjectMapping* followersFollowingMapping = [RKObjectMapping mappingForClass:[olgotActionUser class]];
    
    [followersFollowingMapping mapKeyPathsToAttributes:
     @"itemId", @"itemId",
     @"date", @"date",
     @"userId",@"userId",
     @"userName",@"userName",
     @"firstName",@"userFirstName",
     @"lastName",@"userLastName",
     @"userProfileImgUrl",@"userProfileImgUrl",
     @"venueId",@"venueId",
     @"venueName_En",@"venueName_En",
     @"venueName_Ar",@"venueName_Ar",
     @"itemPhotoId",@"itemPhotoId",
     @"itemPhotoUrl",@"itemPhotoUrl",
     @"itemPhotoKey",@"itemPhotoKey",
     @"iFollow",@"iFollow",
     @"followsMe",@"followsMe",
     nil];
    
    RKObjectMapping* innerActionUserMapping = [RKObjectMapping mappingForClass:[olgotActionUser class]];
    
    [innerActionUserMapping mapKeyPathsToAttributes:
     @"profileImgUrl",@"userProfileImgUrl",
     
     nil];
    
    RKObjectMapping* venueMapping = [RKObjectMapping mappingForClass:[olgotVenue class]];
    
    [venueMapping mapKeyPathsToAttributes:
     @"id",@"venueId",
     @"name_Ar",@"name_Ar",
     @"name_En",@"name_En",
     @"geoLat",@"geoLat",
     @"geoLong",@"geoLong",
     @"twitterName",@"twitterName",
     @"items",@"items",
     @"iconUrl",@"venueIcon",
     @"foursquareAddress",@"foursquareAddress",
     @"distance",@"distance",
     @"iconUrl",@"iconUrl",
     @"topUser.userId",@"topUserId",
     @"topUser.firstName",@"topUserFirstName",
     @"topUser.lastName",@"topUserLastName",
     @"topUser.items",@"topUserItems",
     @"topUser.profileImgUrl",@"topUserProfileImgUrl",
     nil];
    
    RKObjectMapping* commentMapping = [RKObjectMapping mappingForClass:[olgotComment class]];
    
    [commentMapping mapKeyPathsToAttributes:
     @"itemId",@"itemId",
     @"id",@"Id",
     @"body",@"body",
     @"dateNatural",@"commentDate",
     @"published", @"published",
     @"userId",@"userId",
     @"userName",@"userName",
     @"userFirstName",@"userFirstName",
     @"userLastName",@"userLastName",
     @"userProfileImgUrl",@"userProfileImgUrl",
     nil];
    
    RKObjectMapping* innerCommentMapping = [RKObjectMapping mappingForClass:[olgotComment class]];
    
    [innerCommentMapping mapKeyPathsToAttributes:
     @"itemId",@"itemId",
     @"id",@"Id",
     @"body",@"body",
     @"dateNatural",@"commentDate",
     @"published", @"published",
     @"userId",@"userId",
     @"firstName",@"userFirstName",
     @"lastName",@"userLastName",
     @"profileImgUrl",@"userProfileImgUrl",
     nil];
    
    
    RKObjectMapping* myFriendMapping = [RKObjectMapping mappingForClass:[olgotMyFriend class]];
    [myFriendMapping mapKeyPathsToAttributes:
     @"userId",@"userId",
     @"username",@"username",
     @"firstName",@"firstName",
     @"lastName",@"lastName",
     @"facebookFriend",@"facebookFriend",
     @"twitterFriend",@"twitterFriend",
     @"foursqaureFriend",@"foursqaureFriend",
     @"userProfileImgUrl",@"userProfileImgUrl",
     @"iFollow", @"iFollow",
     @"followsMe",@"followsMe",
     nil];
    
    RKObjectMapping* twitterInviteeMapping = [RKObjectMapping mappingForClass:[olgotMyFriend class]];
    [twitterInviteeMapping mapKeyPathsToAttributes:
     @"id",@"userId",
     @"twitterName",@"username",
     @"fullName",@"firstName",
     @"twitterImageUrl",@"userProfileImgUrl",
     nil];
    
    RKObjectMapping* notificationMapping = [RKObjectMapping mappingForClass:[olgotNotification class]];
    [notificationMapping mapKeyPathsToAttributes:
     @"id", @"noteID",
     @"actionType", @"actionType",
     @"date", @"noteDate",
     @"viewed", @"noteStatus",
     nil
     ];
    
    RKObjectMapping* notificationUserMapping = [RKObjectMapping mappingForClass:[olgotNotificationUser class]];
    
    [notificationUserMapping mapAttributes:@"userId",@"firstName",@"lastName",@"username",@"twitterName",@"profileImgUrl",@"itemId",@"itemKey",@"itemImgUrl",@"itemVenueId",@"itemVenueName", nil];
    
    // Register our mappings with the provider
    [categoryMapping mapKeyPath:@"lastItem" toRelationship:@"lastItem" withMapping: itemMapping];
    [objectManager.mappingProvider setObjectMapping:categoryMapping forResourcePathPattern:@"/categories"];
    
    [itemMapping mapKeyPath:@"comments" toRelationship:@"comments" withMapping:innerCommentMapping];
    [itemMapping mapKeyPath:@"likes" toRelationship:@"likes" withMapping:innerActionUserMapping];
    [itemMapping mapKeyPath:@"wants" toRelationship:@"wants" withMapping:innerActionUserMapping];
    [itemMapping mapKeyPath:@"gots" toRelationship:@"gots" withMapping:innerActionUserMapping];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/item/"];
    
    [notificationMapping mapKeyPath:@"data" toRelationship:@"noteData" withMapping:notificationUserMapping];
    [objectManager.mappingProvider setObjectMapping:notificationMapping forResourcePathPattern:@"/notifications/"];
    
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/feeditems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/nearbyitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/categoryitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/useritems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/userwants/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/userlikes/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/venueitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/hotitems/"];
    
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapfeeditems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapnearbyitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapcategoryitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapuseritems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapuserwants/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapuserlikes/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/mapvenueitems/"];
    [objectManager.mappingProvider setObjectMapping:itemMapping forResourcePathPattern:@"/maphotitems/"];
    
    [objectManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/user/"];
    [objectManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/userid/"];
    
    [objectManager.mappingProvider setObjectMapping:venueMapping forResourcePathPattern:@"/venue/"];
    [objectManager.mappingProvider setObjectMapping:venueMapping forResourcePathPattern:@"/nearbyvenues/"];
    [objectManager.mappingProvider setObjectMapping:venueMapping forResourcePathPattern:@"/findvenues/"];
    
    [objectManager.mappingProvider setObjectMapping:actionUserMapping forResourcePathPattern:@"/itemlikes/"];
    [objectManager.mappingProvider setObjectMapping:actionUserMapping forResourcePathPattern:@"/itemwants/"];
    [objectManager.mappingProvider setObjectMapping:actionUserMapping forResourcePathPattern:@"/itemgots/"];
    
    [objectManager.mappingProvider setObjectMapping:followersFollowingMapping forResourcePathPattern:@"/followers/"];
    [objectManager.mappingProvider setObjectMapping:followersFollowingMapping forResourcePathPattern:@"/following/"];
    
    [objectManager.mappingProvider setObjectMapping:commentMapping forResourcePathPattern:@"/comments/"];
    
    [objectManager.mappingProvider setObjectMapping:myFriendMapping forResourcePathPattern:@"/friends/"];
    
    [objectManager.mappingProvider setObjectMapping:twitterInviteeMapping forResourcePathPattern:@"/networkfriends/"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:[NSString stringWithFormat:@"user %@ started the app", [defaults objectForKey:@"userid"]]];
 
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // this means the user switched back to this app without completing
    // a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; // so we close our session and start over
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"Memory warning");
}

#pragma mark facebook methods

- (void)openFBSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions",
                            nil];
    
    [FBSession openActiveSessionWithPermissions:permissions
                                   allowLoginUI:YES
                              completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self FBsessionStateChanged:session state:state error:error];
     }];
}

- (void)FBsessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self.facebookDelegate facebookSuccess];
            self.facebookDelegate = nil;
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)showSignup
{
    UIGraphicsBeginImageContext(CGSizeMake(self.window.rootViewController.view.bounds.size.width, self.window.rootViewController.view.bounds.size.height));
    
    
    [self.window.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    olgotSignupRootViewController *signupRootVC = [[olgotSignupRootViewController alloc] initWithNibName:@"olgotSignupRootView" bundle:nil];
    [signupRootVC setHomeImage:myImage];
    [signupRootVC setDelegate:self];
    
    UINavigationController *signupNavigationController = [[UINavigationController alloc] initWithRootViewController:signupRootVC];
    
    [self.window.rootViewController presentModalViewController:signupNavigationController animated:YES];
}

-(void)twitterConnect
{
    [self.twitterDelegate loadingAccounts];
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Remember that twitterType was instantiated above
            twitterAccounts = [store accountsWithAccountType:twitterType];
            
            // If there are no accounts, we need to pop up an alert
            if(twitterAccounts != nil && [twitterAccounts count] > 0) {
                // Get the list of Twitter accounts.
                
                NSLog(@"accounts: %@",twitterAccounts);
                
                
                UIActionSheet* twitterActionSheet;
                twitterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                for (ACAccount* ac in twitterAccounts) {
                    [twitterActionSheet addButtonWithTitle:[ac accountDescription]];
                }
                
                [self.twitterDelegate loadedAccounts];
//                [twitterActionSheet showInView:self.window.rootViewController.view];
                
                olgotTabBarViewController *tabBarVC = (olgotTabBarViewController*)self.window.rootViewController;
                [twitterActionSheet showInView:tabBarVC.view];
//                [twitterActionSheet showFromRect:CGRectMake(50.0, 100.0, 320.0, 200.0) inView:tabBarVC.view animated:YES];
            }
            
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                                message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }else{
            [self.twitterDelegate cancelledTwitter];
        }
        // Handle any error state here as you wish
    }];

}

#pragma mark -
#pragma mark UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"selected index %d",buttonIndex);
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (buttonIndex > 0) {
       
        
        [defaults setObject:[NSNumber numberWithInt:(buttonIndex - 1)] forKey:@"twitterAccountIndex"];
        
        [defaults synchronize];
        [self.twitterDelegate didChooseAccount];
    }else {
        //cancel
        NSLog(@"cancel");
        [defaults setObject:nil forKey:@"twitterAccountIndex"];
        
        [defaults synchronize];
        [self.twitterDelegate cancelledTwitter];
        
    }
}

#pragma mark signupRootDelegate

-(void)skippedSignup
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"firstRun"];
    [defaults synchronize];
    [self.window.rootViewController dismissModalViewControllerAnimated:NO];
}

-(void)existingUser
{
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark chooseFriendsDelegate

-(void)finishedPickingFriends
{
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}


@end
