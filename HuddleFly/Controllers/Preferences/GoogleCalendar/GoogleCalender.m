//
//  GoogleCalender.m
//  HuddleFly
//
//  Created by BMAC on 17/08/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "GoogleCalender.h"
#import "PreferencesCell.h"
#import "LocalEvents.h"
#import "ShowWorldTimeCell.h"
#import "DickColorPicker.h"
#import "GoogleLoginClass.h"
#import "ActionSheetPicker.h"
#import "Global.h"

@interface GoogleCalender ()<DickColorPickerDelegate,GoogleLoginClassDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //NSString *strHexCode;
    //NSString *strSelectedCalenderId;
    NSString *strGoogleUserEmailId;
    NSInteger selectedSection;
    
    GoogleLoginClass *google;
    
    NSArray *_calenderViewValues;
    NSMutableArray *arrNumber;
}
@end

@implementation GoogleCalender

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavBarTitle: self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017
    arrNumber = [[NSMutableArray alloc] init];
    [self getTransitions];
    [Global roundBorderSet:_btnDropDown];
    [Global roundBorderSet:_btnGoogle];
    [_btnDropDown setBackgroundColor:UIColor.whiteColor];
    [_btnDropDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //self.btnLogout.enabled = NO;
    
    selectedSection = -1;
    
    arrGoogleCalendar = [[NSMutableArray alloc] init];
    [arrGoogleCalendar removeAllObjects];
    [self.tblCalender reloadData];
    
    NSString *strDropDownTitle = [[User currentUser] getCALENDARVIEWforDevice:[[User currentUser] getDeviceId]];
    
    if(strDropDownTitle && strDropDownTitle.length > 0){
        [_btnDropDown setTitle:strDropDownTitle forState:UIControlStateNormal];
    }else{
        [_btnDropDown setTitle:@"Month" forState:UIControlStateNormal];
    }
    
    [_btnDropDown setContentEdgeInsets:UIEdgeInsetsMake(6, 14, 6, 14)];
    [_btnDropDown sizeToFit];
    
    /*if (![GoogleLoginClass isTokenExpire]) {
        self.btnLogout.enabled = YES;
        [self performSelector:@selector(calendarApi) withObject:nil afterDelay:0.1];
    }
    else{*/
        [self getSavedDataFromUserDefaults];
    //}
    [self getTransition];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
//    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
//    [dictParam setObject:_btnDropDown.currentTitle forKey:@"CalendarView"];
    
    [afn getDataFromPath:@"GetCalendarViewList" withParamData:dictParam withBlock:^(id response, NSError *error) {
//        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error == nil) {
            if([response isKindOfClass:[NSArray class]])
            {
                NSMutableArray *result = [NSMutableArray new];
                NSArray *arr = (NSArray *)response;
                for (NSDictionary *obj in arr) {
                    [result addObject:obj[@"Value"]];
                }
                _calenderViewValues = result;
                
                NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
                [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
                [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
                [afn getDataFromPath:@"GetCalendarView" withParamData:dictParam withBlock:^(id response, NSError *error) {
                    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                    if (response && error == nil) {
                        if([response isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *dict = (NSDictionary *)response;
                            NSString *calView = dict[@"CalendarView"];
                            [_btnDropDown setTitle:calView forState:UIControlStateNormal];
                            [_btnDropDown sizeToFit];
                        }
                    }else{
                        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                    }
                }];
            }
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark -
#pragma mark - Color Picker
#pragma mark -

- (IBAction)onClickOpenColorPicker:(id)sender
{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    viewBg.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    viewBg.tag = 123456;
    [self.view addSubview:viewBg];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 150)];
    view.layer.cornerRadius = 6.0;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.shadowOpacity = 0.7;
    [view setBackgroundColor:[UIColor grayColor]];
    [viewBg addSubview:view];
    
    UIButton *btnCloser = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCloser.frame = CGRectMake(10, 10, 30, 30);
    [btnCloser addTarget:self action:@selector(closePicker:) forControlEvents:UIControlEventTouchUpInside];
    [btnCloser setTitle:@"X" forState:UIControlStateNormal];
    [btnCloser setBackgroundColor:[UIColor blackColor]];
    btnCloser.layer.cornerRadius = 15.0;
    [view addSubview:btnCloser];
    
    CGRect rect = CGRectMake(20, 40, view.frame.size.width-40, 100);
    DickColorPicker *picker = [[DickColorPicker alloc] initWithFrame:rect];
    picker.delegate = self;
    picker.colorPickerType = 2;
    picker.selectedColor = _btnColorPicker.titleLabel.textColor;
    [view addSubview:picker];
}

- (void)closePicker:(id)sender
{
    [[self.view viewWithTag:123456] removeFromSuperview];
}

#pragma mark - Color picker Delegate

- (void)colorPicked:(UIColor *)color
{
    int section = _btnColorPicker.tag - 20.0;
    GoogleData *data = [arrGoogleCalendar objectAtIndex:section];
    data.strColor = [self hexStringFromColor:color];
    
    [_btnColorPicker setTitleColor:color forState:UIControlStateNormal];
    //strHexCode = [self hexStringFromColor:color];
}

#pragma mark - Color To Hex

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    if(!hexString || hexString.length == 0)
        return nil;
    
    NSString *hexLetter = [hexString substringToIndex:1];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if([hexLetter isEqualToString:@"#"])
        [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark -
#pragma mark - Actions
#pragma mark -
/*
- (IBAction)onClickMonth:(id)sender {
    self.btnWeek.selected = NO;
    self.btnMonth.selected = YES;
    self.btnDay.selected = NO;
}

- (IBAction)onClickWeek:(id)sender {
    self.btnWeek.selected = YES;
    self.btnMonth.selected = NO;
    self.btnDay.selected = NO;
}

- (IBAction)onClickDay:(id)sender
{
    self.btnDay.selected = YES;
    self.btnMonth.selected = NO;
    self.btnWeek.selected = NO;
}*/

/*- (IBAction)onClickshowTask:(id)sender
{
    _btnShowTask.selected = !_btnShowTask.isSelected;
}*/

- (IBAction)onClickDropdown:(UIButton *)sender
{
    NSArray *arr = _calenderViewValues;//@[@"Month", @"Week", @"Day", @"Month-Week-Day"];
    
    NSInteger index = 0;
    NSString *strDropDownTitle = [[User currentUser] getCALENDARVIEWforDevice:[[User currentUser] getDeviceId]];
    
    if(strDropDownTitle && strDropDownTitle.length > 0){
        [_btnDropDown setTitle:strDropDownTitle forState:UIControlStateNormal];
        
        if([arr containsObject:strDropDownTitle]){
            index = [arr indexOfObject:strDropDownTitle];
        }
    }else{
        [_btnDropDown setTitle:@"Month" forState:UIControlStateNormal];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Time Period" rows:arr initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [sender setTitle:[arr objectAtIndex:selectedIndex] forState:UIControlStateNormal];
        [sender sizeToFit];
        [self updateCalendatViewApi];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)onClickGoogleLogin:(id)sender
{
    [self onClickLogout:self];
    
    google = [[GoogleLoginClass alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height)];
    google.delegate = self;
    
    if([GoogleLoginClass isTokenExpire]){
        [google authenticationWithGoogle:self];
        
        return;
        [google authenticationWithGoogle];

        //[self.view addSubview:google];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:google];
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:0 animations:^{
            google.frame = [[UIScreen mainScreen] applicationFrame];
        }completion:^(BOOL finished) {
        }];
    }else{
        [google fetchUserLoginDetail];
    }
}

- (IBAction)onClickLogout:(id)sender
{
    [GoogleLoginClass clearCookie];
}

#pragma mark -
#pragma mark - Google Login Delegate
#pragma mark -

- (void)startProcessingGoogle
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
}

- (void)stopProcessingGoogle
{
    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
}

- (void)finishGoogleFetchingWithResponse:(NSDictionary *)dict error:(NSError *)err
{
    if(dict){
        
        //NSString *strFirst = dict[@"name"][@"givenName"];
        //NSString *strlast = dict[@"name"][@"familyName"];
        //NSString *strUrl = dict[@"image"][@"url"];
        
        NSArray *arrEmail = dict[@"emails"];
        
        if(arrEmail.count){
            NSDictionary *d = arrEmail[0];
            strGoogleUserEmailId = [d valueForKey:@"value"];
        }else{
            strGoogleUserEmailId = @"";
        }
        [[User currentUser] setGOOGLELOGOUT:@"1"];
        [self calendarApi];
    }
}



#pragma mark -
#pragma mark - UITableview Datasorce
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrGoogleCalendar.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == selectedSection)
    {
        GoogleData *data = (GoogleData *)arrGoogleCalendar[section];
        return data.arrGoogleDisplayData.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tblCalender.frame.size.width, 70)];
    [view setBackgroundColor:[UIColor grayColor]];
    view.tag = 2000 + section;
    
    GoogleData *data = (GoogleData *)arrGoogleCalendar[section];
    UILabel *lblEmail = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, view.frame.size.width - 110, 25)];
    lblEmail.text = data.strEmail;
    [view addSubview:lblEmail];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 150, 5, 140, 25)];
    [btn setTitle:@"Remove Account" forState:UIControlStateNormal];
    [btn setTag:section + 1];
    [btn addTarget:self action:@selector(logoutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 6.0;
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UIButton *btnShowTask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShowTask.frame = CGRectMake(8, lblEmail.frame.size.height + 10, 150, 25);
    btnShowTask.tag = section + 10;
    [btnShowTask addTarget:self action:@selector(showTaskPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnShowTask.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnShowTask setImage:[UIImage imageNamed:@"btnUnSelectedRedio"] forState:UIControlStateNormal];
    [btnShowTask setImage:[UIImage imageNamed:@"btnSelectedRedio"] forState:UIControlStateSelected];
    [btnShowTask setTitle:@" Show Task" forState:UIControlStateNormal];
    [view addSubview:btnShowTask];
    btnShowTask.layer.borderColor = [UIColor whiteColor].CGColor;
    btnShowTask.layer.borderWidth = 1.0;
    if(data.isShowTask){
        btnShowTask.selected = YES;
    }
    
    UIButton *btnColorPicker = [UIButton buttonWithType:UIButtonTypeCustom];
    btnColorPicker.frame = CGRectMake(view.frame.size.width - 110, lblEmail.frame.size.height + 10, 100, 25);
    [btnColorPicker setTitle:@"Color Picker" forState:UIControlStateNormal];
    btnColorPicker.tag = section + 20;
    [btnColorPicker addTarget:self action:@selector(colorPickerPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnColorPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    btnColorPicker.layer.borderWidth = 1.0;
    if(data.strColor.length > 0)
        [btnColorPicker setTitleColor:[self colorFromHexString:data.strColor] forState:UIControlStateNormal];
    else [btnColorPicker setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:btnColorPicker];
    
    UIButton *btnHideShow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHideShow.frame = CGRectMake(view.frame.size.width - 110, btnColorPicker.frame.origin.y + btnColorPicker.frame.size.height + 5, 100, 25);
    if(section == selectedSection)
        [btnHideShow setTitle:@"Hide" forState:UIControlStateNormal];
    else
        [btnHideShow setTitle:@"Show" forState:UIControlStateNormal];
    btnHideShow.tag = section + 30;
    [btnHideShow addTarget:self action:@selector(showSectionRows:) forControlEvents:UIControlEventTouchUpInside];
    btnHideShow.layer.borderColor = [UIColor whiteColor].CGColor;
    btnHideShow.layer.borderWidth = 1.0;
    [view addSubview:btnHideShow];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(8,btnColorPicker.frame.origin.y + btnColorPicker.frame.size.height + 5, 150, 25);
    [btnSubmit setTitle:@"Save Calendar(s)" forState:UIControlStateNormal];
    btnSubmit.tag = section + 40;
    [btnSubmit addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.layer.borderColor = [UIColor whiteColor].CGColor;
    btnSubmit.layer.borderWidth = 1.0;
    [view addSubview:btnSubmit];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowWorldTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoogleCalendarCell"];
    if(cell == nil)
    {
        cell = [[ShowWorldTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoogleCalendarCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoogleData *g = arrGoogleCalendar[indexPath.section];
    GoogleDisplayData *data = (GoogleDisplayData *)g.arrGoogleDisplayData[indexPath.row];
    [cell setCellData:data];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableview Delegate
#pragma mark -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Logout Btn

- (void)logoutBtnPressed:(UIButton *)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Remove Account" message:@"Do you really want to remove this account?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Logout");
                                                              int section = sender.tag - 1.0;
                                                              GoogleData *d = [self->arrGoogleCalendar objectAtIndex:section];
                                                              [self logoutApi:d];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:defaultAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showTaskPressed:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    int section = sender.tag - 10.0;
    GoogleData *data = [arrGoogleCalendar objectAtIndex:section];
    data.isShowTask = sender.isSelected;
}

- (void)colorPickerPressed:(UIButton *)sender
{
    _btnColorPicker = sender;
    [self onClickOpenColorPicker:sender];
}

- (void)showSectionRows:(UIButton *)sender
{
    if([sender.currentTitle isEqualToString:@"Hide"]){
        selectedSection = -1;
    }
    else{
        int section = sender.tag - 30.0;
        selectedSection = section;
    }
    [_tblCalender reloadData];
}

- (void)logoutApi:(GoogleData *)accountId
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:accountId.strAccountID?accountId.strAccountID:@"" forKey:@"AccountID"];
    
    [afn getDataFromPath:@"RemoveSocialAccount" withParamData:dictParam withBlock:^(id response, NSError *error) {
        NSLog(@"Response :%@",response);
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        
        if(response && error == nil){
            [arrGoogleCalendar removeObject:accountId];
            [_tblCalender reloadData];
            [[User currentUser] setCALENDARID:arrGoogleCalendar];
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Logout Successfully"];
            [self showLogoutAlert];
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
    
    
}


-(void) showLogoutAlert{
    UtilityClass *utility = [[UtilityClass alloc] init];
    [utility showAlertWithTitle:@"Logout Alert" andMessage:@"\nYou are logged out of your HuddleFly Google account, however you need to clear your browser history in-order to login using different gmail account."];
}



- (void)submitBtnPressed:(UIButton *)sender
{
    int section = sender.tag - 40.0;
    
    GoogleData *data = [arrGoogleCalendar objectAtIndex:section];
    
    [self updateSocialAccountApi:data];
}

- (void)updateSocialAccountApi:(GoogleData *)data
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"1" forKey:@"SocialAccountType"];
    
    NSString *strAuthCode =  data.strServerAuthCode; //[GoogleLoginClass getGoogleRefreshToken];
    if(!strAuthCode)
        strAuthCode = @"";
    [dictParam setObject:strAuthCode forKey:@"ServerAuthCode"];
    
    
    
    NSString *strRefresh =  data.strRefreshToken; //[GoogleLoginClass getGoogleRefreshToken];
    if(!strRefresh)
        strRefresh = @"";
    [dictParam setObject:strRefresh forKey:@"RefreshToken"];
    
    
    NSString *strEmail = data.strEmail;//strGoogleUserEmailId;
    if(!strEmail)
        strEmail = @"";
    [dictParam setObject:strEmail forKey:@"AccountEmail"];
    
    
    //if(!strHexCode)
    //  strHexCode = @"#ffffff";
    
    [dictParam setObject:data.strColor forKey:@"CalendarColor"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *namesArr = [[NSMutableArray alloc] init];
    if(data.arrGoogleDisplayData > 0)
    {
        for(int i = 0; i < data.arrGoogleDisplayData.count ; i++)
        {
            GoogleDisplayData *f = data.arrGoogleDisplayData[i];
            if(f.isSelected)
            {
                [arr addObject:f.strId];
                [namesArr addObject:f.strName];
            }
        }
    }
    NSString *strId = @"";
    if(arr.count > 0)
        strId = [arr componentsJoinedByString:@","];
    
    NSString *strCalenderid  = strId;//strSelectedCalenderId
    if(!strCalenderid)
        strCalenderid = @"";
    
    NSString *namesStr = @"";
    if(namesArr.count > 0)
        namesStr = [namesArr componentsJoinedByString:@","];

    NSString *strCalenderName  = namesStr;
    if(!strCalenderName)
        strCalenderName = @"";

    
    [dictParam setObject:strCalenderid forKey:@"CalendarOrFBIDs"];
    [dictParam setObject:strCalenderName forKey:@"CalendarOrFBNames"];

    if(data.isShowTask){//_btnShowTask.isSelected
        [dictParam setObject:@"true" forKey:@"ShowTask"];
    }else{
        [dictParam setObject:@"false" forKey:@"ShowTask"];
    }
    
    [dictParam setObject:@"false" forKey:@"IsFullScreen"];

    //[dictParam setObject:data.calendarDict forKey:@"CalendarDict"];

    NSLog(@"Update Parameter Dictionary :%@",dictParam);
    
    [afn getDataFromPath:@"UpdateSocialAccount" withParamData:dictParam withBlock:^(id response, NSError *error) {
        NSLog(@"Response :%@",response);
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        
        if(response && error == nil){
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            
            [self getSocialAccounts];
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - Calendar

- (void) getTransitions
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:@"GetTransitionList" withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrNumber removeAllObjects];
                for (NSDictionary *dict in response) {
                    Transition *d = [[Transition alloc] init];
                    [d setData:dict];
                    [arrNumber addObject:d];
                }
                
            }
        }
    }];
}


- (IBAction)onClickTextField:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
//    [arrNumber removeAllObjects];
    
    NSString* pickerTitle;
    
    //    if (sender == self.pixTransitionTextField) {
    //
    //        arrNumber = [NSMutableArray arrayWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", nil];
//    for (int i = 5 ; i <= 60; i++) {
//        [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
//    }
    pickerTitle = @"Transition Duration(in Seconds)";
    NSMutableArray *transitions = [[NSMutableArray alloc] init];
       for (int i = 0 ; i < arrNumber.count; i++) {
           Transition * obj = [arrNumber objectAtIndex:i];
           [transitions addObject: obj.value];
       }
       [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:transitions initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
           
           sender.text = transitions[selectedIndex];
       } cancelBlock:^(ActionSheetStringPicker *picker) {
           
       } origin:sender];
       
    
    
}


- (void) getTransition
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:@"GetCalTransit" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            NSString *transit = [dict objectForKey:@"CalTransit"];
            if (transit == nil){
                self.pixTransitionTextField.text = [dict objectForKey:@"FBTransit"];
            }else{
                self.pixTransitionTextField.text = transit;
            }
            
        }
    }];
}


