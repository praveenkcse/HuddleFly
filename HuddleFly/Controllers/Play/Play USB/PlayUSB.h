//
//  PlayUSB.h
//  HuddleFly
//
//  Created by BMAC on 12/07/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface PlayUSB : BaseVC<UITextFieldDelegate,UITextViewDelegate>

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
