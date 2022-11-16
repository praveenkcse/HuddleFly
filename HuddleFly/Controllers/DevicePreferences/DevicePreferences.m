    //
    //  DevicePreferences.m
    //  HuddleFly
    //
    //  Created by apple on 24/09/22.
    //  Copyright © 2022 AccountIT Inc. All rights reserved.
    //

#import "DevicePreferences.h"

@interface Threshold : NSObject
@property (nonatomic , strong) NSString *strDetCount;
@property (nonatomic , strong) NSString *strDetTable;
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strSortID;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strValue;
- (void)setData:(NSDictionary *)dictData;
@end
@implementation Threshold
@synthesize strDetCount,strDetTable,strID,strName,strSortID,strStatus,strValue;
- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        strDetCount = [self isNullString:[dictData objectForKey:@"DetCount"]];
        strDetTable = [self isNullString:[dictData objectForKey:@"DetTable"]];
        strID = [self isNullString:[dictData objectForKey:@"ID"]];
        strName = [self isNullString:[dictData objectForKey:@"Name"]];
        strSortID = [self isNullString:[dictData objectForKey:@"SortID"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strValue = [self isNullString:[dictData objectForKey:@"Value"]];
    }
}
- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end

@interface AlertObject : NSObject
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strSortID;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strValue;
- (void)setData:(NSDictionary *)dictData;
@end
@implementation AlertObject
@synthesize strID,strName,strSortID,strStatus,strValue;
- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        strID = [self isNullString:[dictData objectForKey:@"ID"]];
        strName = [self isNullString:[dictData objectForKey:@"Name"]];
        strSortID = [self isNullString:[dictData objectForKey:@"SortID"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strValue = [self isNullString:[dictData objectForKey:@"Value"]];
    }
}

- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end

@interface GracePeriod : NSObject
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strSortID;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strValue;
- (void)setData:(NSDictionary *)dictData;
@end
@implementation GracePeriod
@synthesize strID,strName,strSortID,strStatus,strValue;
- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        strID = [self isNullString:[dictData objectForKey:@"ID"]];
        strName = [self isNullString:[dictData objectForKey:@"Name"]];
        strSortID = [self isNullString:[dictData objectForKey:@"SortID"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strValue = [self isNullString:[dictData objectForKey:@"Value"]];
    }
}

- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end

@interface BuzzerInterval : NSObject
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strSortID;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strValue;
- (void)setData:(NSDictionary *)dictData;
@end
@implementation BuzzerInterval
@synthesize strID,strName,strSortID,strStatus,strValue;
- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        strID = [self isNullString:[dictData objectForKey:@"ID"]];
        strName = [self isNullString:[dictData objectForKey:@"Name"]];
        strSortID = [self isNullString:[dictData objectForKey:@"SortID"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strValue = [self isNullString:[dictData objectForKey:@"Value"]];
    }
}

- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end

@interface PathCalib : NSObject
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strSortID;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strValue;
- (void)setData:(NSDictionary *)dictData;
@end
@implementation PathCalib
@synthesize strID,strName,strSortID,strStatus,strValue;
- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        strID = [self isNullString:[dictData objectForKey:@"ID"]];
        strName = [self isNullString:[dictData objectForKey:@"Name"]];
        strSortID = [self isNullString:[dictData objectForKey:@"SortID"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strValue = [self isNullString:[dictData objectForKey:@"Value"]];
    }
}

- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end


