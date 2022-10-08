//
//  AddDevice.h
//  HuddleFly
//
//  Created by BMAC on 28/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "LocalEvents.h"

@interface AddDevice : BaseVC<UITextFieldDelegate>
{
    IBOutlet UITextField *txtDeviceName;
    IBOutlet UITextField *txtToken;
    IBOutlet UITextField *txtDeviceLocation;
    
    IBOutlet UITextField *txtWifiNetwork;
    IBOutlet UITextField *txtIPAddress;
    IBOutlet UITextField *txtConnection;
    IBOutlet UITextField *txtDisplay;
    IBOutlet UITextField *txtTimeStamp;
    
    IBOutlet UIButton *btnAdd;
    IBOutlet UIButton *btnIsMaster;
    IBOutlet UIButton *btnIsFollowMaster;
    IBOutlet UIView *viewContainerIsMaster;
    IBOutlet UIView *viewContainerFollowMaster;
    //keyboard
    IBOutlet UIScrollView *scrView;
    UITextField *txtActive;
    CGRect oldRect;
    IBOutlet UILabel *IsMasterL;
    
}
@property (nonatomic , assign)BOOL isEdited;
@property (nonatomic , strong)DeviceList *listObj;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint *addButtonContarint;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint *addButtonToMasterViewContarint;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint *addButtonToTimeLabelContarint;

- (IBAction)btnAddCliked:(id)sender;
@end
