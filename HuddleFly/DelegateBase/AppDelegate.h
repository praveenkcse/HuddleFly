//
//  AppDelegate.h
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppAuth.h"

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MBProgressHUD *HUD;
    BOOL IsPlanFree;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSMutableArray *arrMenuFeature;

@property(nonatomic, strong, nullable) id<OIDAuthorizationFlowSession> currentAuthorizationFlow;

+ (AppDelegate *)sharedAppDelegate;
-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void) showToastMessage:(NSString *)message;

- (void)gotoLoginScreen;
- (void)gotoMainScreen;

//Facebook
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

#pragma mark - Update plan
- (void)updatePlanWithProgressView:(BOOL)view;
- (void)updatePaymentWithProgressView:(BOOL)view;
- (void)changePlanWithProgressView:(BOOL)view;

-(void)setSelectedPlanId:(NSString *)strID;
-(void)setPlanUpdatedRemain:(BOOL)plan;
- (BOOL)isPlanUpdateRemain;

-(void)setUpdatePlan:(BOOL)plan;
- (BOOL)isUpdatePlan;

-(void)setUpdatePayment:(BOOL)plan;
- (BOOL)isUpdatePayment;

-(void)setChangePlan:(BOOL)plan;
- (BOOL)isChangePlan;

- (void)restoreInApp;

//MARK: - UI Methods
-(void) addHelpButtonFor: (NSInteger)featureId;

@end

