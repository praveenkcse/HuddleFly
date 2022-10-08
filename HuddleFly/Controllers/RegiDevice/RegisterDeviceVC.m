//
//  RegisterDeviceVC.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "RegisterDeviceVC.h"

@interface RegisterDeviceVC ()

@end

@implementation RegisterDeviceVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Register HuddleFly Device"];
    //[super setBackBarItem];
    
    [self getDeviceID];
}

- (void)getDeviceID {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    NSLog(@"String :%@",[[User currentUser] userID]);
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GETDEVICEID withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSString *strDeviceID = [response objectForKey:@"DeviceID"];
                if(![strDeviceID isKindOfClass:[NSNull class]])
                    self.txtDeviceID.text = strDeviceID;
            }
        }
    }];
}

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    if (self.txtDeviceID.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:self.txtDeviceID.text forKey:kAPI_PARAM_DEVICEID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_SAVEDEVICEID withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Device saved!"];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtDeviceID) {
        /*if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }*/
        if([string isEqualToString:@""])
        {
            return YES;
        }
        NSString *strText = self.txtDeviceID.text;
        
        if(self.txtDeviceID.text.length == 2 || self.txtDeviceID.text.length == 5 || self.txtDeviceID.text.length ==8 || self.txtDeviceID.text.length == 11 || self.txtDeviceID.text.length == 14)
        {
            strText = [strText stringByAppendingString:@":"];
            self.txtDeviceID.text = strText;
        }
        NSLog(@"String :%@",string);
        
        if (self.txtDeviceID.text.length == 17) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
