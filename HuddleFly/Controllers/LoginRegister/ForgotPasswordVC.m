//
//  ForgotPasswordVC.m
//  HuddleFly
//
//  Created by BMAC on 01/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Global.h"
@interface ForgotPasswordVC ()<UITextFieldDelegate>

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Global roundBorderSet:_submitBtn];
    // Do any additional setup after loading the view.
}

- (IBAction)forgotPassword
{
    if ([self.txtEmail.text isEqualToString:@""] || self.txtEmail.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter email id."];
        return;
    }
    if (![[UtilityClass sharedObject] isValidEmailAddress:self.txtEmail.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid email id."];
        return;
    }
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtEmail.text forKey:kAPI_PARAM_EMAILID];
    
    [afn getDataFromPath:kAPI_PATH_FORGOTPASSWORD withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([[response objectForKey:@"result"] isKindOfClass:[NSString class]]) {
                if([[response objectForKey:@"result"] isEqualToString:@"0"])
                {
                    //[[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                    
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"We have sent an email with verification link on your email. Sometimes emails go to SPAM. Check your SPAM folder too."];//Added By DHAWAL 10-Aug-2016
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
