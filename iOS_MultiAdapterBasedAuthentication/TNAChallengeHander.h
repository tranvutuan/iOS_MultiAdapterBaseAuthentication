//
//  TNAChallengeHander.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAMonitor.h"
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ChallengeHandler.h"

@interface TNAChallengeHander : ChallengeHandler
@property (strong, nonatomic) NSString *usr;
@property (strong, nonatomic) NSString *pwd;
@property (strong, nonatomic) ViewController *controller;
@end
