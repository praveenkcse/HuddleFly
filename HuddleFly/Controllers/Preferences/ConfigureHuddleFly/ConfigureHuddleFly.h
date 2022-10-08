//
//  ConfigureHuddleFly.h
//  HuddleFly
//
//  Created by BMAC on 03/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface ConfigureHuddleFly : BaseVC<UITextFieldDelegate>

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

@interface SelectVC : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *configuBtn;

@property (weak, nonatomic) IBOutlet UIButton *changewifiBtn;
@end

@interface Screen1 : BaseVC
@property (nonatomic , weak) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end


@interface Screen2 : BaseVC<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic , weak) IBOutlet UIImageView *img;
@end
