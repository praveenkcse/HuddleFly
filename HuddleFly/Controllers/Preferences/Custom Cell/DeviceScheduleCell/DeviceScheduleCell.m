//
//  DeviceScheduleCell.m
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "DeviceScheduleCell.h"
#import "ActionSheetDatePicker.h"
#import "Constants.h"
#import "User.h"
#import "AFNHelper.h"
#import "AppDelegate.h"

@implementation DeviceScheduleCell

- (void)awakeFromNib {
    _btnScheduleTime.layer.cornerRadius = 6.0;
    _btnScheduleTime.layer.borderColor = [UIColor blackColor].CGColor;
    _btnScheduleTime.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)setFollowThisScheduleOn:(BOOL)val
{
    isFollowThisScheduleOn = val;
}

- (void)setData:(id)data image:(UIImage *)img
{
    if([data isKindOfClass:[ScheduleData class]])
    {
        _celldata = data;
        ScheduleData *d = (ScheduleData *)data;
        _lblScheduleTitle.text = d.strTitleSchedule;
        [_btnScheduleTime setTitle:d.strTimeSchedule forState:UIControlStateNormal];
        [_swtSchedule setOn:d.isSwtOn animated:YES];
        if(img){
            _imgViewSchedule.image = img;
        }
    }
}

- (IBAction)onClickSwtSchedule:(id)sender
{
    UISwitch *swt = (UISwitch *)sender;
    ScheduleData *d = (ScheduleData *)_celldata;
    d.isSwtOn = swt.isOn;
    
    [self updateScheduleStatusApi];
}

- (IBAction)onClickScheduleTime:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *strTime = btn.currentTitle;
    NSDate *d = [dateFormatter dateFromString:strTime];
    
    ActionSheetDatePicker *date = [[ActionSheetDatePicker alloc] initWithTitle:@"Select Time" datePickerMode:UIDatePickerModeTime selectedDate:d doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"]; //hh:mm a //HH:mm
        NSString *currentTime = [dateFormatter stringFromDate:(NSDate *)selectedDate];
        [btn setTitle:currentTime forState:UIControlStateNormal];
        
        ScheduleData *d = (ScheduleData *)_celldata;
        d.strTimeSchedule = currentTime;
        
        [self updateScheduleTimeApi];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:btn];
    date.locale = [NSLocale localeWithLocaleIdentifier:@"NL"];
    [date showActionSheetPicker];
}

- (void)updateScheduleStatusApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    ScheduleData *d = (ScheduleData *)_celldata;
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:d.strScheduleID forKey:kAPI_PARAM_SCHEDULE_ID];
    if(d.isSwtOn)
        [dictParam setObject:@"1" forKey:kAPI_PARAM_DEVICE_STATUS];
    else
        [dictParam setObject:@"0" forKey:kAPI_PARAM_DEVICE_STATUS];
    
    if(isFollowThisScheduleOn)
        [dictParam setObject:@"true" forKey:@"FollowThisSchedule"];
    else
        [dictParam setObject:@"false" forKey:@"FollowThisSchedule"];
    
    NSLog(@"Update Schedule Time Api Dict:%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_SCHEDULE_STATUS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Set Active Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSArray class]]) {
                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}


- (void)updateScheduleTimeApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    ScheduleData *d = (ScheduleData *)_celldata;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"hh:mm a"]; //hh:mm a //HH:mm
     NSDate *currentTime = [dateFormatter dateFromString:d.strTimeSchedule];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:currentTime];
    //strTime = [[strTime componentsSeparatedByString:@":"] componentsJoinedByString:@","];
    //strTime = [strTime stringByAppendingString:@",0,0"];
    //strTime = [strTime stringByAppendingString:@":0:0"];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:d.strScheduleID forKey:kAPI_PARAM_SCHEDULE_ID];
    [dictParam setObject:strTime forKey:kAPI_PARAM_TIME];
    
    if(isFollowThisScheduleOn)
        [dictParam setObject:@"true" forKey:@"FollowThisSchedule"];
    else
        [dictParam setObject:@"false" forKey:@"FollowThisSchedule"];
    
    NSLog(@"Update Schedule Time Api Dict:%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_SCHEDULE_TIME withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Set Active Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSArray class]]) {
                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

@end

