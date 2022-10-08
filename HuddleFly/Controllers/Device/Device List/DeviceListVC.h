//
//  DeviceListVC.h
//  HuddleFly
//
//  Created by BMAC on 28/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "PreferencesCell.h"
#import "LocalEvents.h"
#import "PreferencesVC.h"
#import "AddDevice.h"

@interface DeviceListVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
   IBOutlet UITableView *tblDeviceList;
    IBOutlet UILabel *lblName;
    
    NSMutableArray *arrDeviceList;
    BOOL isEdited;
}
@property (weak, nonatomic) IBOutlet UIButton *userProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@end
