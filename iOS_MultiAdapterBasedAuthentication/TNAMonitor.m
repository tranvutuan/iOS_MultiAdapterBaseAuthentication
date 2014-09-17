//
//  TNAMonitor.m
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#define capacity     4
#import "AppDelegate.h"
#import "TNAMonitor.h"

static TNAMonitor *sharedInstance = nil;

@interface TNAMonitor ()
@property (strong, nonatomic) AppDelegate *delegate;

@end


@implementation TNAMonitor

#pragma mark - Get the shared instance and create it if necessary.
+ (TNAMonitor *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[TNAMonitor alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark - regular init method
- (id)init {
    self = [super init];
    
    if (self) {
        self.firstValidationPassed = NO;
        self.currAttempt = 0;
        self.enteredPasscode = [[NSMutableString alloc] initWithCapacity:4];
    }
    
    return self;
}

#pragma mark - Validate pass lock
-(void)submitAuthentication {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.submitAuthStep2 setParameters:[NSArray arrayWithObject:self.enteredPasscode]];
    [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthStep2 options:nil];
}

@end
