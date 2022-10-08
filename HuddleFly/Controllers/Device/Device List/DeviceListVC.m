//
//  DeviceListVC.m
//  HuddleFly
//
//  Created by BMAC on 28/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "DeviceListVC.h"
#import "DeviceInfoVC.h"
#import "Global.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface DeviceListVC ()
@end

@implementation DeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device List"];
    [[Global sharedInstance] parameterInit];
    arrDeviceList = [[NSMutableArray alloc] init];
    [self getUserProfile];
    
    
    [[_userProfileBtn layer] setCornerRadius:5.0f];
    [[_userProfileBtn layer] setMasksToBounds:YES];
    [[_userProfileBtn layer] setBorderWidth: 1.0f];
    [[_userProfileBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
        
    [[_logoutBtn layer] setCornerRadius:5.0f];
    [[_logoutBtn layer] setMasksToBounds:YES];
    [[_logoutBtn layer] setBorderWidth: 1.0f];
    [[_logoutBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isEdited = NO;
    [self getDeviceList];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkiOSVersion];
}


#pragma mark - GETUSER Profile

-(void)getUserProfile
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?UserID=%@&%@=%@",kAPI_PATH_GET_USER_NAME,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [User setUserProfile:(NSDictionary *)response];
        } else{
            [User setUserProfile:nil];
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            //[[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
}


#pragma mark - Logout

- (IBAction)btnLogout:(id)sender
{
    
    
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation]; // Logout for Facebook
        [FBSession.activeSession close];
        //ß[FBSession setActiveSession:nil];
    }
    [[GIDSignIn sharedInstance] signOut];
    [[User currentUser] setUserID:@""];//Logout for Email
    [[AppDelegate sharedAppDelegate] gotoLoginScreen];
    
    [self showLogoutAlert];
}
- (IBAction)logoutRibbonBtn:(id)sender {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation]; // Logout for Facebook
        [FBSession.activeSession close];
        //ß[FBSession setActiveSession:nil];
    }
    
    [[GIDSignIn sharedInstance] signOut];
    [[User currentUser] setUserID:@""];//Logout for Email
    [[AppDelegate sharedAppDelegate] gotoLoginScreen];
    [self showLogoutAlert];
}


-(void) showLogoutAlert{
    UtilityClass *utility = [[UtilityClass alloc] init];
    NSString *loginType = [[User currentUser] getLOGINTYPE];
    if ([loginType isEqualToString:@"FB"]){
        [utility showAlertWithTitle:@"Logout Alert" andMessage:@"\nYou are logged out of your HuddleFly Facebook account, however you need to clear your browser history in-order to login using different Facebook account."];
    }else if ([loginType isEqualToString:@"Google"]){
        [utility showAlertWithTitle:@"Logout Alert" andMessage:@"\nYou are logged out of your HuddleFly Google account, however you need to clear your browser history in-order to login using different gmail account."];
    }
}


#pragma mark - ApiCalls
#pragma mark - Get Device List

- (void)getDeviceList
{
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_DEVICELIST withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [arrDeviceList removeAllObjects];
                for (NSDictionary *dict in response) {
                    DeviceList *list = [[DeviceList alloc] init];
                    [list setData:dict];
                    [arrDeviceList addObject:list];
                }
                if (arrDeviceList.count) {
                    [Global sharedInstance].DeviceListA = [[NSMutableArray alloc] init];
                    [Global sharedInstance].DeviceListA = arrDeviceList;
                }
                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [tblDeviceList reloadData];
    }];
}

#pragma mark - Delete Device 

- (void)deleteDevice:(NSString *)deviceId
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    NSString *strid = @"";
    if([deviceId isKindOfClass:[NSNumber class]])
    {
        NSNumber *n = (NSNumber *)deviceId;
        strid = [n stringValue];
    }else{
        strid = deviceId;
    }
    [dictParam setObject:strid forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_DELETE_DEVICE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Device deleted!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [tblDeviceList reloadData];
    }];
}

