//
//  DeviceHealthVC.h
//  HuddleFly
//
//  Created by BMAC on 29/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
@class DeviceList;
@interface DeviceHealthVC : BaseVC
{
    
}
@property (nonatomic , retain) DeviceList *deviceListModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UILabel *lblSSID;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblUptime;
@property (weak, nonatomic) IBOutlet UILabel *lblCPU;
@property (weak, nonatomic) IBOutlet UILabel *lblRAM;
@property (weak, nonatomic) IBOutlet UILabel *lblDisk;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationHealth;


@end
