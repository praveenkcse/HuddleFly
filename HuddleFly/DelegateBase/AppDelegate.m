//
//  AppDelegate.m
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "AFNHelper.h"
#import "InAppHelper.h"
#import "UtilityClass.h"
#import <GoogleSignIn/GoogleSignIn.h>

#import "Harpy.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBarTintColor:COLOR_NAV_BG];
    [[UINavigationBar appearance] setTintColor:COLOR_HOME_BG];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //[self gotoLoginScreen];
    
    [GIDSignIn sharedInstance].clientID = GoogleCustomKey;
    [GIDSignIn sharedInstance].serverClientID = GoogleWebServerKey;
    
//    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Additional scopes, if any
    [GIDSignIn sharedInstance].scopes = @[ OIDScopeOpenID,
                                           OIDScopeEmail,
                                           @"https://www.googleapis.com/auth/calendar",
                                           @"https://www.googleapis.com/auth/calendar.readonly",
                                           @"https://www.googleapis.com/auth/tasks",
                                           @"https://www.googleapis.com/auth/tasks.readonly",
                                           @"https://www.googleapis.com/auth/userinfo.email",
                                           @"https://www.googleapis.com/auth/userinfo.profile",
                                           @"https://www.googleapis.com/auth/plus.login" ];

    
    if([self isPlanUpdateRemain]){
        if([self isUpdatePlan] == NO){
            [self updatePlanWithProgressView:NO];
        }else if ([self isUpdatePayment] == NO){
            [self updatePaymentWithProgressView:NO];
        }else if ([self isChangePlan]== NO){
            [self changePlanWithProgressView:NO];
        }
    }
    
    if ([[User currentUser] isLogin]) {
        [self gotoMainScreen];
        [self restoreInApp]; //Added By DHAWAL Jan-18-2016 
    } else{
        [self gotoLoginScreen];
    }
    
    [self.window makeKeyAndVisible];
    
//    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
//    [Harpy sharedInstance].alertType = HarpyAlertTypeForce;
//    [[Harpy sharedInstance] checkVersion];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        UtilityClass *utility = [[UtilityClass alloc] init];
        [utility showAlertWithTitle:@"Please note" andMessage:@"\nHuddleFly currently does not support iPad"];
    }
    
//    [self CheckiOSVersions];
    
    NSData *tr = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_TRANSITIONS];
    if (tr != nil){
        NSMutableDictionary *transitions = [NSKeyedUnarchiver unarchiveObjectWithData:tr];
        UtilityClass.sharedObject.transitions = transitions;
        NSLog(@"saved dictionary %@",transitions);
    }
    return YES;
}


-(void)CheckiOSVersions{
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

- (void)gotoLoginScreen {
    [self.window makeKeyAndVisible];
    [AppDelegate sharedAppDelegate].isLogin = NO;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSB_LOGIN_REGISTER bundle:nil];
    UINavigationController *n = [storyboard instantiateInitialViewController];
    self.window.rootViewController = n;
    [self.window makeKeyAndVisible];
}

- (void)gotoMainScreen {
    [self.window makeKeyAndVisible];
    [AppDelegate sharedAppDelegate].isLogin = YES;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kSB_MAIN bundle:nil];
    SWRevealViewController *sw = [storyboard instantiateInitialViewController];
    self.window.rootViewController = sw;

    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    
//    [[Harpy sharedInstance] checkVersionDaily];
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - sharedAppDelegate

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Loading View

-(void) showHUDLoadingView:(NSString *)strTitle {
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
        
    }
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [self.window bringSubviewToFront:HUD];
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView {
    if (HUD) {
        [HUD hide:YES];
    }
}

-(void)showToastMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

/*Facebook Login*/
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");

        //[self gotoMainScreen];
        //[self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){

        NSLog(@"Session closed");
        [self userLoggedOut];
    }
    
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
            } else {
                
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
    
        [self userLoggedOut];
    }
}


- (void)userLoggedOut
{
    /*UIButton *loginButton = [self.customLoginViewController loginButton];
    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];*/
    
    [self showMessage:@"You're now logged out" withTitle:@""];
}

- (void)userLoggedIn
{
    /*UIButton *loginButton = self.customLoginViewController.loginButton;
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];*/
    
    [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
    
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"Url :%@",url);
    
    BOOL google = [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:sourceApplication
                               annotation:annotation];
    BOOL facebook = [FBSession.activeSession handleOpenURL:url];
    
    return google || facebook;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    
    if([url.absoluteString containsString:@"huddlefly://?yturl="]) {
        NSString *YTurl = [url.absoluteString stringByReplacingOccurrencesOfString:@"huddlefly://?yturl=" withString:@""];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:YTurl forKey:@"YTurl"];
        [defaults synchronize];
        
        return YES;
    }
    
    if ([_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]) {
        _currentAuthorizationFlow = nil;
        return YES;
    }
    
    BOOL google = [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    BOOL facebook = [FBSession.activeSession handleOpenURL:url];
    return google || facebook;
    
//    // Sends the URL to the current authorization flow (if any) which will
//    // process it if it relates to an authorization response.
//    if ([_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]) {
//        _currentAuthorizationFlow = nil;
//        return YES;
//    } else if ([[url scheme] hasPrefix:@"fb"])
//        return [FBSession.activeSession handleOpenURL:url];
//    
//    // Your additional URL handling (if any) goes here.
//    
//    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    [[Harpy sharedInstance] checkVersionDaily];

    //[FBAppCall handleDidBecomeActive];
}

