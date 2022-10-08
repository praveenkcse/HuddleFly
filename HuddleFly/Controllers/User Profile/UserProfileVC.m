//
//  UserProfileVC.m
//  HuddleFly
//
//  Created by BMAC on 26/10/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "UserProfileVC.h"
#import "Global.h"
@interface UserProfileVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserID;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginType;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberSince;
@property (weak, nonatomic) IBOutlet UILabel *lblLastLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblPlan;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanNonFree;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceCount;
@property (weak, nonatomic) IBOutlet UILabel *lblVerified;

//@property (weak, nonatomic) IBOutlet UIButton *btnFree;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@end

@implementation UserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"User Profile"];
    [super setBackBarItem:YES];
    [super setHelpBarButton:9];
    
    [self UpdateDetail];
    [Global roundBorderSet:_payBtn];
}

- (NSString *)helpPath {
    return @"0-9";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserProfile];
}

- (void)UpdateDetail
{
    NSString *deviceCount = [User getUserDataWithParam:USER_PROFILE_DEVICECOUNTER];
    NSString *deviceLimit = [User getUserDataWithParam:USER_PROFILE_DEVICELIMIT];
    if(deviceCount.length == 0 || deviceLimit.length == 0){
        _lblDeviceCount.text = @"";
    }else{
        _lblDeviceCount.text = [NSString stringWithFormat:@"%@/%@",deviceCount,deviceLimit];
    }
    
    _lblLastLogin.text = [User getUserDataWithParam:USER_PROFILE_TIMESTAMP];
    _lblLoginType.text = [User getUserDataWithParam:USER_PROFILE_LOGINTYPE];
    _lblMemberSince.text = [User getUserDataWithParam:USER_PROFILE_CREATEDDATE];
    _lblName.text = [NSString stringWithFormat:@"%@ %@",[User getUserDataWithParam:USER_PROFILE_FIRSTNAME],[User getUserDataWithParam:USER_PROFILE_LASTNAME]];
    //"true"
    _lblPaymentStatus.text = [[[User getUserDataWithParam:USER_PROFILE_HASPAID] lowercaseString] isEqualToString:@"1"]?@"Paid":@"UnPaid";
    if([[_lblPaymentStatus.text lowercaseString] isEqualToString:@"paid"]){
        _lblPaymentStatus.textColor = COLOR_BTN_BACKGROUND;//[UIColor greenColor];
    }else{
        _lblPaymentStatus.textColor = [UIColor redColor];
    }
    if ([[User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN] isEqualToString:@"FREE"]) {
        [_lblPlan setHidden:NO];
        [_lblPlanNonFree setHidden:YES];
        _lblPlan.text = [User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN];
        _lblPlanNonFree.textColor = COLOR_BTN_BACKGROUND;//[UIColor blackColor];
    }else{
        [_lblPlan setHidden:YES];
        [_lblPlanNonFree setHidden:NO];
        _lblPlanNonFree.text = [User getUserDataWithParam:USER_PROFILE_PAYMENTPLAN];
        _lblPlanNonFree.textColor = COLOR_BTN_BACKGROUND;
    }
    
    _lblStatus.text = [[User getUserDataWithParam:USER_PROFILE_STATUS] isEqualToString:@"1"]?@"Active":@"Deactive";
    if([[_lblStatus.text lowercaseString] isEqualToString:@"active"]){
        _lblStatus.textColor = COLOR_BTN_BACKGROUND;//[UIColor greenColor];
    }else{
        _lblStatus.textColor = [UIColor redColor];
    }
    _lblUserID.text = [User getUserDataWithParam:USER_PROFILE_EMAILID];
    if([[User getUserDataWithParam:USER_PROFILE_ISEMAILVERIFIED] isEqualToString:@"1"]){
        _lblVerified.textColor = COLOR_BTN_BACKGROUND;//[UIColor greenColor];
        _lblVerified.text = @"(Verified)";
    }else{
        _lblVerified.textColor = [UIColor redColor];
        _lblVerified.text = @"(Not Verified)";
    }
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
            [self UpdateDetail];
        } else{
            [User setUserProfile:nil];
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            //[[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) showTerms: (UIButton*) sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.huddlefly.co/terms"]];
}

-(IBAction) showPrivacyPolicy: (UIButton*) sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.huddlefly.co/privacy"]];
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
