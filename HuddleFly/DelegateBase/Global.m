//
//  Global.m
//  lightpollutionmap
//
//  Created by My Star on 1/12/17.
//  Copyright © 2017 Company. All rights reserved.
//

#import "Global.h"
#import "AppDelegate.h"
#import "Constants.h"
@implementation Global


+ (instancetype)sharedInstance
{
    static Global *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Global alloc] init];
    });
    return sharedInstance;
}
- (void) setConstants
{

}

- (void)parameterInit{
    
    self.selectDeviceRow = -1;
    self.DeviceListA = [[NSMutableArray alloc] init];
   
}
+(void)roundBorderSet:(id)senser
{
    if ([senser isKindOfClass:[UIButton class]]) {
        [[senser layer] setCornerRadius:5.0f];
        [[senser layer] setMasksToBounds:YES];
        
        UIButton *bufBtn = [[UIButton alloc] init];
        bufBtn = (UIButton *)senser;
        if (bufBtn.tag!=1) {
            [[senser layer] setBorderWidth: 1.0f];
            [[senser layer] setBorderColor:[UIColor whiteColor].CGColor];
            [senser setBackgroundColor:COLOR_BTN_BACKGROUND];
        }

        
    }
    
    if ([senser isKindOfClass:[UITextField class]]) {
        [[senser layer] setCornerRadius:4.0f];
        [[senser layer] setMasksToBounds:YES];
    }
    
}
@end
