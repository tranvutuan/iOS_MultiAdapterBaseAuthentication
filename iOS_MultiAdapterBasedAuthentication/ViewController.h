//
//  ViewController.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNAPassLock.h"
#import "TNAInvokeListener.h"
#import "TNAChallengeHander.h"
#import "TNAConnectionListener.h"
typedef enum {
    SubmitAuthenticationType,
    FailureMessageType,
    SuccessMessageType,
    LogoutType
} AlertViewType;


@interface ViewController : UIViewController <WLDelegate,TNAPassLockDelegate>
@property (strong, nonatomic) IBOutlet UIButton *connectingButton;
@property (strong, nonatomic) TNAInvokeListener *invokeLinster;
-(void)showLoginForm;
-(void)showPassLock;
-(void)displayMessage:(NSString*)secretData withError:(BOOL)err;
-(void)submitAuthSilence;
-(void)dismissPassLock;
@end
