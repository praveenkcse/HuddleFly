//
//  SettingVC.h
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface SettingVC : BaseVC<UITextFieldDelegate>

{
    IBOutlet UIScrollView *scrView;
    UITextField *txtActive;
    CGRect oldRect;
}
@property (nonatomic , weak) IBOutlet UITextField *txtSsid;
@property (nonatomic , weak) IBOutlet UITextField *txtPassword;
@property (nonatomic , weak) IBOutlet UITextField *txtEmail;
@property (nonatomic , weak) IBOutlet UIWebView *webView;
@end

@interface Select1VC : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *configuBtn;

@property (weak, nonatomic) IBOutlet UIButton *changewifiBtn;
@end

@interface ScreenSetting1 : BaseVC
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic , weak) IBOutlet UIImageView *img;
@end


@interface ScreenSetting2 : BaseVC<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic , weak) IBOutlet UIImageView *img;
@end
