//
//  DevicePreferences.h
//  HuddleFly
//
//  Created by apple on 24/09/22.
//  Copyright © 2022 AccountIT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevicePreferences : BaseVC
@property (weak, nonatomic) IBOutlet UIImageView *imgWaterCheck;
@property (weak, nonatomic) IBOutlet UITextField *tfThreshold;
@property (weak, nonatomic) IBOutlet UITextField *tfGracePeriod;
@property (weak, nonatomic) IBOutlet UITextField *tfAlert1;
@property (weak, nonatomic) IBOutlet UITextField *tfAlert2;
@property (weak, nonatomic) IBOutlet UITextField *tfAlert3;
@property (weak, nonatomic) IBOutlet UITextField *tfAlert4;
@property (weak, nonatomic) IBOutlet UITextField *tfFinalAlert;
@property (weak, nonatomic) IBOutlet UITextField *tfAlertResetAfter;
@property (weak, nonatomic) IBOutlet UITextField *tfBuzzerInterval;
@property (weak, nonatomic) IBOutlet UITextField *tfCalibration;
@end

NS_ASSUME_NONNULL_END
