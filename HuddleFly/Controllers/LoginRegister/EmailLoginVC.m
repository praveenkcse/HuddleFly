//
//  EmailLoginVC.m
//  HuddleFly
//
//  Created by Jignesh on 18/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "EmailLoginVC.h"
#import "UIView+Utils.h"
#import "Global.h"
@interface EmailLoginVC ()

@end

@implementation EmailLoginVC

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewCont applySmallCornerWithColor:[UIColor lightGrayColor]];
    
    if([[self getUserDefaultValuebyKey:REM_BTNREM] isEqualToString:@"1"])
    {
        self.btnRemember.selected = YES;
        self.txtEmailAddress.text = [self getUserDefaultValuebyKey:REM_USERNAME];
        self.txtPassword.text = [self getUserDefaultValuebyKey:REM_PASSWORD];
    }
    _loginBtn.tag = 1;
    [Global roundBorderSet:_loginBtn];
    
    _verifyBtn.hidden = YES;
}

#pragma mark - Actions

- (IBAction)onClickLogin:(id)sender {
    if (self.txtEmailAddress.text.length == 0 || self.txtPassword.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    if (![[UtilityClass sharedObject] isValidEmailAddress:self.txtEmailAddress.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid email id."];
        return;
    }
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtEmailAddress.text forKey:kAPI_PARAM_EMAILID];
    [dictParam setObject:self.txtPassword.text forKey:kAPI_PARAM_PASSWORD];
    [dictParam setObject:kAPI_VALUE_TRUE forKey:kAPI_PARAM_REMEMBERME];
    
    [self saveUserPassword];
    
    [self.txtEmailAddress resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_CHECKLOGIN withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSLog(@"Login Code :%@",[response objectForKey:@"login_code"]);
            if([[response objectForKey:@"login_code"] isKindOfClass:[NSString class]])
            {
                if([@"1" caseInsensitiveCompare:[response objectForKey:@"login_code"]] == NSOrderedSame){
                    
                    if ([[response objectForKey:@"user_id"] isKindOfClass:[NSString class]]) {
                        
                        [[User currentUser] setUserID:[response objectForKey:@"user_id"]];
                        [[User currentUser] setLOGINTYPE:@"0"];
                        [[AppDelegate sharedAppDelegate] gotoMainScreen];
                        [[AppDelegate sharedAppDelegate] restoreInApp];//Added By DHAWAL Jan - 18 -2016
                    }
//                    if ([[response objectForKey:@"HasPaid"] isKindOfClass:[NSString class]]) {
//                        [[User currentUser] setUserPaid:[response objectForKey:@"HasPaid"]];
//                    }
                    
                    
                } else {
                    
                    //[[AppDelegate sharedAppDelegate] showToastMessage:@"Your email is not verified yet."];
                    [[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                    NSString *errorMsg = [response objectForKey:@"error"];
                    if ([errorMsg containsString:@"verified"]) {
                        _verifyBtn.hidden = NO;
                    }
                }
            } else {
                
                NSString* errorCode = [response objectForKey:@"result"];
                
                if ([errorCode isEqualToString:@"-1"] || [errorCode isEqualToString:@"-2"])
                    [[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)sendVerification:(id)sender {
    
    if (![[UtilityClass sharedObject] isValidEmailAddress:self.txtEmailAddress.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid email id."];
        return;
    }
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtEmailAddress.text forKey:kAPI_PARAM_EMAILID];

    [self.txtEmailAddress resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:@"SendVerificationEmail" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Email sent."];
        } else {
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)onClickRememberPassword:(UIButton *)sender
{
    if(sender.isSelected)
    {
        NSLog(@"Selected");
        sender.selected = NO;
    }
    else{
        NSLog(@"No selected");
        sender.selected = YES;
    }
}

- (void)setUserDefaultValue:(NSString *)value key:(NSString *)key
{
    [USERDEFAULT setValue:value forKey:key];
    [USERDEFAULT synchronize];
}

-(NSString *)getUserDefaultValuebyKey:(NSString *)key
{
    return [USERDEFAULT stringForKey:key];
}

- (void)saveUserPassword
{
    if(self.btnRemember.isSelected)
    {
        [self setUserDefaultValue:@"1" key:REM_BTNREM];
        [self setUserDefaultValue:self.txtEmailAddress.text key:REM_USERNAME];
        [self setUserDefaultValue:self.txtPassword.text key:REM_PASSWORD];
    }
    else{
        [self setUserDefaultValue:@"" key:REM_BTNREM];
        [self setUserDefaultValue:@"" key:REM_USERNAME];
        [self setUserDefaultValue:@"" key:REM_PASSWORD];
    }
}
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
