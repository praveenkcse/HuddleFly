//
//  FacebookAlbumVC.m
//  HuddleFly
//
//  Created by BMAC on 17/08/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "FacebookAlbumVC.h"
#import "PreferencesCell.h"
//#import "DickColorPicker.h"
#import "LocalEvents.h"
#import "ShowWorldTimeCell.h"
#import "FBLoginClass.h"
#import "Global.h"

#import "ActionSheetStringPicker.h"

@interface FacebookAlbumVC ()<FBLoginClassDelegate, UIAlertViewDelegate>//DickColorPickerDelegate
{
    NSString *strFacebookUserEmail;
    NSString *strSelectedAlbumId;
    NSInteger selectedSection;
    // NSString *strHexCode;
    NSMutableArray *arrNumber;
}
//@property (nonatomic , weak)IBOutlet UIButton *btnShowTask;
//@property (nonatomic , weak)IBOutlet UIButton *btnColorPicker;
//@property (nonatomic , weak)IBOutlet UIButton *btnIsFullScreen;
@end

@implementation FacebookAlbumVC
- (NSString *)helpPath {
    return @"3-1";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    arrFBAlbum = [[NSMutableArray alloc] init];
    arrNumber = [[NSMutableArray alloc] init];
    [self getTransitions];
    selectedSection = -1;
    
    [self getLocalAlbum];
    [Global roundBorderSet:_btnFacebook];
    [self getTransition];
}

#pragma mark -
#pragma mark - Action
#pragma mark -
/*
- (IBAction)onClickFullscreenMode:(id)sender
{
    _btnIsFullScreen.selected = !_btnIsFullScreen.isSelected;
}

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
*/

- (IBAction)onClickLogout:(id)sender
{
    [FBLoginClass clearCookie];
    [FBSession.activeSession closeAndClearTokenInformation];

}

- (IBAction)onClickFBLogin:(id)sender {
    
    [self onClickLogout:self];
    
    FBLoginClass *fb = [[FBLoginClass alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height)];
    fb.delegate = self;
    
    if([FBLoginClass isTokenExpire]){
        [fb authenticationWithFB];
//        [self.view addSubview:fb];
//        [[[[UIApplication sharedApplication] delegate] window] addSubview:fb];
//        [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:0 animations:^{
//            fb.frame = [[UIScreen mainScreen] applicationFrame];
//        }completion:^(BOOL finished) {
//        }];
    }else{
        [fb fetchUserLoginDetails];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];

}

#pragma mark - FBLoginClass Delegate

- (void)startProcessing
{
  //  [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
}

- (void)stopProcessing
{
    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
}