@interface DevicePreferences () {
@private BOOL isWaterCheck;
@private NSMutableArray *arrThreshold;
@private NSMutableArray *arrAlert;
@private NSMutableArray *arrGracePeriod;
@private NSMutableArray *arrBuzzerInterval;
@private NSMutableArray *arrPathCalib;
@private Threshold *selectedThreshold;
@private GracePeriod *selectedGracePeriod;
@private AlertObject *selectedAlert1;
@private AlertObject *selectedAlert2;
@private AlertObject *selectedAlert3;
@private AlertObject *selectedAlert4;
@private NSString *selectedEnableBuzzer;
@private AlertObject *selectedFinalAlert;
@private AlertObject *selectedAlertReset;
@private BuzzerInterval *selectedBuzzerInterval;
@private PathCalib *selectedCalibration;
@private NSString *thresholdValue;
@private NSString *gracePeriodValue;
@private NSString *alert1Value;
@private NSString *alert2Value;
@private NSString *alert3Value;
@private NSString *alert4Value;
@private NSString *finalAlertValue;
@private NSString *alertResetValue;
@private NSString *buzzerIntervalValue;
@private NSString *enableBuzzerValue;
@private NSString *calibrationValue;

}
@end

@implementation DevicePreferences

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"WaterWasp"];
    [super setBackBarItem:YES];
    
    [self onTouchHideKeyboard];

    selectedEnableBuzzer = NO;
    arrThreshold = [[NSMutableArray alloc] init];
    arrAlert = [[NSMutableArray alloc] init];
    arrGracePeriod = [[NSMutableArray alloc] init];
    arrBuzzerInterval = [[NSMutableArray alloc] init];
    arrPathCalib = [[NSMutableArray alloc] init];
    selectedThreshold = [[Threshold alloc] init];
    selectedGracePeriod = [[GracePeriod alloc] init];
    selectedAlert1 = [[AlertObject alloc] init];
    selectedAlert2 = [[AlertObject alloc] init];
    selectedAlert3 = [[AlertObject alloc] init];
    selectedAlert4 = [[AlertObject alloc] init];
    selectedFinalAlert = [[AlertObject alloc] init];
    selectedAlertReset = [[AlertObject alloc] init];
    selectedBuzzerInterval = [[BuzzerInterval alloc] init];
    selectedCalibration = [[PathCalib alloc] init];

    dispatch_queue_t dispatchQueue = dispatch_queue_create("apiCalls", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatchQueue, ^(void) {
        [self getWaterDetThres];
        [self getWaterAlertList];
        [self getWaterGracePeriod];
        [self getBuzzerInterval];
        [self getPathCalib];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    [self getWaterWasp];


    NSTimeInterval delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getWaterWasp];
    });

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)setViewLayout: (UIView *) view {
    [view.layer setBorderColor: [[UIColor systemGrayColor] CGColor]];
    [view.layer setBorderWidth: 1.0];
}

