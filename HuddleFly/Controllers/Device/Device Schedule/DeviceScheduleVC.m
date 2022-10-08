//
//  DeviceScheduleVC.m
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "DeviceScheduleVC.h"
#import "DeviceScheduleCell.h"

@interface DeviceScheduleVC ()<UITableViewDataSource , UITableViewDelegate>

@end

@implementation DeviceScheduleVC

- (NSString *)helpPath {
    return @"0-7";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device Schedule"];
    [super setBackBarItem:YES];
    [super setHelpBarButton:7];//ADDED BY DHAWAL 29-JUN-2017
    
    _tblView.layer.borderColor = [UIColor blackColor].CGColor;
    _tblView.layer.borderWidth = 1.0;
    _tblView.layer.cornerRadius = 6.0;
    _tblView.clipsToBounds = YES;
    _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    arrScheduleData = [[NSMutableArray alloc] init];
    _dayType = 0;
    [self setday:_dayType];
    //[self getTimeData];
    
    [self getDeviceScheduleApi];
    
    [DeviceScheduleCell setFollowThisScheduleOn:NO];
}

/*
- (IBAction)onClickSubmit:(id)sender
{
    
}

- (void)getTimeData
{
    NSArray *arrDay = @[@"Wake",@"Leave",@"Return",@"Sleep"];
    NSArray *arrTime = @[@"6:00 am",@"9:00 pm",@"6:00 pm",@"10:00 pm"];
    
    
    for(int i = 0 ; i < 7 ; i++){
        ScheduleDayData *data = [[ScheduleDayData alloc] init];
        data.day = i;
        
        NSMutableArray *arrSchedule = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            ScheduleData *data = [[ScheduleData alloc] init];
            [data setScheduleDataTitle:arrDay[i] time:arrTime[i] isOn:YES];
            [arrSchedule addObject:data];
        }
        data.arrScheduleData = arrSchedule;
        
        [arrScheduleData addObject:data];
    }
}*/

- (void)setday:(NSInteger)day
{
    if(day<0 || day>6)
        return;
    
    NSArray *arrDay = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    _lblDay.text = arrDay[day];
    [_tblView reloadData];
}

- (IBAction)onClickLeftArrow:(id)sender
{
    if(_dayType <= 0)
        return;
    
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    
    CGRect tblOriginal = _tblView.frame;
    
    CGRect tblFrame = _tblView.frame;
    tblFrame.origin.x -= 320;
    _tblView.frame = tblFrame;
    
    [UIView animateWithDuration:0.3/1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tblView.frame = tblOriginal;
    } completion:^(BOOL finished) {
        btn.userInteractionEnabled = YES;
    }];
    
    [self setday:_dayType <= 0 ? 0 :--_dayType];
}

- (IBAction)onClickRightArrow:(id)sender
{
    if(_dayType >= 6)
        return;
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    
    CGRect tblOriginal = _tblView.frame;
    
    CGRect tblFrame = _tblView.frame;
    tblFrame.origin.x += 320;
    _tblView.frame = tblFrame;
    
    [UIView animateWithDuration:0.3/1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tblView.frame = tblOriginal;
    } completion:^(BOOL finished) {
        btn.userInteractionEnabled = YES;
    }];
    
    [self setday: _dayType >= 6 ? 6 : ++_dayType];
}