#pragma mark - Restore for check User Free Or Paid

- (void)restoreInApp {
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:nil];
    [[InAppHelper sharedObject]fetchAvailableProductsWithBlock:^(BOOL result) {
        if (result) {
            [[InAppHelper sharedObject] restoreProductwithBlock:^(Transaction result, NSError *error) {
                switch (result) {
                    case TransactionPurchasing:
                        
                        break;
                    case TransactionPurchased:
                    {
                        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                        
                    }
                        break;
                    case TransactionRestored:
                    {
                        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                        
                    }
                        break;
                    case TransactionNoProduct:
                    {
                        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                        
                        IsPlanFree = YES;
                        [[AppDelegate sharedAppDelegate] setPlanUpdatedRemain:YES];
                        [[AppDelegate sharedAppDelegate] updatePlanWithProgressView:YES];
                        
                    }
                        break;
                    case TransactionFailed:
                    {
                        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                        IsPlanFree = YES;
                        [[AppDelegate sharedAppDelegate] setPlanUpdatedRemain:YES];
                        [[AppDelegate sharedAppDelegate] updatePlanWithProgressView:YES];
                    }
                        break;
                    default:
                    {
                        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                    }
                        break;
                }
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            });
            
        }
    }];
}


#pragma mark - Update Plan

- (void)updatePlanWithProgressView:(BOOL)view
{
    [self setUpdatePlan:NO];
    [self setUpdatePayment:NO];
    [self setChangePlan:NO];
    
    NSString *uid = [[User currentUser] userID];
    if (uid == nil || [uid isEqualToString:@""]) return;
    
    if(view){
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    }
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    NSString *strPlanId = [self getSelectedPlanId];
    if(strPlanId.length > 0 && IsPlanFree == NO){
        [dictParam setObject:strPlanId forKey:kAPI_PARAM_PLANID];
    }else{
        [dictParam setObject:@"0" forKey:kAPI_PARAM_PLANID];
    }
    [afn getDataFromPath:kAPI_PATH_UPDATE_PLAN withParamData:dictParam withBlock:^(id response, NSError *error) {
        if(view){
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        }
        if (response) {
            [self setUpdatePlan:YES];
            [self updatePaymentWithProgressView:view];
        }
        else{
            if(view){
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }
    }];
}


- (void)updatePaymentWithProgressView:(BOOL)view {
    if(view){
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    }
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    if(IsPlanFree){
        [dictParam setObject:@"false" forKey:kAPI_PARAM_HASPAID];
    }else{
        [dictParam setObject:@"true" forKey:kAPI_PARAM_HASPAID];
    }
    
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_PAYMENT withParamData:dictParam withBlock:^(id response, NSError *error) {
        if(view){
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        }
        if (response) {
            [self setUpdatePayment:YES];
            [self changePlanWithProgressView:view];
        }
        else{
            if(view){
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }
    }];
}

- (void)changePlanWithProgressView:(BOOL)view {
    
    if(view){
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    }
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[User getUserDataWithParam:USER_PROFILE_PLANID] forKey:kAPI_PARAM_OLDPLANID];
    if(IsPlanFree){
        [dictParam setObject:@"0" forKey:kAPI_PARAM_NEWPLANID];
    }else{
        [dictParam setObject:[self getSelectedPlanId] forKey:kAPI_PARAM_NEWPLANID];
    }
    
    [afn getDataFromPath:kAPI_PATH_CHANGE_PLAN withParamData:dictParam withBlock:^(id response, NSError *error) {
        if(view){
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        }
        if (response) {
            [self setChangePlan:YES];
            [self setPlanUpdatedRemain:NO];
            
            IsPlanFree = NO;
            [self setUpdatePlan:NO];
            [self setUpdatePayment:NO];
            [self setChangePlan:NO];
        }
        else{
            if(view){
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }
    }];
}

-(void)setSelectedPlanId:(NSString *)strID
{
    if(strID){
        [[NSUserDefaults standardUserDefaults] setValue:strID forKey:@"IndexpathSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)getSelectedPlanId{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"IndexpathSelected"];
    return str?str:@"";
}

-(void)setPlanUpdatedRemain:(BOOL)plan
{
    [USERDEFAULT setBool:plan forKey:@"PlanUpdated"];
    [USERDEFAULT synchronize];
}

- (BOOL)isPlanUpdateRemain
{
    return [USERDEFAULT boolForKey:@"PlanUpdated"];
}

-(void)setUpdatePlan:(BOOL)plan
{
    [USERDEFAULT setBool:plan forKey:@"SetUpdatedPlan"];
    [USERDEFAULT synchronize];
}

- (BOOL)isUpdatePlan
{
    return [USERDEFAULT boolForKey:@"SetUpdatedPlan"];
}

-(void)setUpdatePayment:(BOOL)plan
{
    [USERDEFAULT setBool:plan forKey:@"SetUpdatedPayment"];
    [USERDEFAULT synchronize];
}

- (BOOL)isUpdatePayment
{
    return [USERDEFAULT boolForKey:@"SetUpdatedPayment"];
}

-(void)setChangePlan:(BOOL)plan
{
    [USERDEFAULT setBool:plan forKey:@"SetChangePayment"];
    [USERDEFAULT synchronize];
}

- (BOOL)isChangePlan
{
    return [USERDEFAULT boolForKey:@"SetChangePayment"];
}


@end
