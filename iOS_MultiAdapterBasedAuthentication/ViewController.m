//
//  ViewController.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAMonitor.h"
#import "AppDelegate.h"
#import "ViewController.h"

#define MAX_ATTEMPTS    2
#define passLock_x      2
#define passLockWith    317
#define passLockHeight  398

@interface ViewController ()
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) TNAPassLock *passLock;
@end

@implementation ViewController

#pragma mark - View cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"ViewTitle", nil);
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.delegate.challengeHandler.controller = self;
    
    [[WLClient sharedInstance] registerChallengeHandler:self.delegate.challengeHandler];
    self.passLock = [TNAPassLock loadPassLockView];
    self.passLock.delegate = self;
    self.passLock.frame = CGRectMake(passLock_x, -CGRectGetHeight(self.passLock.frame), passLockWith, passLockHeight);
    
    [self.view addSubview:self.passLock];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get secret data
- (IBAction)connectToServer:(id)sender {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[WLClient sharedInstance] invokeProcedure:delegate.getDataProcedureInvocation
                                  withDelegate:[[TNAInvokeListener alloc] initWithViewController:self]
    ];
}

#pragma mark - POST credential
-(void)submitAuthSilence {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *usr = [delegate.keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *pwd = [delegate.keychainWrapper objectForKey:(__bridge id)(kSecValueData)];

    [delegate.submitAuthStep1 setParameters:[NSArray arrayWithObjects:usr,pwd, nil]];
    [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthStep1 options:nil];
}

#pragma mark - UITextFieldDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case SubmitAuthenticationType: {
            if (buttonIndex == 1) {
                NSString *usr = [alertView textFieldAtIndex:0].text;
                NSString *pwd = [alertView textFieldAtIndex:1].text;
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.challengeHandler.usr = usr;
                delegate.challengeHandler.pwd = pwd;
                [delegate.submitAuthStep1 setParameters:[NSArray arrayWithObjects:usr,pwd, nil]];
                [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthStep1 options:nil];
            }
            else
                ;
            break;
        }
        case FailureMessageType: {
            // Make sure enteredPasscode has something before deletion
            if ([TNAMonitor sharedInstance].enteredPasscode.length > 0 )
                [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];
            break;
        }
        case SuccessMessageType: {
            // Make sure enteredPasscode has something before deletion
            if ([TNAMonitor sharedInstance].enteredPasscode.length > 0)
                [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];

            break;
        }
        case LogoutType: {
            break;
        }
            
    }

}

#pragma mark - Show log in form
-(void)showLoginForm {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"LogIn", nil)
                                                     message:NSLocalizedString(@"Enter Username & Password", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert addButtonWithTitle:NSLocalizedString(@"logIn", nil)];
    alert.tag = SubmitAuthenticationType;
    [alert show];

}

#pragma mark - Show question form
-(void)showPassLock {
    CGFloat new_y = 90;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,new_y);
                     }
                     completion:nil
     ];
}


-(void)displayMessage:(NSString*)message withError:(BOOL)err {
    if (err) {
        
        if ([TNAMonitor sharedInstance].firstValidationPassed) {
            if ([TNAMonitor sharedInstance].currAttempt < MAX_ATTEMPTS) { // Number of attempt is < 3
                [TNAMonitor sharedInstance].currAttempt++;
                [self showAlertViewWith:message andTag:FailureMessageType];
            }
            else {  // Number of attempt is > 3
                NSLog(@"SHOULD PROVIDE IMPLEMENTATION");
                [UIView animateWithDuration:.5
                                 animations:^{
                                     self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                                 }
                                 completion:^(BOOL finished) {
                                     [TNAMonitor sharedInstance].currAttempt = 0;
                                     [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];
                                 }
                 ];
            }
        }
        else {
            [self showAlertViewWith:message andTag:FailureMessageType];
        }
    }
    else {
        [UIView animateWithDuration:.5
                         animations:^{
                             self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                         }
                         completion:^(BOOL finished) {
                             [self showAlertViewWith:message andTag:SuccessMessageType];
                         }
         ];
        
    }
}

#pragma mark - WLDelegate
-(void)onSuccess:(WLResponse *)response {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message",nil)
                                                     message:NSLocalizedString(@"Successfully to log out",nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = LogoutType;
    [alert show];
}

-(void)onFailure:(WLFailResponse *)response {
    
}

#pragma mark - Log out
-(IBAction)logOut:(id)sender {
    [[WLClient sharedInstance] logout:NSLocalizedString(@"SingleStepAuthRealm", nil) withDelegate:self];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.keychainWrapper resetKeychainItem];
}

#pragma mark - Show alert view
-(void)showAlertViewWith:(NSString*)message andTag:(NSInteger)tag{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message", nil)
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = tag;
    [alert show];
}

#pragma mark - TNAPassLockDelegate
-(void)dismissPassLock {
    [UIView animateWithDuration:.5
                     animations:^{
                         self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                     }
                     completion:nil
     ];
}


@end
