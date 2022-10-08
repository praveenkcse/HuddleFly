//
//  DeviceSettings.h
//  HuddleFly
//
//  Created by BMAC on 29/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "ActionSheetStringPicker.h"

@interface DeviceSettings : BaseVC<UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray *arrNumber;
    NSMutableArray *arrColors;
    NSMutableArray *arrZooms;
    NSMutableArray *arrRotations;

    CGRect frame;
}
@property (nonatomic,weak)IBOutlet UIView *viewSinglePanel;
@property (nonatomic,weak)IBOutlet UIView *viewRotatePanel;
@property (nonatomic,weak)IBOutlet UITextField *txtColor;
@property (nonatomic,weak)IBOutlet UITextField *txtZoom;
@property (nonatomic,weak)IBOutlet UITextField *txtTransition;
@property (nonatomic,weak)IBOutlet UITextField *txtRefresh;
@property (nonatomic,weak)IBOutlet UITextView *txtWPUrl;
@property (nonatomic,weak)IBOutlet UIButton *btnHDMI;
@property (nonatomic,weak)IBOutlet UIButton *btnJack;
@property (nonatomic,weak)IBOutlet UIButton *btnSinglePage;
@property (nonatomic,weak)IBOutlet UIButton *btnRotatePage;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (nonatomic,weak)IBOutlet UITextField *txtRotation;
@property (nonatomic,weak)IBOutlet UILabel *lblRotation;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//@property (nonatomic,weak)IBOutlet UIButton *btnLoopVideo;
//@property (nonatomic,weak)IBOutlet UIButton *btnDontLoopVideo;
//
//@property (nonatomic,weak)IBOutlet UIButton *btnPicture;
//@property (nonatomic,weak)IBOutlet UIButton *btnVideo;
//@property (nonatomic,weak)IBOutlet UIButton *btnPowerPoint;
//
//@property (nonatomic,weak)IBOutlet UITextField *pixTransitionTextField;

@end
