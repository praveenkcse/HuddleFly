//
//  PlayYouTubeVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "PlayYouTubeVC.h"
#import "Global.h"
@interface PlayYouTubeVC () {
    NSString *YTurl;
}

@end

@implementation PlayYouTubeVC

#pragma mark - Life Cycle

- (NSString *)helpPath {
    return @"100-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setMultimedia:@"1"];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem:YES];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    //[super setBackBarItem];
    
    self.txtYouTubeURL.text = [[User currentUser] getYOUTUBEURL];
    
    [self getYoutubePlay];
    
    
    [Global roundBorderSet:_playBtn];
    
    [[_stopBtn layer] setCornerRadius:5.0f];
    [[_stopBtn layer] setMasksToBounds:YES];
    [[_stopBtn layer] setBorderWidth: 1.0f];
    [[_stopBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [_stopBtn setBackgroundColor:COLOR_BTN_REDBACK];
    [Global roundBorderSet:_txtYouTubeURL];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    YTurl = [defaults objectForKey:@"YTurl"];
    
    if (YTurl != nil) {
        self.txtYouTubeURL.text = YTurl;

        [defaults removeObjectForKey:@"YTurl"];
        [defaults synchronize];
    }
}

//- (IBAction)onCLickPlayLoop:(id)sender
//{
//    _btnPlayLoop.selected = !_btnPlayLoop.isSelected;
//}

-(void)setMultimedia:(NSString *) multimediaValue{
}
#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    if (self.txtYouTubeURL.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    if (![[UtilityClass sharedObject]isValidURL:self.txtYouTubeURL.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid URL"];
        return;
    }
    [[User currentUser] setYOUTUBEURL:self.txtYouTubeURL.text];
    [self updateYoutubePlay];
}

static NSString * extracted() {
    return kAPI_PARAM_CMD;
}

- (IBAction)onClickStopYouTube:(id)sender
{
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"stopyoutube" forKey:extracted()];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_SAVEDEVICECOMMAND withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Youtube Stopped!"];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getYoutubePlay
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_YOUTUBEURL withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strYoutubeUrl = [dict objectForKey:kAPI_PARAM_YOUTUBEURL];
            self.txtYouTubeURL.text = strYoutubeUrl;
            
//            self.btnPlayLoop.selected = [[dict objectForKey:@"YouTubePlayType"] boolValue];
            
            if (YTurl != nil) {
                self.txtYouTubeURL.text = YTurl;
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)updateYoutubePlay
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getYOUTUBEURL] forKey:kAPI_PARAM_YOUTUBE];
    
    /*Added By DHAWAL 5-Aug-2016*/
   // [dictParam setObject:@"" forKey:@"AudioMode"];
    
//    NSString *strLoop = @"0";//@"noloop";
//    if(_btnPlayLoop.isSelected){
//        strLoop = @"1";//@"loop";
//    }
//    [dictParam setObject:strLoop forKey:@"PlayMode"];
    /*ended*/
    
    [afn getDataFromPath:KAPI_PATH_UPDATE_YOUTUBELINK withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Youtube url Updated successfully."];
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

/*
- (IBAction)onClickHDMI:(id)sender {
    self.btnAudioJack.selected = NO;
    self.btnHDMI.selected = YES;
}

- (IBAction)onClickAudioJack:(id)sender {
    self.btnAudioJack.selected = YES;
    self.btnHDMI.selected = NO;
}
*/

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
    - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
        
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            return NO;
        }
        
        return YES;
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
