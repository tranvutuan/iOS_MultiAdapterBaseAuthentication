//
//  TNAPassLockView.m
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#define MAX_LENGTH 4
#import "TNAPassLock.h"

@implementation TNAPassLock

#pragma mark - 
+ (id)loadPassLockView {
    TNAPassLock *passLock = [[[NSBundle mainBundle] loadNibNamed:@"TNAPassLock" owner:nil options:nil] lastObject];

    // make sure customView is not nil or the wrong class!
    if ([passLock isKindOfClass:[TNAPassLock class]])
        return passLock;
    else
        return nil;
}

#pragma mark - Regular init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Corner rounding
-(void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger tag = 0; tag <= 11; tag++) {
        if ( [[self viewWithTag:tag] isKindOfClass:[UIButton class]] ) {
            UIButton *button = (UIButton*)[self viewWithTag:tag];
            [button setBackgroundColor:[UIColor clearColor]];
            [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
            [[button layer] setBorderWidth:1.0f];
            CGFloat radius = button.frame.size.width / 2;
            [[button layer] setCornerRadius:radius];
        }
    }
}

#pragma mark - Pin enterted
- (IBAction)pinEntered:(id)sender {
    [[TNAMonitor sharedInstance].enteredPasscode appendString:((UIButton*)sender).currentTitle];
    //NSLog(@"TNA999 is %@",[TNAMonitor sharedInstance].enteredPasscode);

    if ( [TNAMonitor sharedInstance].enteredPasscode.length == MAX_LENGTH) {
        [[TNAMonitor sharedInstance] submitAuthentication];
    }
}

#pragma mark - Pin erased
- (IBAction)pinErased:(id)sender {
    NSInteger location = [TNAMonitor sharedInstance].enteredPasscode.length - 1;
    if ([[TNAMonitor sharedInstance].enteredPasscode length] > 0)
        [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(location, 1)];
    //NSLog(@"TNA1010 is %@",[TNAMonitor sharedInstance].enteredPasscode);

}

#pragma mark - Cancel
-(IBAction)cancelPassCode:(id)sender {
    [self.delegate dismissPassLock];
}
@end


