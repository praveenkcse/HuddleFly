//
//  LocalEventsVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "LocalEventsVC.h"
#import "LocalEvents.h"
#import "ShowWorldTimeCell.h"
#import "Global.h"
@interface LocalEventsVC ()

@end

@implementation LocalEventsVC

#pragma mark - Life Cycle

- (NSString *)helpPath {
    return @"8-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrLocalEvents = [[NSMutableArray alloc] init];
    
    oldFrame = self.tblLocation.frame;
    
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    [super onTouchHideKeyboard];
    self.tblLocation.layer.borderColor = [UIColor blackColor].CGColor;
    self.tblLocation.layer.borderWidth = 1.0;
    self.tblLocation.clipsToBounds = YES;
    [self getLocalEventsCategorys];
    [Global roundBorderSet:_txtKeyword];
    [Global roundBorderSet:_txtZipcode];
    [Global roundBorderSet:_txtSearchIn];
    [Global roundBorderSet:_updateBtn];
}

#pragma mark - Api

-(void)getLocalEventsCategorys
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_EVENTCATEGORY withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSArray *arrData = [response objectForKey:@"category"];
            
            if(arrData.count > 0)
            {
                [arrLocalEvents removeAllObjects];
                for (NSDictionary *dict in arrData) {
                    LocalEvents *local = [[LocalEvents alloc] init];
                    [local setData:dict];
                    [arrLocalEvents addObject:local];
                }
                [self getLocalEvents];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getLocalEvents
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_LOCALEVENTS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response)
        {
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strEventKeyword = [dict objectForKey:kAPI_PARAM_EVENTKEYWORD];
            NSString *strEventzipcode = [dict objectForKey:kAPI_PARAM_EVENTLOCATION];
            NSString *strTimeChoice = [dict objectForKey:kAPI_PARAM_TIMECHOICE];
            NSString *strSearch = [[dict objectForKey:kAPI_PARAM_SEARCHWITHIN] stringValue];
            NSString *strSearchOn = [dict objectForKey:kAPI_PARAM_EVENTSEARCHON];
            if([strSearchOn isEqualToString:@"category"])
            {
                self.btnChooseEvent.selected = YES;
                self.btnEnterKeyword.selected = NO;
                [self hidePanel];
            }
            else
            {
                self.btnChooseEvent.selected = NO;
                self.btnEnterKeyword.selected = YES;
                
                if (strSearchOn == nil || [strSearchOn isEqualToString:@""])
                {
                    self.btnChooseEvent.selected = NO;
                    self.btnEnterKeyword.selected = NO;
                }
            }
            self.txtKeyword.text = strEventKeyword;
            self.txtZipcode.text = strEventzipcode;
            
            self.txtSearchIn.text = strSearch;
            if([strTimeChoice isEqualToString:@"ThisWeek"])
            {
                [self onClickThisWeek:self];
            }
            else if ([strTimeChoice isEqualToString:@"NextWeek"])
            {
                [self onClickNextWeek:self];
            }
            else if ([strTimeChoice isEqualToString:@"ThisMonth"])
            {
                [self onClickThisMonth:self];
            }
            strEventCategory = [dict objectForKey:kAPI_PARAM_EVENTCATEGORY];
            
            
            [UtilityClass reset];
            [UtilityClass setSelectionLimit:1];
            //[UtilityClass countIncrement];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [self.tblLocation reloadData];
    }];
}