#pragma mark Custom methods
- (void)validateAlerts {
    if(self.tfAlert1.text > self.tfAlert2.text) {
        [self showAlert:@"Alert 1 should be lower than Alert 2"];
    }
    else if(self.tfAlert2.text > self.tfAlert3.text) {
        [self showAlert:@"Alert 2 should be lower than Alert 3"];
    }
    else if(self.tfAlert3.text > self.tfAlert4.text) {
        [self showAlert:@"Alert 3 should be lower than Alert 4"];
    }
    else if(self.tfAlert4.text > self.tfFinalAlert.text) {
        [self showAlert:@"Alert 4 should be lower than Final Alert"];
    }
}
- (void)showAlert:(NSString *)message {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark Actions
- (IBAction)onWaterPress:(UIButton *)sender {
    isWaterCheck = !isWaterCheck;
    [self.imgWaterCheck setImage: isWaterCheck ? [UIImage systemImageNamed:@"checkmark.square.fill"] : [UIImage systemImageNamed:@"square"]];
}

- (IBAction)onThresholdPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Threshold" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    for(int i=0; i<arrThreshold.count; i++) {
        Threshold *threshold = (Threshold *)[arrThreshold objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[threshold strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfThreshold setText:[threshold strName]];
            self->selectedThreshold = threshold;
        }]];
    }

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onGracePeriodPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Grace Period" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    for(int i=0; i<arrGracePeriod.count; i++) {
        GracePeriod *gracePeriod = (GracePeriod *)[arrGracePeriod objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[gracePeriod strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfGracePeriod setText:[gracePeriod strName]];
            self->selectedGracePeriod = gracePeriod;
        }]];
    }

    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onAlert1Press:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Alert 1" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfAlert1 setText:[alert strName]];
            self->selectedAlert1 = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onAlert2Press:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Alert 2" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfAlert2 setText:[alert strName]];
            self->selectedAlert2 = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onAlert3Press:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Alert 3" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfAlert3 setText:[alert strName]];
            self->selectedAlert3 = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onAlert4Press:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Alert 4" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfAlert4 setText:[alert strName]];
            self->selectedAlert4 = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onFinalAlertPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Final Alert" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfFinalAlert setText:[alert strName]];
            self->selectedFinalAlert = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onAlertResetAfterPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Alert Reset" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrAlert.count; i++) {
        AlertObject *alert = (AlertObject *)[arrAlert objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[alert strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfAlertResetAfter setText:[alert strName]];
            self->selectedAlertReset = alert;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)onBuzzerIntervalPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Buzzer Interval" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrBuzzerInterval.count; i++) {
        BuzzerInterval *buzzerInterval = (BuzzerInterval *)[arrBuzzerInterval objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[buzzerInterval strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfBuzzerInterval setText:[buzzerInterval strName]];
            self->selectedBuzzerInterval = buzzerInterval;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(IBAction)onEnableBuzzer: (id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Enable Buzzer" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self->_tfEnableBuzzer setText: @"Yes"];
        self->selectedEnableBuzzer = @"Yes";
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self->_tfEnableBuzzer setText: @"No"];
        self->selectedEnableBuzzer = @"No";
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onCalibrationPress:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NULL message:@"Calibration" preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    for(int i=0; i<arrPathCalib.count; i++) {
        PathCalib *pathCalib = (PathCalib *)[arrPathCalib objectAtIndex:i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[pathCalib strName] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_tfCalibration setText:[pathCalib strName]];
            self->selectedCalibration = pathCalib;
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onUpdatePress:(id)sender {
//    [self validateAlerts];
    [self updateWaterWasp];
}
- (IBAction)onWaterLogsPress:(id)sender {
    NSString *userId = [[User currentUser] userID];
    NSString *deviceId = [[User currentUser] getDeviceId];
    NSString *finalUrlString = [NSString stringWithFormat:@"https://app.logiqfish.com/User/UserDetail/WaterLogs?UserID=%@&DeviceID=%@", userId, deviceId];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: finalUrlString] options: @{} completionHandler: nil];
}
- (IBAction)onSubmitPreferencesPress:(id)sender {
    
}