- (void) updateTransition
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:_pixTransitionTextField.text forKey:@"CalTransit"];
    
    [afn getDataFromPath:@"UpdateCalTransit" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
        }
    }];
}



-(void)calendarApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    //https://www.googleapis.com/calendar/v3/users/me/calendarList?fields=items/id&key=%@&access_token=%@
    NSString *strApi = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/users/me/calendarList?fields=items&key=%@&access_token=%@",GoogleCustomKey,[GoogleLoginClass getGoogleToken]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strApi]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    NSLog(@"Calendar Dict :%@ api: %@",dict,strApi);
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *arr = [dict objectForKey:@"items"];
        if ([arr isKindOfClass:[NSArray class]]) {
            
            
            NSMutableArray *arrCaledarData = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in arr) {
                GoogleDisplayData *d = [[GoogleDisplayData alloc] init];
                [d setData:dict];
                [arrCaledarData addObject:d];
            }
            
            
            for (GoogleData *dat in arrGoogleCalendar) {
                if([dat.strEmail isEqualToString:strGoogleUserEmailId]){
                    [arrGoogleCalendar removeObject:dat];
                    break;
                }
            }
            
            GoogleData *d = [[GoogleData alloc] init];
            d.arrGoogleDisplayData = arrCaledarData;
           // d.calendarDict = dict;
            d.strEmail = strGoogleUserEmailId;
            //getGoogleServerAuthCode
            d.strServerAuthCode = [GoogleLoginClass getGoogleServerAuthCode];

            d.strRefreshToken = @""; [GoogleLoginClass getGoogleRefreshToken];
            d.strColor = @"#0000ff";
            [arrGoogleCalendar addObject:d];
            
            [_tblCalender reloadData];
            
            [[User currentUser] setCALENDARID:arrGoogleCalendar];
            
