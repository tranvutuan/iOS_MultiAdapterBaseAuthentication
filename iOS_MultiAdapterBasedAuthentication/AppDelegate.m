//
//  AppDelegate.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.getDataProcedureInvocation = [[WLProcedureInvocationData alloc] initWithAdapterName: NSLocalizedString(@"adapterName", nil)
                                                                               procedureName:NSLocalizedString(@"getSecretData", nil)];
    self.submitAuthStep1 = [[WLProcedureInvocationData alloc]  initWithAdapterName:NSLocalizedString(@"adapterName", nil)
                                                                                  procedureName:NSLocalizedString(@"procedureStep1", nil)];
    self.submitAuthStep2 = [[WLProcedureInvocationData alloc]  initWithAdapterName:NSLocalizedString(@"adapterName", nil)
                                                                     procedureName:NSLocalizedString(@"procedureStep2", nil)];
    self.challengeHandler = [[TNAChallengeHander alloc] initWithRealm:NSLocalizedString(@"realmName", nil)];

    [[WLClient sharedInstance] wlConnectWithDelegate:self];


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

-(void)onSuccess:(WLResponse *)response {
    
}

-(void)onFailure:(WLFailResponse *)response {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message", nil)
                                                     message:response.errorMsg
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

@end
