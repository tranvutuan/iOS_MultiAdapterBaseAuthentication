//
//  ViewController.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) AppDelegate *delegate;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Check connection
- (IBAction)connectToServer:(id)sender {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[WLClient sharedInstance] invokeProcedure:delegate.getDataProcedureInvocation withDelegate:[[TNAInvokeListener alloc] initWithViewController:self]];
}

#pragma mark - UITextFieldDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case Type1: {
            if (buttonIndex == 1) {
                NSString *usr = [alertView textFieldAtIndex:0].text;
                NSString *pwd = [alertView textFieldAtIndex:1].text;
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate.submitAuthStep1 setParameters:[NSArray arrayWithObjects:usr,pwd, nil]];
                [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthStep1 options:nil];
            }
            else
                ;
            break;
        }
        case Type2: {
            
        }
        case Type3: {
            if (buttonIndex == 1) {
                NSString *anws = [alertView textFieldAtIndex:0].text;
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate.submitAuthStep2 setParameters:[NSArray arrayWithObject:anws]];
                [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthStep2 options:nil];
            }
            else
                ;
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
    alert.tag = Type1;
    [alert show];

}
#pragma mark - Show question form
-(void)showQuestionForm {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"LogIn", nil)
                                                     message:NSLocalizedString(@"what is your pet's name", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert addButtonWithTitle:NSLocalizedString(@"Submit", nil)];
    alert.tag = Type3;
    [alert show];
    
}
-(void)displayErrorMessage:(NSString*)errorMessage {
    
}

-(void)displayMessage:(NSString*)secretData {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message", nil)
                                                     message:secretData
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = Type2;
    [alert show];
}

#pragma mark - WLDelegate
-(void)onSuccess:(WLResponse *)response {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message",nil)
                                                     message:NSLocalizedString(@"Successfully to log out",nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = Type2;
    [alert show];
}

-(void)onFailure:(WLFailResponse *)response {
    
}

#pragma mark - Log out
-(IBAction)logOut:(id)sender {
    [[WLClient sharedInstance] logout:NSLocalizedString(@"SingleStepAuthRealm", nil) withDelegate:self];
}
@end