-(void)updateLocalEvents
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getEVENTTIMECHOICE] forKey:kAPI_PARAM_TIMECHOICE];
    NSString *strCategory = @"";
    for(int i = 0 ; i < arrLocalEvents.count ; i++)
    {
        LocalEvents *local = [arrLocalEvents objectAtIndex:i];
        if(local.isSelected)
        {
            strCategory = local.strId;
            break;
        }
    }
    [dictParam setObject:strCategory forKey:kAPI_PARAM_EVENTCATEGORY];
    [dictParam setObject:[[User currentUser] getEVENTLOCATION] forKey:kAPI_PARAM_EVENTLOCATION];
    [dictParam setObject:[[User currentUser] getSEARCHWITHIN] forKey:kAPI_PARAM_SEARCHWITHIN];
    [dictParam setObject:[[User currentUser] getEVENTSEARCHON] forKey:kAPI_PARAM_EVENTSEARCHON];
    [dictParam setObject:[[User currentUser] getEVENTKEYWORD] forKey:kAPI_PARAM_EVENTKEYWORD];
    
    NSLog(@"Dictionary :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_UPDATE_LOCALEVENTS withParamData:dictParam withBlock:^(id response, NSError *error) {
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

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    
    if (self.txtSearchIn.text.length > 0) {
        [[User currentUser] setSEARCHWITHIN:self.txtSearchIn.text];
    }
    if (self.txtKeyword.text.length > 0) {
        if (self.btnEnterKeyword.selected) {
            [[User currentUser] setEVENTKEYWORD:self.txtKeyword.text];
        }
        else{
            [[User currentUser] setEVENTCATEGORY:self.txtKeyword.text];
        }
    }
    if (self.txtZipcode.text.length > 0) {
        [[User currentUser] setEVENTLOCATION:self.txtZipcode.text];
    }
    
    [self updateLocalEvents];
}

- (void)hidePanel
{
    if(self.viewPanel.isHidden && !_btnChooseEvent.isSelected)
    {
        self.viewPanel.hidden = NO;
        CGRect tblFrame = self.tblLocation.frame;
        tblFrame.origin = oldFrame.origin;
        tblFrame.size.height = self.lblMsgEvent.frame.origin.y-(self.viewPanel.frame.origin.y+self.viewPanel.frame.size.height);
        self.tblLocation.frame = tblFrame;
    }
    else if(!_btnEnterKeyword.isSelected){
        self.viewPanel.hidden = YES;
        CGRect frame = self.viewPanel.frame;
        CGRect tblFrame = self.tblLocation.frame;
        tblFrame.origin = frame.origin;
        tblFrame.size.height = self.lblMsgEvent.frame.origin.y-self.viewPanel.frame.origin.y;
        self.tblLocation.frame = tblFrame;
    }
}


- (IBAction)onClickEventCat:(id)sender {
    
    self.btnEnterKeyword.selected = NO;
    self.btnChooseEvent.selected = YES;
    
    [self hidePanel];
    [[User currentUser] setEVENTSEARCHON:@"category"];
}

- (IBAction)onClickEnterKeyword:(id)sender {
    
    self.btnEnterKeyword.selected = YES;
    self.btnChooseEvent.selected = NO;
    
    [self hidePanel];
    [[User currentUser] setEVENTSEARCHON:@"keyword"];
}

- (IBAction)onClickThisWeek:(id)sender {
    self.btnNextWeek.selected = NO;
    self.btnThisMonth.selected = NO;
    self.btnThisWeek.selected = YES;
    [[User currentUser] setEVENTTIMECHOICE:@"ThisWeek"];
}

- (IBAction)onClickNextWeek:(id)sender {
    self.btnNextWeek.selected = YES;
    self.btnThisMonth.selected = NO;
    self.btnThisWeek.selected = NO;
    [[User currentUser] setEVENTTIMECHOICE:@"NextWeek"];
}

- (IBAction)onClickThisMonth:(id)sender {
    self.btnNextWeek.selected = NO;
    self.btnThisMonth.selected = YES;
    self.btnThisWeek.selected = NO;
    [[User currentUser] setEVENTTIMECHOICE:@"ThisMonth"];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    
    if (textField == self.txtSearchIn || textField == self.txtZipcode) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
        if(textField == self.txtZipcode)
            if (self.txtZipcode.text.length == 5)
            {
                return NO;
            }
    }
    return YES;
}

#pragma mark - Tableview Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrLocalEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowWorldTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocalEventCell"];
    if(cell == nil)
    {
        cell = [[ShowWorldTimeCell alloc] init];
    }
    
    LocalEvents *localdata = [arrLocalEvents objectAtIndex:indexPath.row];
    if([localdata.strId isEqualToString:strEventCategory])
        if(!localdata.isSelected)
        {
            localdata.isSelected = YES;
            [UtilityClass countIncrement];
        }
    [cell setCellData:localdata];
    
    return cell;
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
