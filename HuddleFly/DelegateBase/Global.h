//
//  Global.h
//  lightpollutionmap
//
//  Created by My Star on 1/12/17.
//  Copyright © 2017 Company. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface Global : NSObject
// view size
@property float viewWidth;
@property float viewHeight;
// DEVICE
@property NSInteger selectDeviceRow;
@property NSMutableArray *DeviceListA;
@property NSString *configureURL;
@property BOOL appStart;
+ (instancetype)sharedInstance;
+(void)roundBorderSet:(id)senser;
- (void) setConstants;
- (void)parameterInit;

@end
