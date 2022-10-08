//
//  DeviceCmdVC.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "DeviceCmdVC.h"
#import "LocalEvents.h"
#import "ActionSheetStringPicker.h"
#import "Global.h"
@interface DeviceCmdVC () {
    DeviceCommand *_selectedCommand;
}

@end

@implementation DeviceCmdVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device Commands"];
    [super setBackBarItem:YES];
    arrCommands = [[NSMutableArray alloc] init];
    self.txtCmd.text = [[User currentUser] getCOMMAND];
    NSString *commandCode = [[User currentUser] getCOMMANDCODE];
    _selectedCommand = [[DeviceCommand alloc] init];
    _selectedCommand.strCommand = self.txtCmd.text;
    _selectedCommand.strValue = commandCode;
    [self getCommands];
    [Global roundBorderSet:_sendBtn];
    [Global roundBorderSet:_txtCmd];
    //[super setBackBarItem];
    [super setHelpBarButton:5];//ADDED BY DHAWAL 29-JUN-2017
}

#pragma mark - GetCommands

-(void)getCommands
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:KAPI_PATH_GET_COMMANDS withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [arrCommands removeAllObjects];
                for (NSDictionary *dict in response) {
                    DeviceCommand *d = [[DeviceCommand alloc] init];
                    [d setData:dict];
                    [arrCommands addObject:d];
                }
            }
        }
    }];
}

- (IBAction)onClickText:(id)sender
{
    [self.txtCmd becomeFirstResponder];
    [self.txtCmd resignFirstResponder];
    
    NSMutableArray *arrTemp = [NSMutableArray new];
    for(int i = 0 ; i < arrCommands.count ; i++)
    {
        DeviceCommand *d = arrCommands[i];
        [arrTemp addObject:d.strCommand];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Commands" rows:arrTemp initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        DeviceCommand *d = arrCommands[selectedIndex];
        self.txtCmd.text = d.strCommand;
        _selectedCommand = d;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.txtCmd];
}
#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    if (self.txtCmd.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please pick a command."];
        return;
    }
    
    
    NSString *cmd = _selectedCommand.strValue;
    
    if (cmd == nil){
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please pick a command."];
        return;
    }
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:cmd forKey:kAPI_PARAM_CMD];
    
    [[User currentUser] setCOMMAND:self.txtCmd.text];
    [[User currentUser] setCOMMANDCODE:cmd];
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_SAVEDEVICECOMMAND withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Command sent to device. Please wait 15-30 secs to take effect."];
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

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changewiBtn:(id)sender {
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?UserID=%@&%@=%@",kAPI_PATH_GETDEVICEIP,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [Global sharedInstance].configureURL =  [NSString stringWithFormat:@"http://%@", response[@"IPAddr"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Global sharedInstance].configureURL]];

            //[self performSegueWithIdentifier:@"segueToScreen2" sender:self];
        } else{
            [User setUserProfile:nil];
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            //[[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
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
