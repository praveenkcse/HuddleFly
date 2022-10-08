//
//  EmailLoginVC.h
//  HuddleFly
//
//  Created by Jignesh on 18/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"


#define REM_USERNAME    @"Username_Rem"
#define REM_PASSWORD    @"Password_Rem"
#define REM_BTNREM      @"Btn_Rem"

@interface EmailLoginVC : BaseVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnRemember;
@property (weak, nonatomic) IBOutlet UIView *viewCont;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

- (IBAction)onClickLogin:(id)sender;
- (IBAction)sendVerification:(id)sender;

@end
