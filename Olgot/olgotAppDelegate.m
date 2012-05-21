//
//  olgotAppDelegate.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation olgotAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
        UIImage *shareSelected = [UIImage imageNamed:@"btn-share-130x116"];
        UIImage *profileSelected = [UIImage imageNamed:@"icon-tab-bar-profile-active"];
        UIImage *moreSelected = [UIImage imageNamed:@"icon-tab-bar-more-active"];
        
        UIImage *exploreUnSelected = [UIImage imageNamed:@"icon-tab-bar-explore"];
        UIImage *lovelyUnSelected = [UIImage imageNamed:@"icon-tab-bar-lovely"];
        UIImage *shareUnSelected = [UIImage imageNamed:@"btn-share-130x116"];
        UIImage *profileUnSelected = [UIImage imageNamed:@"icon-tab-bar-profile"];
        UIImage *moreUnSelected = [UIImage imageNamed:@"icon-tab-bar-more"];
        
        [[exploreNavigationController tabBarItem] setTitle:@"Explore"];
        [[exploreNavigationController tabBarItem] setFinishedSelectedImage:exploreSelected withFinishedUnselectedImage:exploreUnSelected];
        
        
        [[lovelyNavigationController tabBarItem] setTitle:@"Lovely"];
        [[lovelyNavigationController tabBarItem] setFinishedSelectedImage:lovelySelected withFinishedUnselectedImage:lovelyUnSelected];
        
        
        
        [[shareNavigationController tabBarItem] setTitle:@"Share"];
        [[shareNavigationController tabBarItem] setFinishedSelectedImage:shareSelected withFinishedUnselectedImage:shareUnSelected];
        
        
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
    
    
    
    return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
