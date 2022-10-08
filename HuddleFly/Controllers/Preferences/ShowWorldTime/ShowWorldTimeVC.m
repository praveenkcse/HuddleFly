//
//  ShowWorldTimeVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "ShowWorldTimeVC.h"
#import "ShowWorldTime.h"
#import "ShowWorldTimeCell.h"
#import "Global.h"
@interface ShowWorldTimeVC ()

@end

@implementation ShowWorldTimeVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrWorldTime = [[NSMutableArray alloc] init];
    arrSaveData  = [[NSMutableArray alloc] init];
//    self.tblWorldTime.layer.borderColor = [UIColor blackColor].CGColor;
//    self.tblWorldTime.layer.borderWidth = 1.0;
//    self.tblWorldTime.clipsToBounds = YES;
    
    [super setNavBarTitle:@"Show World Time"];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    [self getCountryAndCityName];
    [Global roundBorderSet:_txtSearchKeyword];
    [Global roundBorderSet:_updateBtn];
}

- (NSString *)helpPath {
    return @"7-1";
}

-(void)viewDidDisappear:(BOOL)animated
{
    [arrSaveData removeAllObjects];
    arrSaveData = nil;
    [arrWorldTime removeAllObjects];
    arrWorldTime = nil;
    [super viewDidDisappear:animated];
}

-(void)getCountryAndCityName
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [afn getDataFromPath:kAPI_PATH_GET_WORLDTIMEZIPCODES withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [arrWorldTime removeAllObjects];
                [arrSaveData removeAllObjects];
                for (NSDictionary *dict in response) {
                    ShowWorldTime *t = [[ShowWorldTime alloc] init];
                    [t setData:dict];
                    [arrWorldTime addObject:t];
                    [arrSaveData addObject:t];
                }
                [self getWTZipCode];
                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getWTZipCode
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_WTZIPCODES withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response)
        {
            [UtilityClass reset];
            [UtilityClass setSelectionLimit:4];
            
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strWtZipcode = [dict objectForKey:kAPI_PARAM_WTZIPCODEIDS];
            NSArray *arrZipcode = [strWtZipcode componentsSeparatedByString:@","];
            NSMutableArray *arrTemp = [arrWorldTime mutableCopy];
            
            for (int i = 0 ; i < arrZipcode.count ; i++)
            {
                int ids = [[arrZipcode objectAtIndex:i] intValue];
                
                for(int j = 0 ; j < arrTemp.count ; j++)
                {
                    ShowWorldTime *t = arrWorldTime[j];
                    if (t.ID == ids)
                    {
                        t.isSelected = YES;
                        [UtilityClass countIncrement];
                        break;
                    }
                }
            }
//             [self.tblWorldTime reloadData];
            //[self getClockType];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [self.tblWorldTime reloadData];
    }];
}

- (void)getClockType
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_CLOCKTYPE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strClockType = [dict objectForKey:kAPI_PARAM_ISDIGITAL];
            if([strClockType isEqualToString:@"0"])
            {
                [self onClickAnalogClock:self];
            }
            else{
                [self onClickDigitalClock:self];
            }
            //[self.tblWorldTime reloadData];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [self.tblWorldTime reloadData];
    }];
}



#pragma mark - Actions

- (IBAction)onClickAnalogClock:(id)sender {
    self.btnAnalogClock.selected = YES;
    self.btnDigitalClock.selected = NO;
    [[User currentUser] setISDIGITAL:@"0"];
}

- (IBAction)onClickDigitalClock:(id)sender {
    self.btnAnalogClock.selected = NO;
    self.btnDigitalClock.selected = YES;
    [[User currentUser] setISDIGITAL:@"1"];
}

- (IBAction)onClickNone:(id)sender {
    self.btnCity.selected = NO;
    self.btnCountry.selected = NO;
    self.btnNone.selected = YES;
    self.txtSearchKeyword.text = @"";
    self.txtSearchKeyword.enabled = NO;
    [self onClickGo:self];
}

- (IBAction)onClickCountry:(id)sender {
    self.btnCity.selected = NO;
    self.btnCountry.selected = YES;
    self.btnNone.selected = NO;
    self.txtSearchKeyword.enabled = YES;
}

- (IBAction)onClickCity:(id)sender {
    self.btnCity.selected = YES;
    self.btnCountry.selected = NO;
    self.btnNone.selected = NO;
    self.txtSearchKeyword.enabled = YES;
}

- (IBAction)onClickGo:(id)sender {
    
    if(self.btnNone.isSelected)
    {
        self.txtSearchKeyword.text = @"";
        [arrWorldTime removeAllObjects];
        arrWorldTime = [arrSaveData mutableCopy];
        [self.tblWorldTime reloadData];
        return;
    }
    NSMutableArray *arrTemp = [arrSaveData mutableCopy];
    [arrWorldTime removeAllObjects];
    
    for(ShowWorldTime *t in arrTemp)
    {
        NSString *filter = self.txtSearchKeyword.text;
        BOOL bFound = NO;
        NSRange rangeValue ;
        
        if(self.btnCountry.isSelected)
        {
            rangeValue = [t.strCountry rangeOfString:filter options:NSCaseInsensitiveSearch];
            if ((rangeValue.length > 0) || ([filter isEqualToString:@""])) {
                bFound = YES;
            }
        }
        else if (self.btnCity.isSelected)
        {
            rangeValue = [t.strCity rangeOfString:filter options:NSCaseInsensitiveSearch];
            if ((rangeValue.length > 0) || ([filter isEqualToString:@""])) {
                bFound = YES;
            }
        }
        
        if(bFound)
            [arrWorldTime addObject:t];
    }
    [self.tblWorldTime reloadData];
    
}

- (IBAction)onClickSubmit:(id)sender {
    /*if (self.txtSearchKeyword.text.length > 0) {
        [[User currentUser] setWTZIPCODEIDS:self.txtSearchKeyword.text];
    }*/
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getISDIGITAL] forKey:kAPI_PARAM_ISDIGITAL];
    NSString *strZipcode = @"";
    BOOL comma = NO;
    for(int i = 0 ; i < arrSaveData.count ; i++)
    {
        ShowWorldTime *t = [arrSaveData objectAtIndex:i];
        if(t.isSelected)
        {
            if(comma)
                strZipcode = [strZipcode stringByAppendingString:@","];
            strZipcode = [strZipcode stringByAppendingString:[NSString stringWithFormat:@"%d",t.ID]];
            comma = YES;
        }
    }
    [dictParam setObject:strZipcode forKey:kAPI_PARAM_WTZIPCODEIDS];
    NSLog(@"Dictionary :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_UPDATE_WORLDTIME withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Time Updated successfully."];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.btnNone.isSelected){//Added By DHAWAL 30-Jun-2016
        return NO;
    }
    [self onClickGo:self];
    return YES;
}

#pragma mark - Tableview DataSourace

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWorldTime.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowWorldTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowWorldTimeCell"];
    if (cell == nil)
    {
        cell = [[ShowWorldTimeCell alloc] init];
    }
    ShowWorldTime *timedata = [arrWorldTime objectAtIndex:indexPath.row];
    [cell setCellData:timedata];
    
    return cell;
}

#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
