//
//  TNAPassLockView.h
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAMonitor.h"
#import <UIKit/UIKit.h>

@protocol TNAPassLockDelegate <NSObject>
-(void)dismissPassLock;
@end

@interface TNAPassLock : UIView

@property(assign) id<TNAPassLockDelegate> delegate;
+(id)loadPassLockView;

@end
