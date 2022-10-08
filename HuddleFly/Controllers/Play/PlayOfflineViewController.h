//
//  PlayOfflineViewController.h
//  HuddleFly
//
//  Created by Anton Boyarkin on 23/02/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface PlayOfflineViewController : BaseVC<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic , weak)IBOutlet UIButton *btnOnline;
@property (nonatomic , weak)IBOutlet UIButton *btnOffline;
@property (weak, nonatomic) IBOutlet UIButton *btnExternalUSB;
@property (nonatomic , weak)IBOutlet UIButton *btnDeviceHardDerive;


@property (nonatomic , weak)IBOutlet UITextView *txtMediaUrl;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *medialUrlLabel;
@property (weak, nonatomic) IBOutlet UIButton *playUsbBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopUsbBtn;

@property (weak, nonatomic) IBOutlet UIView *mediumView;

@property (weak, nonatomic) IBOutlet UILabel *mediaToPlayLabel;
@property (nonatomic,weak)IBOutlet UIButton *btnPicture;
@property (nonatomic,weak)IBOutlet UIButton *btnVideo;
@property (nonatomic,weak)IBOutlet UIButton *btnPowerPoint;

@property (weak, nonatomic) IBOutlet UILabel *pixTransitionLabel;
@property (nonatomic,weak)IBOutlet UITextField *pixTransitionTextField;

@end
