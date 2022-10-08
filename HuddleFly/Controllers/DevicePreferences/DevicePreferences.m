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


@interface DevicePreferences ()
{
@private BOOL isWaterCheck;
@private NSMutableArray *arrThreshold;
@private NSMutableArray *arrAlert;
@private NSMutableArray *arrGracePeriod;
@private NSMutableArray *arrBuzzerInterval;
@private NSMutableArray *arrPathCalib;
    
    
}
@end

@implementation DevicePreferences

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device Preferences"];
    [super setBackBarItem:YES];
    
    [self onTouchHideKeyboard];
    
    arrThreshold = [[NSMutableArray alloc] init];
    arrAlert = [[NSMutableArray alloc] init];
    arrGracePeriod = [[NSMutableArray alloc] init];
    arrBuzzerInterval = [[NSMutableArray alloc] init];
    arrPathCalib = [[NSMutableArray alloc] init];

    [self getWaterDetThres];
    [self getWaterAlertList];
    [self getWaterGracePeriod];
    [self getBuzzerInterval];
    [self getPathCalib];

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
        }]];
    }
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
        }]];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onUpdatePress:(id)sender {
    [self validateAlerts];
}
- (IBAction)onWaterLogsPress:(id)sender {
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
    }
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
        //    UserID=1273&DeviceID=830&Classifier_Model=2&Avg_Gpm=1.50&SVM_Thres=&EI_Thres=0.75&Det_Tcnt=&Max_Gallons_Warning=&Mic_Vol_Gain=&SVM_Res_Table=&EI_Res_Table=&Beep_Warning_Interval=1.00&Avg_Water_Reset_Time=25&Water_Alert1=60&Water_Alert2=120&Water_Alert3=180&Water_Alert4=240&Water_Killer=900&Water_Killer_Reset_Time=120
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
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

// MARK: - helper

- (NSString *)extractNumberFromText:(NSString *)text {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

@end