- (IBAction)onClickFollowScheduleBtn:(id)sender
{
    _btnFollowSched.selected = !_btnFollowSched.isSelected;
    
    if(_btnFollowSched.isSelected){
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please note if this option is chosen, HuddleFly will follow the schedule for this day for the whole week!"
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [DeviceScheduleCell setFollowThisScheduleOn:YES];
        
        ScheduleDayData *data = [arrScheduleData objectAtIndex:_dayType];
       
        for(int i = 0 ; i < arrScheduleData.count ; i++){
            
            if(i == _dayType){
                continue;
            }else{
                ScheduleDayData *dataDay = [arrScheduleData objectAtIndex:i];
                dataDay.arrScheduleData = data.arrScheduleData ;
            }
        }
        [self setFollowThisScheduleApi];
    }
    else{
        [DeviceScheduleCell setFollowThisScheduleOn:NO];
        
        for(int i = 0 ; i < arrScheduleData.count ; i++){
            
            if(i == _dayType){
                continue;
            }else{
                ScheduleDayData *dataDay = [arrScheduleData objectAtIndex:i];
                NSMutableArray *arrSchedule = [[NSMutableArray alloc] init];
                for (int i = 0; i < dataDay.arrScheduleData.count; i++) {
                    ScheduleData *data = [[ScheduleData alloc] init];
                    ScheduleData *d = dataDay.arrScheduleData[i];
                    [data setScheduleDataTitle:d.strTitleSchedule time:d.strTimeSchedule isOn:d.isSwtOn];
                    [arrSchedule addObject:data];
                }
                dataDay.arrScheduleData = arrSchedule;
            }
        }
    }
    [_tblView reloadData];
}

- (IBAction)onClickActivateBtn:(id)sender
{
    //_swtActiveSched.on = !_swtActiveSched.isOn;
    
//    if(_swtActiveSched.isOn){
        [self setActiveScheduleApi];
//    }
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellScheduleTitle"];
        if(cell == nil){
            cell = [[UITableViewCell alloc] init];
        }
        return cell;
    }else{
        
        DeviceScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSchedule"];
        if (cell == nil) {
            cell = [[DeviceScheduleCell alloc] init];
        }
        if(arrScheduleData.count > 0){
            ScheduleDayData *data = [arrScheduleData objectAtIndex:_dayType];
            [cell setData:data.arrScheduleData[(indexPath.row-1)] image:nil];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return  35;
    }else{
        return 50;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Api Calls

- (void)getDeviceScheduleApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSLog(@"Get Device Schedule Api Dict:%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_GET_DEVICE_SCHEDULE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Get Device Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSArray *arrResponse = (NSArray *)response;
                if(arrResponse.count == 28){
                    
                    for(int i = 0 ; i < 7 ; i++){
                        ScheduleDayData *data = [[ScheduleDayData alloc] init];
                        data.day = i;
                        
                        NSMutableArray *arrSchedule = [[NSMutableArray alloc] init];
                        for (int j = (i*4); j < ((i*4) + 4); j++) {
                            ScheduleData *data = [[ScheduleData alloc] init];
                            [data setData:arrResponse[j]];
                            [arrSchedule addObject:data];
                        }
                        data.arrScheduleData = arrSchedule;
                        
                        [arrScheduleData addObject:data];
                    }
                    [_tblView reloadData];
                    
                    [self getIsScheduleActiveApi];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

/*Response in bool
 true or false
*/

- (void)getIsScheduleActiveApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSLog(@"Get IS Schedule Api Dict:%@",dictParam);
    
    [afn getStringFromPath:kAPI_PATH_GET_IS_SCHEDULE_ACTIVE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Get IS Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSNumber class]]) {
                int resp = [response intValue];
                if(resp == 0){
                    _swtActiveSched.on = NO;
                }else{
                    _swtActiveSched.on = YES;
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)setActiveScheduleApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
//    NSNumber *swchState;

    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
//    [dictParam setObject:swchState forKey:kAPI_PARAM_ISSCHEDULEACTIVE];
    if (self.swtActiveSched.isOn) {
        [dictParam setObject:@"true" forKey:kAPI_PARAM_ISSCHEDULEACTIVE];
    }else{
        [dictParam setObject:@"false" forKey:kAPI_PARAM_ISSCHEDULEACTIVE];
    }
    NSLog(@"Set Active Schedule Api Dict:%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_ACTIVE_SCHEDULE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Set Active Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSArray class]]) {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Schedule Activated"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)setFollowThisScheduleApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *strDayOfWeek = [NSString stringWithFormat:@"%ld",(long)_dayType];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:strDayOfWeek forKey:@"DayOfWeek"];
    
    NSLog(@"Set Follow this Schedule Api Dict:%@",dictParam);
    
    [afn getDataFromPath:@"FollowThisSchedule" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSLog(@"Set Follow this Schedule Response :%@",response);
            
            if ([response isKindOfClass:[NSArray class]]) {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This schedule followed."];
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