//            [self updateSocialAccountApi:d];
            //[self getSocialAccounts];
            
        }
        else{
            [self getSavedDataFromUserDefaults];
        }
    }
    else{
        [[AppDelegate sharedAppDelegate] showToastMessage:err.localizedDescription];
    }
    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
}

#pragma mark -
#pragma mark - Get Saved data from UserDefault
#pragma mark -

- (void)getSavedDataFromUserDefaults
{
    arrGoogleCalendar = [[User currentUser] getCALENDARID];
    [self.tblCalender reloadData];
    [self getSocialAccounts];
}

- (void)getSocialAccounts
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"1" forKey:@"SocialAccountType"];
    
    [afn getDataFromPath:@"GetSocialAccounts" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        NSLog(@"Get Social Accounts Response :%@",response);
        if (response && error == nil) {
            if([response isKindOfClass:[NSArray class]]){
                NSArray *arrResp = (NSArray *)response;
                if(arrResp){
                    
                    for(int i = 0; i < arrResp.count ; i++){
                        NSDictionary *dict = (NSDictionary *)arrResp[i];
                        bool isExist = false;
                        for(int j = 0 ; j < arrGoogleCalendar.count ; j++){
                            GoogleData *d = arrGoogleCalendar[j];
                            if([d.strEmail isEqualToString:[dict valueForKey:@"Account_Email"]]){
                                isExist = true;
                                d.strColor = [dict valueForKey:@"Color"];
                                d.isShowTask = (BOOL)[dict valueForKey:@"IsShowTask"];
                                d.strRefreshToken = [dict valueForKey:@"Refresh_Token"];
                                d.strAccountID = [dict valueForKey:@"AccountId"];
                                
                                for(int k = 0 ; k < d.arrGoogleDisplayData.count ; k++){
                                    GoogleDisplayData *disp = d.arrGoogleDisplayData[k];
                                    NSString *strSelectedId = [dict valueForKey:@"CalendarID"];
                                    if(![strSelectedId isKindOfClass:[NSNull class]]){
                                        NSArray *arrSelectedId = [strSelectedId componentsSeparatedByString:@","];
                                        if([arrSelectedId containsObject:disp.strId]){
                                            disp.isSelected = YES;
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(isExist == false) {
                            GoogleData* d = [[GoogleData alloc] init];
                            
                            d.strEmail = [dict valueForKey:@"Account_Email"];
                            d.strColor = [dict valueForKey:@"Color"];
                            d.isShowTask = (BOOL)[dict valueForKey:@"IsShowTask"];
                            d.strRefreshToken = [dict valueForKey:@"Refresh_Token"];
                            d.strAccountID = [dict valueForKey:@"AccountId"];
                            [arrGoogleCalendar addObject:d];

                            
                            NSString *strSelectedId = [dict valueForKey:@"CalendarID"];
                            if(![strSelectedId isKindOfClass:[NSNull class]]){
                                NSArray *arrSelectedId = [strSelectedId componentsSeparatedByString:@","];
                                
                                NSString *strSelectedNames = [dict valueForKey:@"CalendarName"];

                                NSArray* namesArray = [[NSMutableArray alloc] init];
                                
                                if(![strSelectedNames isKindOfClass:[NSNull class]])
                                    namesArray = [strSelectedNames componentsSeparatedByString:@","];

                                NSMutableArray* arrGoogleDisplayDataArray = [[NSMutableArray alloc] init];
                                for(int index = 0; index < arrSelectedId.count; index++) {
                                
                                    GoogleDisplayData *displayData = [[GoogleDisplayData alloc] init];

                                    if (namesArray.count > index)
                                        displayData.strName = [namesArray objectAtIndex:index];
                                    
                                    displayData.strId = [arrSelectedId objectAtIndex:index];
                                    displayData.isSelected = YES;
                                    
                                    [arrGoogleDisplayDataArray addObject:displayData];
                                }
                                
                                d.arrGoogleDisplayData = arrGoogleDisplayDataArray;
                            }


                        }
                    }

                    [_tblCalender reloadData];
                }
            }
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - CalenderView Api
/* Response
 
 {
 "result": "0",
 "error": ""
 }
 
 */
- (void)updateCalendatViewApi
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:_btnDropDown.currentTitle forKey:@"CalendarView"];
    
    NSLog(@"%@", _btnDropDown.currentTitle);
    
    [afn getDataFromPath:@"UpdateCalendarView" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error == nil) {
            if([response isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *)response;
                NSString *strResult = dict[@"result"];
                if([strResult isEqualToString:@"0"]){
                    [[User currentUser] setCALENDARVIEW:_btnDropDown.currentTitle forDevice:[[User currentUser] getDeviceId]];
                }
            }
        }else{
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
