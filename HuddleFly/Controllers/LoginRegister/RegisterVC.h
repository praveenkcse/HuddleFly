//
//  RegisterVC.h
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "LoginVC.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface RegisterVC : BaseVC <UITextFieldDelegate,UIWebViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate>
{
    UITextField *txtActive;
    CGRect oldRect;
}
@property (weak, nonatomic) IBOutlet UIView *viewCont;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPsw;
//@property (weak, nonatomic) IBOutlet UITextField *txtDeviceID;
//@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;

@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet GIDSignInButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UISwitch *registerSwitch;


- (IBAction)onSwitchRegister:(id)sender;


- (IBAction)onClickRegister:(id)sender;

@end
