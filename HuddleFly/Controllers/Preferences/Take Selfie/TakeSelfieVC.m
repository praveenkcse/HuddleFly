//
//  TakeSelfieVC.m
//  HuddleFly
//
//  Created by BMAC on 29/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "TakeSelfieVC.h"
#import "Global.h"
@interface TakeSelfieVC ()

@end

@implementation TakeSelfieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Snap A Selfie"];
    //[super setBackBarItem];
    [self getAlert];
    
    [Global roundBorderSet:_snapBtn];
}

#pragma mark - Media URL Button

- (IBAction)btnMediaUrlClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lblMediaUrl.text]];
}


#pragma mark - Take Selfie Button

-(IBAction)btnTakeSelfieClicked:(UIButton *)sender
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"1" forKey:kAPI_PARAM_SELFIETYPE];
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_SELFIE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Selfie Updated!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}


- (void)getAlert
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"1" forKey:kAPI_PARAM_ALERTTYPE];
    
    [afn getDataFromPath:kAPI_PATH_GET_ALERT withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            if(![[dict objectForKey:kAPI_PARAM_MEDIAURL] isKindOfClass:[NSNull class]])
                if([[dict objectForKey:kAPI_PARAM_MEDIAURL] isKindOfClass:[NSString class]])
                {
                    lblMediaUrl.text = [dict objectForKey:kAPI_PARAM_MEDIAURL];
                }
            if(![[dict objectForKey:kAPI_PARAM_ALERTTIME] isKindOfClass:[NSNull class]])
                if([[dict objectForKey:kAPI_PARAM_ALERTTIME] isKindOfClass:[NSString class]])
                {
                    lblAlertTime.text = [dict objectForKey:kAPI_PARAM_ALERTTIME];
                }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
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