#pragma mark - Update Access Token

- (void)updateAccessToken:(id)obj
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getLOGINTYPE] forKey:kAPI_PARAM_LOGINTYPE];
    [dictParam setObject:[[User currentUser] getTokenForFBORGOOGLEPLUS] forKey:kAPI_PARAM_ACCESSTOKEN];
    NSLog(@"Dict Param :%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_ACCESSTOKEN withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Token updated!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [self performSegueWithIdentifier:kSEGUE_PREFERENCES sender:obj];
    }];
}



#pragma mark - Check iOS Version
-(void)checkiOSVersion{
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    NSString *userId = [[User currentUser] userID];
    if (userId == nil){
        return;
    }
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_APPSTORE_APP_VERSION withParamData:dictParam withBlock:^(id response, NSError * error) {
        if (response) {
            NSDictionary *dict = response;
            
            if(![[dict objectForKey:@"iOSVersion"] isKindOfClass:[NSNull class]])
            {
                CGFloat iOSVersion = [[dict objectForKey:@"iOSVersion"] floatValue];
                CGFloat currentVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
                if (iOSVersion > currentVersion){
                    UtilityClass *utility = [[UtilityClass alloc] init];
                    [utility showAlertWithTitle:@"HuddleFly" andMessage:@"\nThere is a new version of the app. Please update."];
                }
            }
        }
    }];
}




#pragma mark - BtnEdit

- (IBAction)btnEditClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn.currentTitle isEqualToString:@"Edit"])
    {
        [tblDeviceList setEditing:YES animated:YES];
        [btn setTitle:@"Done" forState:UIControlStateNormal];
    }
    else{
        [tblDeviceList setEditing:NO animated:YES];
        [btn setTitle:@"Edit" forState:UIControlStateNormal];
    }
    
}

#pragma mark - Tableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDeviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferencesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell"];
    if(cell == nil)
    {
        cell = [[PreferencesCell alloc] init];
    }
    DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
    [cell setCellData:list withParent:self];
    
    cell.btnDeviceInfo.tag = (indexPath.row+1);
    [cell.btnDeviceInfo addTarget:self action:@selector(onClickDeviceInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // add >
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        [cell.lblTitle setTextColor:[UIColor colorWithRed:111/225.0 green:113/255.0 blue:121/255.0 alpha:1.0]];
    }else{
        [cell.lblTitle setTextColor:[UIColor blackColor]];
    }
    if([list.strIsMaster integerValue] == 1){
        if([list.strIsFollowMaster integerValue] == 1){
            [cell.followMasterL setHidden:NO];
            [cell.alonemasterL setHidden:YES];
            cell.followMasterL.text = @"Master, Follow Master";
            cell.alonemasterL.text = @"";
        }else{
            [cell.followMasterL setHidden:YES];
            [cell.alonemasterL setHidden:NO];
            cell.followMasterL.text = @"";
            cell.alonemasterL.text = @"Master";
        }
    }else{
        [cell.alonemasterL setHidden:YES];
        [cell.followMasterL setHidden:YES];
        
        cell.followMasterL.text = @"";
        cell.alonemasterL.text = @"";

    }
    
    // < add
    return cell;
}

#pragma mark - tableview Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN] isEqualToString:@"FREE"]&&indexPath.row>0) {
//        [[AppDelegate sharedAppDelegate] showToastMessage:@"You can control only one device because you have FREE plan."];
//        return;
//    }
//    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Global sharedInstance].selectDeviceRow = indexPath.row;
    DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
    
    //Added 3-OCT-2016
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"This device has been deleted."];
    }else{
        
        [[User currentUser] setDeviceID:list.strDeviceId];
       // if([[[User currentUser] getLOGINTYPE] isEqualToString:@"0"])
        //{
            [self performSegueWithIdentifier:kSEGUE_PREFERENCES sender:[arrDeviceList objectAtIndex:indexPath.row]];
       // }
       // else
           // [self updateAccessToken:[arrDeviceList objectAtIndex:indexPath.row]];
    }
