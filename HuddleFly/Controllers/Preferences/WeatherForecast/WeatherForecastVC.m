//
//  WeatherForecastVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "WeatherForecastVC.h"
#import "Global.h"
@interface WeatherForecastVC ()

@end

@implementation WeatherForecastVC

#pragma mark - Life Cycle

- (NSString *)helpPath {
    return @"4-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    [super onTouchHideKeyboard];
    [self getWeatherLocation];
    [Global roundBorderSet:_txtWeatherLocation];
    [Global roundBorderSet:_updateBtn];
}

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    
    if (self.txtWeatherLocation.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    
    if (self.txtWeatherLocation.text.length > 0) {
        [self.txtWeatherLocation resignFirstResponder];
        [[User currentUser] setWEATHERLOCATION:self.txtWeatherLocation.text];
        [self updateWeatherLocation];
    }
}

-(void)getWeatherLocation
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
     NSString *apiPath = [NSString stringWithFormat:@"%@?%@=%@&%@=%@",kAPI_PATH_GET_WEATHER_LOCATION,kAPI_PARAM_USERID,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            self.txtWeatherLocation.text = [dict objectForKey:kAPI_PARAM_WEATHERLOCATION];
            [[User currentUser] setWEATHERLOCATION:self.txtWeatherLocation.text];
            
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)updateWeatherLocation
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",kAPI_PATH_UPDATE_WEATHER_LOCATION,kAPI_PARAM_USERID,[[User currentUser] userID],kAPI_PARAM_WEATHERLOCATION,self.txtWeatherLocation.text,kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Location Updated successfully."];
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtWeatherLocation) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
        if([string isEqualToString:@""])
        {
            return YES;
        }
        if (self.txtWeatherLocation.text.length == 5) {
            return NO;
        }
       /* if (self.txtWeatherLocation.text.length == 5) {
            return NO;
        }*/
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
