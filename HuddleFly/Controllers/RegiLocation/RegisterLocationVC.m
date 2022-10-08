//
//  RegisterLocationVC.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "RegisterLocationVC.h"
#import "Global.h"
@interface RegisterLocationVC ()

@end

@implementation RegisterLocationVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Register Device Location"];
    [super onTouchHideKeyboard];
    //[super setBackBarItem];
    
    [self getLocation];
    
    [Global roundBorderSet:_txtLocation];
    [Global roundBorderSet:_updateBtn];
}

- (void)getLocation {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GETDEVICELOCATION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSString *strDeviceLoc = [response objectForKey:@"DeviceLocation"];
                if(![strDeviceLoc isKindOfClass:[NSNull class]])
                    self.txtLocation.text = strDeviceLoc;
                //self.txtLocation.text = [response objectForKey:@"DeviceLocation"];
            }
        }
    }];
}

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    if (self.txtLocation.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:self.txtLocation.text forKey:kAPI_PARAM_DEVICELOCATION];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_SAVEDEVICELOCATION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Device Location saved!"];
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
    if (textField == self.txtLocation) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
        NSLog(@"String :%@",string);
        if([string isEqualToString:@""])
        {
            return YES;
        }
        if (self.txtLocation.text.length == 5) {
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