#pragma mark APIs
- (void)getWaterDetThres {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_WATER_DET_THRES withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrThreshold removeAllObjects];
                for (NSDictionary *dict in response) {
                    Threshold *threshold = [[Threshold alloc] init];
                    [threshold setData:dict];
                    [self->arrThreshold addObject:threshold];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)getWaterAlertList {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_WATER_ALERT_LIST withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrAlert removeAllObjects];
                for (NSDictionary *dict in response) {
                    AlertObject *alert = [[AlertObject alloc] init];
                    [alert setData:dict];
                    [self->arrAlert addObject:alert];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)getWaterGracePeriod {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_WATER_GRACE_PERIODS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrGracePeriod removeAllObjects];
                for (NSDictionary *dict in response) {
                    GracePeriod *gracePeriod = [[GracePeriod alloc] init];
                    [gracePeriod setData:dict];
                    [self->arrGracePeriod addObject:gracePeriod];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)getBuzzerInterval {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_BUZZER_INTERVALS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrBuzzerInterval removeAllObjects];
                for (NSDictionary *dict in response) {
                    BuzzerInterval *buzzerInterval = [[BuzzerInterval alloc] init];
                    [buzzerInterval setData:dict];
                    [self->arrBuzzerInterval addObject:buzzerInterval];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)getPathCalib {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_WATER_CALIB withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrPathCalib removeAllObjects];
                for (NSDictionary *dict in response) {
                    PathCalib *pathCalib = [[PathCalib alloc] init];
                    [pathCalib setData:dict];
                    [self->arrPathCalib addObject:pathCalib];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)updateWaterWasp {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID]) {
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
        [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
        [dictParam setObject:@"2" forKey:@"Classifier_Model"];
        [dictParam setObject:@"" forKey:@"SVM_Thres"];
        [dictParam setObject:@"" forKey:@"Det_Tcnt"];
        [dictParam setObject:@"" forKey:@"Max_Gallons_Warning"];
        [dictParam setObject:@"" forKey:@"Mic_Vol_Gain"];
        [dictParam setObject:@"" forKey:@"SVM_Res_Table"];
        [dictParam setObject:@"" forKey:@"EI_Res_Table"];
        [dictParam setObject:[self->selectedThreshold strValue] forKey:kAPI_PARAM_THRESHOLD];
        [dictParam setObject:[self->selectedGracePeriod strValue] forKey:kAPI_PARAM_GRACE_PERIOD];
        [dictParam setObject:[self->selectedAlert1 strValue] forKey:kAPI_PARAM_ALERT1];
        [dictParam setObject:[self->selectedAlert2 strValue] forKey:kAPI_PARAM_ALERT2];
        [dictParam setObject:[self->selectedAlert3 strValue] forKey:kAPI_PARAM_ALERT3];
        [dictParam setObject:[self->selectedAlert4 strValue] forKey:kAPI_PARAM_ALERT4];
        [dictParam setObject:[self->selectedFinalAlert strValue] forKey:kAPI_PARAM_FINAL_ALERT];
        [dictParam setObject:[self->selectedAlertReset strValue] forKey:kAPI_PARAM_ALERT_RESET];
        [dictParam setObject:[self->selectedBuzzerInterval strValue] forKey:kAPI_PARAM_BUZZER_INTERVAL];
        [dictParam setObject:self->selectedEnableBuzzer forKey:kAPI_PARAM_ENABLE_BUZZER];
        [dictParam setObject:[self->selectedCalibration strValue] forKey:kAPI_PARAM_CALIBRATION];
    }
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
/*
     UserID=1273&
 DeviceID=830&
 Classifier_Model=2&
 Avg_Gpm=1.50&
 SVM_Thres=&
 EI_Thres=0.75&
 Det_Tcnt=&
 Max_Gallons_Warning=&
 Mic_Vol_Gain=&
 SVM_Res_Table=&
 EI_Res_Table=&
 Beep_Warning_Interval=1.00&
 Avg_Water_Reset_Time=25&
 Water_Alert1=60&
 Water_Alert2=120&
 Water_Alert3=180&
 Water_Alert4=240&
 Water_Killer=900&
 Water_Killer_Reset_Time=120
    */
    [afn getDataFromPath:kAPI_PATH_UPDATE_WATER_WASP withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [self->arrPathCalib removeAllObjects];
                for (NSDictionary *dict in response) {
                    PathCalib *pathCalib = [[PathCalib alloc] init];
                    [pathCalib setData:dict];
                    [self->arrPathCalib addObject:pathCalib];
                }
            }
            
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Updated Successfully"];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getWaterWasp {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID]) {
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
        [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    }

    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];

    [afn getDataFromPath:kAPI_PATH_GET_WATER_WASP withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *responseDic = response;
                self->thresholdValue = [responseDic valueForKey:kAPI_PARAM_THRESHOLD];
                self->gracePeriodValue = [responseDic valueForKey:kAPI_PARAM_GRACE_PERIOD];
                self->alert1Value = [responseDic valueForKey:kAPI_PARAM_ALERT1];
                self->alert2Value = [responseDic valueForKey:kAPI_PARAM_ALERT2];
                self->alert3Value = [responseDic valueForKey:kAPI_PARAM_ALERT3];
                self->alert4Value = [responseDic valueForKey:kAPI_PARAM_ALERT4];
                self->finalAlertValue = [responseDic valueForKey:kAPI_PARAM_FINAL_ALERT];
                self->alertResetValue = [responseDic valueForKey:kAPI_PARAM_ALERT_RESET];
                self->buzzerIntervalValue = [responseDic valueForKey:kAPI_PARAM_BUZZER_INTERVAL];
                self->calibrationValue = [responseDic valueForKey:kAPI_PARAM_CALIBRATION];
                self->enableBuzzerValue = [responseDic valueForKey: kAPI_PARAM_ENABLE_BUZZER];
                [self setSelectedValues];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)setSelectedValues {
    self->selectedThreshold = arrThreshold[[self findIndexOf: self->thresholdValue from: self->arrThreshold]];
    self->selectedGracePeriod = arrGracePeriod[[self findIndexOf: self->gracePeriodValue from: self->arrGracePeriod]];
    self->selectedAlert1 = arrAlert[[self findIndexOf: self->alert1Value from: self->arrAlert]];
    self->selectedAlert2 = arrAlert[[self findIndexOf: self->alert2Value from: self->arrAlert]];
    self->selectedAlert3 = arrAlert[[self findIndexOf: self->alert3Value from: self->arrAlert]];
    self->selectedAlert4 = arrAlert[[self findIndexOf: self->alert4Value from: self->arrAlert]];
    self->selectedFinalAlert = arrAlert[[self findIndexOf: self->finalAlertValue from: self->arrAlert]];
    self->selectedAlertReset = arrAlert[[self findIndexOf: self->alertResetValue from: self->arrAlert]];
    self->selectedBuzzerInterval = arrBuzzerInterval[[self findIndexOf: self->buzzerIntervalValue from: self->arrBuzzerInterval]];
    self->selectedCalibration = arrPathCalib[[self findIndexOf: self->calibrationValue from:arrPathCalib]];

    if ([self->enableBuzzerValue isEqualToString: @"1"]) {
        self->selectedEnableBuzzer = @"Yes";
    } else {
        self->selectedEnableBuzzer = @"No";
    }

    [self setFields];
}

