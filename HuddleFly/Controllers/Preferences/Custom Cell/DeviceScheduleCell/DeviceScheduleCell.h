//
//  DeviceScheduleCell.h
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleData.h"

static  BOOL isFollowThisScheduleOn;

@interface DeviceScheduleCell : UITableViewCell

@property (nonatomic , assign)IBOutlet UIImageView *imgViewSchedule;
@property (nonatomic , assign)IBOutlet UILabel *lblScheduleTitle;
@property (nonatomic , assign)IBOutlet UIButton *btnScheduleTime;
@property (nonatomic , assign)IBOutlet UISwitch *swtSchedule;

@property (nonatomic , retain) id celldata;

- (void)setData:(id)data image:(UIImage *)img;

+ (void)setFollowThisScheduleOn:(BOOL)val;
@end