- (void)finishFetchingWithResponse:(NSDictionary *)dict error:(NSError *)err
{
    if(dict){
        [[User currentUser] setFACEBOOKLOGOUT:@"1"];
        
        strFacebookUserEmail = [dict objectForKey:@"email"];
        
        if([[dict objectForKey:@"albums"] isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictAlbum = [dict objectForKey:@"albums"];
            
            if ([[dictAlbum objectForKey:@"data"] isKindOfClass:[NSArray class]]) {//result
                //[arrFBAlbum removeAllObjects];
                
                NSArray *arrTemp = [dictAlbum objectForKey:@"data"];//result
                NSMutableArray *arrFbdata = [[NSMutableArray alloc] init];
                for(NSDictionary *dict in arrTemp)
                {
                    FbData *f = [[FbData alloc] init];
                    [f setData:dict];
                    [arrFbdata addObject:f];
                }
                
                for (FbDetail *dat in arrFBAlbum) {
                    if([dat.strEmail isEqualToString:strFacebookUserEmail]){
                        [arrFBAlbum removeObject:dat];
                        break;
                    }
                }
                
                FbDetail *d = [[FbDetail alloc] init];
                d.arrFbData = arrFbdata;
                d.strEmail = strFacebookUserEmail;
                d.strRefreshToken = [FBLoginClass getFBToken];
                d.strColor = @"#ffffff";
                [arrFBAlbum addObject:d];
                
                [self.tblFBAlbum reloadData];
                
                [[User currentUser] setFBALBUMID:arrFBAlbum];
                
//                [self updateSocialAccountApi:d];
                //[self getSocialAccounts];
                
            }
            else{
                [self getLocalAlbum];
            }
        }else{
            [self getLocalAlbum];
        }

    }else{
        [[AppDelegate sharedAppDelegate] showToastMessage:err.localizedDescription];
    }
}


#pragma mark -
#pragma mark - Get Fb Album List
#pragma mark -

- (void) getLocalAlbum
{
    arrFBAlbum = [[User currentUser] getFBALBUMID];
    [self.tblFBAlbum reloadData];
    [self getSocialAccounts];
}

- (void)getSocialAccounts
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"3" forKey:@"SocialAccountType"];
    
    [afn getDataFromPath:@"GetSocialAccounts" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error == nil) {
            if([response isKindOfClass:[NSArray class]]){
                NSArray *arrResp = (NSArray *)response;
                if(arrResp){
                    for(int i = 0; i < arrResp.count ; i++){
                        NSDictionary *dict = (NSDictionary *)arrResp[i];
                        bool isExist = false;
                        for(int j = 0 ; j < arrFBAlbum.count ; j++){
                            FbDetail *d = arrFBAlbum[j];
                            if([d.strEmail isEqualToString:[dict valueForKey:@"Account_Email"]]){
                                isExist = true;
                                d.strColor = [dict valueForKey:@"Color"];
                                d.isShowTask = (BOOL)[dict valueForKey:@"IsShowTask"];
                                d.strRefreshToken = [dict valueForKey:@"Refresh_Token"];
                                d.strAccountID = [dict valueForKey:@"AccountId"];
                                
                                for(int k = 0 ; k < d.arrFbData.count ; k++){
                                    FbData *disp = d.arrFbData[k];
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
                            FbDetail* d = [[FbDetail alloc] init];
                            
                            d.strEmail = [dict valueForKey:@"Account_Email"];
                            d.strColor = [dict valueForKey:@"Color"];
                            d.isShowTask = (BOOL)[dict valueForKey:@"IsShowTask"];
                            d.strRefreshToken = [dict valueForKey:@"Refresh_Token"];
                            d.strAccountID = [dict valueForKey:@"AccountId"];
                            [arrFBAlbum addObject:d];
                            
                            
                            NSString *strSelectedId = [dict valueForKey:@"CalendarID"];
                            if(![strSelectedId isKindOfClass:[NSNull class]]){
                                NSString *names = [dict valueForKey:@"CalendarName"];

                                NSArray *arrSelectedId = [strSelectedId componentsSeparatedByString:@","];
                                
                                NSArray *namesArray = nil;
                                
                                if(![names isKindOfClass:[NSNull class]])
                                    namesArray = [names componentsSeparatedByString:@","];
                                
                                NSMutableArray* arrFbDataArray = [[NSMutableArray alloc] init];
                                for(int index = 0; index < arrSelectedId.count; index++) {
                                    
                                    FbData *displayData = [[FbData alloc] init];
                                    
                                    if (namesArray.count > index)
                                        displayData.strName = [namesArray objectAtIndex:index];
                                    displayData.strId = [arrSelectedId objectAtIndex:index];
                                    displayData.isSelected = YES;
                                    
                                    [arrFbDataArray addObject:displayData];
                                }
                                
                                d.arrFbData = arrFbDataArray;
                            }
                            
                            
                        }
                    }
                    [_tblFBAlbum reloadData];
                }
            }
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}


#pragma mark -
#pragma mark - Color picker Delegate
#pragma mark -
/*
- (void)colorPicked:(UIColor *)color
{
    int section = _btnColorPicker.tag - 20.0;
    FbDetail *data = [arrFBAlbum objectAtIndex:section];
    data.strColor = [self hexStringFromColor:color];
    
    [_btnColorPicker setTitleColor:color forState:UIControlStateNormal];
    //strHexCode = [self hexStringFromColor:color];
}
*/
#pragma mark -
#pragma mark - Color To Hex
#pragma mark -

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
#pragma mark - UITableview Datasorce
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrFBAlbum.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == selectedSection)
    {
        FbDetail *data = (FbDetail *)arrFBAlbum[section];
        return data.arrFbData.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tblFBAlbum.frame.size.width, 70)];
    [view setBackgroundColor:[UIColor grayColor]];
    view.tag = 2000 + section;
    
    FbDetail *data = (FbDetail *)arrFBAlbum[section];
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
    
    /*UIButton *btnShowTask = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [view addSubview:btnColorPicker];
    */
    
    UIButton *btnHideShow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHideShow.frame = CGRectMake(view.frame.size.width - 110, lblEmail.frame.size.height + 10, 100, 25);
    if(section == selectedSection)
        [btnHideShow setTitle:@"Hide" forState:UIControlStateNormal];
    else
        [btnHideShow setTitle:@"Show" forState:UIControlStateNormal];
    btnHideShow.tag = section + 20;
    [btnHideShow addTarget:self action:@selector(showSectionRows:) forControlEvents:UIControlEventTouchUpInside];
    btnHideShow.layer.borderColor = [UIColor whiteColor].CGColor;
    btnHideShow.layer.borderWidth = 1.0;
    [view addSubview:btnHideShow];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(8,btn.frame.origin.y + btn.frame.size.height + 5, 125, 25);
    [btnSubmit setTitle:@"Save Album(s)" forState:UIControlStateNormal];
    btnSubmit.tag = section + 40;
    [btnSubmit addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.layer.borderColor = [UIColor whiteColor].CGColor;
    btnSubmit.layer.borderWidth = 1.0;
    [view addSubview:btnSubmit];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowWorldTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookAlbumCell"];
    if(cell == nil)
    {
        cell = [[ShowWorldTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FacebookAlbumCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FbDetail *f = [arrFBAlbum objectAtIndex:indexPath.section];
    FbData *data = (FbData *)f.arrFbData[indexPath.row];
    [cell setCellData:data];
    
    //Remove BY DHAWAL 1-Sep-2016 for requirment Multiple selection in fb
    /*if(data.isSelected)
    {
        UIButton *b = (UIButton *)cell.contentView.subviews.lastObject;
        [UtilityClass setFbElementObj:data];
        [UtilityClass setFbElementControl:b];
    }*/
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
                                                              
                                                              FbDetail *detail = [self->arrFBAlbum objectAtIndex:section];
                                                              
                                                              [self logoutApi:detail];
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
    FbDetail *data = [arrFBAlbum objectAtIndex:section];
    data.isShowTask = sender.isSelected;
}

/*
- (void)colorPickerPressed:(UIButton *)sender
{
    _btnColorPicker = sender;
    [self onClickOpenColorPicker:sender];
}
*/

- (void)showSectionRows:(UIButton *)sender
{
    if([sender.currentTitle isEqualToString:@"Hide"]){
        selectedSection = -1;
    }
    else{
        int section = sender.tag - 20.0;
        selectedSection = section;
    }
    [_tblFBAlbum reloadData];
    /*NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:_tblFBAlbum]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [_tblFBAlbum reloadSections:sections withRowAnimation:UITableViewRowAnimationBottom];*/
}

- (void)logoutApi:(FbDetail *)data
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    if (data.strAccountID) {
        AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
        [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
        [dictParam setObject:data.strAccountID?data.strAccountID:@"" forKey:@"AccountID"];
        
        [afn getDataFromPath:@"RemoveSocialAccount" withParamData:dictParam withBlock:^(id response, NSError *error) {
            NSLog(@"Response :%@",response);
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            
            if(response && error == nil){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Logout Successfully"];
                
                [arrFBAlbum removeObject:data];
                [[User currentUser] setFBALBUMID:arrFBAlbum];
                [_tblFBAlbum reloadData];
                [self showLogoutAlert];
            }else{
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }];
    } else {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Account Removed"];
        
        [arrFBAlbum removeObject:data];
        [[User currentUser] setFBALBUMID:arrFBAlbum];
        [_tblFBAlbum reloadData];
        [self showLogoutAlert];
    }
    
    
    
}


-(void) showLogoutAlert{
    UtilityClass *utility = [[UtilityClass alloc] init];
    [utility showAlertWithTitle:@"Logout Alert" andMessage:@"\nYou are logged out of your HuddleFly Facebook account, however you need to clear your browser history in-order to login using different Facebook account."];
}




- (void)submitBtnPressed:(UIButton *)sender
{
    int section = sender.tag - 40.0;
    
    FbDetail *data = [arrFBAlbum objectAtIndex:section];
    
    [self updateSocialAccountApi:data];
}

- (void)updateSocialAccountApi:(FbDetail *)data
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:@"3" forKey:@"SocialAccountType"];
    
    NSString *strRefresh =  data.strRefreshToken;
    if(!strRefresh)
        strRefresh = @"";
    [dictParam setObject:strRefresh forKey:@"RefreshToken"];
    
    NSString *strEmail = data.strEmail;
    if(!strEmail)
        strEmail = @"";
    [dictParam setObject:strEmail forKey:@"AccountEmail"];
    
    [dictParam setObject:data.strColor forKey:@"CalendarColor"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *namesArr = [[NSMutableArray alloc] init];

    if(data.arrFbData > 0)
    {
        for(int i = 0; i < data.arrFbData.count ; i++)
        {
            FbData *f = data.arrFbData[i];
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

    NSString *namesStr = @"";
    if(namesArr.count > 0)
        namesStr = [namesArr componentsJoinedByString:@","];

    NSString *strCalenderid  = strId;
    if(!strCalenderid)
        strCalenderid = @"";

    NSString *strCalenderName  = namesStr;
    if(!strCalenderName)
        strCalenderName = @"";

    
    [dictParam setObject:strCalenderid forKey:@"CalendarOrFBIDs"];
    [dictParam setObject:strCalenderName forKey:@"CalendarOrFBNames"];
    
    if(data.isShowTask){
        [dictParam setObject:@"true" forKey:@"ShowTask"];
    }else{
        [dictParam setObject:@"false" forKey:@"ShowTask"];
    }
    
    /*if(_btnIsFullScreen.isSelected)
     [dictParam setObject:@"true" forKey:@"IsFullScreen"];
     else*/
    [dictParam setObject:@"false" forKey:@"IsFullScreen"];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

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
    //        [arrNumber removeAllObjects];
    
    NSString* pickerTitle;
    
    //    if (sender == self.pixTransitionTextField) {
    //
    //        arrNumber = [NSMutableArray arrayWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", nil];
    //        for (int i = 5 ; i <= 60; i++) {
    //            [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
    //        }
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
        
        [afn getDataFromPath:@"GetFBTransit" withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            if (response) {
                NSDictionary *dict = response;
                self.pixTransitionTextField.text = [dict objectForKey:@"FBTransit"];
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
        [dictParam setObject:_pixTransitionTextField.text forKey:@"FBTransit"];
        
        [afn getDataFromPath:@"UpdateFBTransit" withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            if (response) {
                
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