-(void)setFields {
    _tfThreshold.text = self->selectedThreshold.strName;
    _tfGracePeriod.text = self->selectedGracePeriod.strName;
    _tfAlert1.text = self->selectedAlert1.strName;
    _tfAlert2.text = self->selectedAlert2.strName;
    _tfAlert3.text = self->selectedAlert3.strName;
    _tfAlert4.text = self->selectedAlert4.strName;
    _tfFinalAlert.text = self->selectedFinalAlert.strName;
    _tfAlertResetAfter.text = self->selectedAlertReset.strName;
    _tfBuzzerInterval.text = self->selectedBuzzerInterval.strName;
    _tfCalibration.text = self->selectedCalibration.strName;
    _tfEnableBuzzer.text = self->selectedEnableBuzzer;
}

// MARK: - helper

-(NSInteger)findIndexOf:(NSString *)value from:(NSMutableArray *)object {
    for (int i=0; i<[object count]; i++) {
        if ([object[i] isKindOfClass: [Threshold self]]) {
            Threshold *threshold = object[i];
            if (threshold.strValue == value) {
                return i;
            }
        } else if ([object[i] isKindOfClass: [GracePeriod self]]) {
            GracePeriod *gracePeriod = object[i];
            if (gracePeriod.strValue == value) {
                return i;
            }
        } else if ([object[i] isKindOfClass: [AlertObject self]]) {
            AlertObject *alert = object[i];
            if (alert.strValue == value) {
                return i;
            }
        } else if ([object[i] isKindOfClass: [PathCalib self]]) {
            PathCalib *calibration = object[i];
            if (calibration.strValue == value) {
                return i;
            }
        } else if ([object[i] isKindOfClass: [BuzzerInterval self]]) {
            BuzzerInterval *buzzer = object[i];
            if (buzzer.strValue == value) {
                return i;
            }
        }
    }
    return 0;
}

- (NSString *)extractNumberFromText:(NSString *)text {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

@end