//    [self performSegueWithIdentifier:kSEGUE_PREFERENCES sender:[arrDeviceList objectAtIndex:indexPath.row]];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Added 3-OCT-2016
    DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"This device has been deleted."];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
        [arrDeviceList removeObjectAtIndex:indexPath.row];
        [self deleteDevice:list.strDeviceId];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        return NO;
    }
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Added 3-OCT-2016
    DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"This device has been deleted."];
    }else{
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Are you sure you want to delete the device? If you delete, you will loose all the history of this device."
                                                  message:nil
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
           
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"No", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:indexPath.row];
                                           [arrDeviceList removeObjectAtIndex:indexPath.row];
                                           [self deleteDevice:list.strDeviceId];
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            isEdited = YES;
            [self performSegueWithIdentifier:kSEGUE_ADDDEVICE sender:[arrDeviceList objectAtIndex:indexPath.row]];
        }];
        editAction.backgroundColor = [UIColor greenColor];
        return  @[editAction,deleteAction];
    }
    return nil;
}

- (void)onClickDeviceInfo:(UIButton *)btn
{
    /*DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:btn.tag-1];
    NSInteger deviceStatus = [list.strStatus integerValue];
    if(deviceStatus == -1){
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"This device has been deleted."];
    }else{
        [self performSegueWithIdentifier:kSEGUE_DEVICEINFO sender:btn];
    }*/
    
    [self performSegueWithIdentifier:kSEGUE_DEVICEINFO sender:btn];
    
}

- (IBAction)onclickAddDevice:(UIButton *)btn
{
    //int deviceCount = [[User getUserDataWithParam:USER_PROFILE_DEVICECOUNTER] intValue];
    int deviceLimit = [[User getUserDataWithParam:USER_PROFILE_DEVICELIMIT] intValue];
//    deviceLimit = 100;
    if(deviceLimit > arrDeviceList.count){ //Change By DHAWAL 30-Jun-2017 deviceCount < deviceLimit
        [self performSegueWithIdentifier:kSEGUE_ADDDEVICE sender:nil];
    }else{
        if (deviceLimit == 1) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"You can control only one device with a FREE plan."];
        }else if (deviceLimit == 2) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"You can control only two devices with a Bronze plan."];
        }else if (deviceLimit == 6) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"You can control only six devices with a Silver plan."];
        }else if (deviceLimit == 12) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"You can control only twelve devices with a Gold plan."];
        }
    }
}
- (IBAction)onclickHelpBtn:(UIButton *)btn
{
    //http://huddlefly.co/support Change 18-Jul-2017
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://huddlefly.co/support"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)gotoAddnewDeviceAction:(id)sender {
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSEGUE_PREFERENCES]) {
        NSString *strPreferenceTitle = @"Preferences";
        NSString *strDeviceId = @"";

        if(sender) {
            DeviceList *list = (DeviceList *)sender;
            strPreferenceTitle = list.strDeviceName;
        }
        
        PreferencesVC *pref = (PreferencesVC *) [segue destinationViewController];
        pref.strTitle = strPreferenceTitle;
        }
    else if ([segue.identifier isEqualToString:kSEGUE_ADDDEVICE])
        {
        if(isEdited)
            {
            AddDevice *add = (AddDevice *)[segue destinationViewController];
            if(sender){
                DeviceList *list = (DeviceList *)sender;
                add.listObj = list;
                add.isEdited = isEdited;
            }
            }
        
        }
    else if ([segue.identifier isEqualToString:kSEGUE_DEVICEINFO])
        {
        UIButton *btn = (UIButton *)sender;
        DeviceList *list = (DeviceList *)[arrDeviceList objectAtIndex:btn.tag-1];
        DeviceInfoVC *deviceInfo = (DeviceInfoVC *)segue.destinationViewController;
        deviceInfo.deviceListModel = list;
        }
}


@end
