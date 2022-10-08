//
//  DeviceScheduleVC.h
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM(NSInteger, ScheduleType)
{
    ScheduleType_Wake = 0,
    ScheduleType_Leave,
    ScheduleType_Return,
    ScheduleType_Sleep
};

typedef NS_ENUM(NSInteger, Day)
{
    Day_Mon = 0,
    Day_Tue,
    Day_Wed,
    Day_Thu,
    Day_Fri,
    Day_Sat,
    Day_Sun
};

@interface DeviceScheduleVC : BaseVC
{
    NSMutableArray *arrScheduleData;
}
@property (nonatomic , assign)ScheduleType scheduleType;
@property (nonatomic , assign)Day dayType;

@property (nonatomic , assign)IBOutlet UILabel *lblDay;
@property (nonatomic , assign)IBOutlet UITableView *tblView;
@property (nonatomic , assign)IBOutlet UIButton *btnLeft;
@property (nonatomic , assign)IBOutlet UIButton *btnRight;
//@property (nonatomic , assign)IBOutlet UIButton *btnActiveSched;
@property (nonatomic , assign)IBOutlet UIButton *btnFollowSched;

@property (nonatomic , assign)IBOutlet UISwitch *swtActiveSched;
@end
