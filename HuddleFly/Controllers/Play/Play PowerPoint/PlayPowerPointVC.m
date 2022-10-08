//
//  PlayPowerPointVC.m
//  HuddleFly
//
//  Created by BMAC on 05/08/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "PlayPowerPointVC.h"
#import "Global.h"
@interface PlayPowerPointVC ()

@end

@implementation PlayPowerPointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setMultimedia:@"1"];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem:YES];
    [Global roundBorderSet:_stopBtn];
}

#pragma mark - Action

- (IBAction)onClickStopPresentation:(id)sender
{
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_STOP_PRESENTATION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Presentation Stopped"];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)setMultimedia:(NSString *) multimediaValue{
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
