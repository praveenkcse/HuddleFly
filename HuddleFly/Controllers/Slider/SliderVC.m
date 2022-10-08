//
//  SliderVC.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "SliderVC.h"
#import "PreferencesVC.h"
#import "SWRevealViewController.h"
#import "ModelMenu.h"
#import "UserProfileVC.h"

#define NUMBEROFMENU 20

@interface SliderVC ()

@end

@implementation SliderVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_SLIDER_BG;
    scrBg.directionalLockEnabled = YES;
    scrBg.contentSize = CGSizeMake(scrBg.frame.size.width, 51*NUMBEROFMENU+10);
    lblUsername.text = [NSString stringWithFormat:@"%@",[User getUserDataWithParam:USER_PROFILE_FIRSTNAME]];
    [self showPremiumIcon];
    //[self getUserName];
}
#pragma mark - Get user name
/*
-(void)getUserName
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?UserID=%@&%@=%@",kAPI_PATH_GET_USER_NAME,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];

    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [User setUserProfile:(NSDictionary *)response];
            
            if ([[response objectForKey:@"FirstName"] isKindOfClass:[NSString class]]) {
                //[[User currentUser] setUserID:[response objectForKey:@"user_id"]];
                lblUsername.text =[NSString stringWithFormat:@"%@",[response objectForKey:@"FirstName"]];
                //[response objectForKey:@"last_name"]
            }
            else {
                [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:@""];
            }
        } else{
            [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
}*/

-(void)showPremiumIcon{
    [_promiumYoutuImg setHidden:YES];
    [_promiumPowerImg setHidden:YES];
    [_promiumUsbImg setHidden:YES];
    [_promiumDevicesImg setHidden:YES];
    [_promiumDisplayImg setHidden:YES];
    [_promiumCommandImg setHidden:YES];
    [_promiumShcaduleImg setHidden:YES];
    [_promiumHealthImg setHidden:YES];
    
    if ([[User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN] isEqualToString:@"FREE"]) {
        [_promiumYoutuImg setHidden:NO];
        [_promiumPowerImg setHidden:NO];
        [_promiumUsbImg setHidden:NO];
    }
}
#pragma mark - Actions

- (IBAction)onClickPref:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc getOptionData];
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];//Change By Dhawal All 0 is replace by 1
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickUserProfile:(id)sender
{
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_USERPROFILE sender:vc];
    [revealViewController revealToggle:sender];
    
 
}

- (IBAction)onClickSetDevice:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    [nav popToRootViewControllerAnimated:YES];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickLiveStreaming:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_LIVESTREAMING sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickMotionSensor:(id)sender {
    if([AppDelegate sharedAppDelegate].arrMenuFeature && [AppDelegate sharedAppDelegate].arrMenuFeature.count > 4){
        if(![User isUserPaid]){
            ModelMenu *menu = [AppDelegate sharedAppDelegate].arrMenuFeature[4];
            if([menu.strPaid isEqualToString:@"1"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
                return;
            }
        }
    }
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_MOTION sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickWemo:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_WEMO sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickPlayYoutube:(id)sender {
    if ([[User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN] isEqualToString:@"FREE"]) {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
        return;
    }
    if([AppDelegate sharedAppDelegate].arrMenuFeature && [AppDelegate sharedAppDelegate].arrMenuFeature.count > 0){
        if(![User isUserPaid]){
            ModelMenu *menu = [AppDelegate sharedAppDelegate].arrMenuFeature[0];
            if([menu.strPaid isEqualToString:@"1"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
                return;
            }
        }
    }
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_PLAYYOUTUBE sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickDeviceSchedule:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_DEVICESCHEDULE sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickTakeSefie:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_TAKESELFIE sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickRegiDevice:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_REGISTERDEVICE sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickRegiLocation:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_REGISTERLOCATION sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickDeviceCmd:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_DEVICECMD sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickLogout:(id)sender {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation]; // Logout for Facebook
        [FBSession.activeSession close];
        //ß[FBSession setActiveSession:nil];
    }
    [[User currentUser] setUserID:@""];//Logout for Email
    [[AppDelegate sharedAppDelegate] gotoLoginScreen];
}

- (IBAction)onClickDeviceHealth:(id)sender
{
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_DEVICEHEALTH sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickDeviceSettings:(id)sender
{
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_DEVICESETTINGS sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickConfigurationHuddlyFly:(id)sender
{
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_CONFIGUREHUDDLYFLY sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickPlayPowerPoint:(id)sender
{
    if ([[User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN] isEqualToString:@"FREE"]) {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
        return;
    }
    if([AppDelegate sharedAppDelegate].arrMenuFeature && [AppDelegate sharedAppDelegate].arrMenuFeature.count > 1){
        if(![User isUserPaid]){
            ModelMenu *menu = [AppDelegate sharedAppDelegate].arrMenuFeature[1];
            if([menu.strPaid isEqualToString:@"1"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
                return;
            }
        }
    }
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_PLAYPOWERPOINT sender:vc];
    [revealViewController revealToggle:sender];
}

- (IBAction)onClickPlayUSB:(id)sender
{
    if([AppDelegate sharedAppDelegate].arrMenuFeature && [AppDelegate sharedAppDelegate].arrMenuFeature.count > 2){
        if(![User isUserPaid]){
            ModelMenu *menu = [AppDelegate sharedAppDelegate].arrMenuFeature[2];
            if([menu.strPaid isEqualToString:@"1"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
                return;
            }
        }
    }
    SWRevealViewController *revealViewController = self.revealViewController;
    UINavigationController *nav = (UINavigationController *)revealViewController.frontViewController;
    PreferencesVC *vc = [nav.viewControllers objectAtIndex:1];
    [vc performSegueWithIdentifier:kSEGUE_PLAYUSB sender:vc];
    [revealViewController revealToggle:sender];
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
