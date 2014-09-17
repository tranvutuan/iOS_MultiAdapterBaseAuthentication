//
//  TNAChallengeHander.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAConnectionListener.h"
#import "TNAChallengeHander.h"
#import "AppDelegate.h"
@implementation TNAChallengeHander


#pragma mark -  Test whether there is a custom challenge to be handled in the response
-(BOOL)isCustomResponse:(WLResponse *)response {
    //NSLog(@"TNA0 %@",[response getResponseJson]);
    NSDictionary *dict = [response getResponseJson];
    if (!response || !response.responseText)
        return false;
    
	if (dict[@"authRequired"] != nil  )
		return true;
	else
		return false;
	
}

#pragma mark - Handle the challenge
-(void)handleChallenge: (WLResponse *)response {
    //NSLog(@"TNA8 %@",[response getResponseJson]);
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSDictionary *responseJSON = [response getResponseJson];
    if ([responseJSON[@"authRequired"] intValue] == 1) {
        if ([responseJSON[@"authStep"] intValue] == 2) {
            [self.controller showPassLock];
            [TNAMonitor sharedInstance].firstValidationPassed = YES;
        }
        else if ([responseJSON[@"authStep"] intValue] == 1 && [responseJSON[@"errorMessage"] isKindOfClass:[NSNull class]] ) {
            NSString *usr = [delegate.keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
            NSString *pwd = [delegate.keychainWrapper objectForKey:(__bridge id)(kSecValueData)];
            if( usr.length > 0 && pwd.length > 0 ) {
                //NSLog(@"TNA*****");
                [self.controller submitAuthSilence];
            }            
            else
                [self.controller showLoginForm];
        }
        else
            [self.controller displayMessage:responseJSON[@"errorMessage"] withError:YES];
        
    }
    else {
        /* Store usr and pwd into keychain wrapper */
        [delegate.keychainWrapper setObject:self.usr forKey:(__bridge id)(kSecAttrAccount)];
        [delegate.keychainWrapper setObject:self.pwd forKey:(__bridge id)(kSecValueData)];
        
        [self submitSuccess:response];
    }
}

#pragma mark - WLDelegate
-(void) onFailure:(WLFailResponse *)response {
    //NSLog(@"TNA3 %@",[response getResponseJson]);
    [self submitFailure:response];
    [self.controller displayMessage:response.responseText withError:YES];
}
-(void) onSuccess:(WLResponse *)response {
    //NSLog(@"TNA4 %@",[response getResponseJson]);
    [self submitSuccess:response];
    NSString *message = [response getResponseJson][@"errorMessage"];
    [self.controller displayMessage:message withError:YES];
}




@end
