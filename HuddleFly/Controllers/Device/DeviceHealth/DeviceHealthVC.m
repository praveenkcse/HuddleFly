//
//  DeviceHealthVC.m
//  HuddleFly
//
//  Created by BMAC on 29/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "DeviceHealthVC.h"
#import "LocalEvents.h"
#import "FullScreenVC.h"
#import "Global.h"
#import "Harpy.h"
@interface DeviceHealthVC ()
@property (nonatomic , assign)IBOutlet UILabel *lblTitle;
@property (nonatomic , assign)IBOutlet UILabel *lbliOSVersion;
@property (nonatomic , assign)IBOutlet UILabel *lblMacAddress;
@property (nonatomic , assign)IBOutlet UILabel *lblIPAddess;
@property (nonatomic , assign)IBOutlet UILabel *lblDeviceLocation;
@property (nonatomic , assign)IBOutlet UILabel *lblStatus;
@property (nonatomic , assign)IBOutlet UILabel *lblDisplayMode;
@property (nonatomic , assign)IBOutlet UILabel *lblConnType;
@property (nonatomic , assign)IBOutlet UILabel *lblSSID_;
@property (nonatomic , assign)IBOutlet UILabel *lblScreen;
@property (nonatomic , assign)IBOutlet UIImageView *imgView;
@property (nonatomic , assign)IBOutlet UILabel *signalStrength;
@property (nonatomic , assign)IBOutlet UILabel *signalType;
@property (nonatomic , assign)IBOutlet UILabel *signalEncryption;

@property (nonatomic , assign)IBOutlet UILabel *lblOffline;
@property (nonatomic , assign)IBOutlet UILabel *lblIsMaster;
@property (nonatomic , assign)IBOutlet UILabel *lblIsDeviceSchedule;
@property (nonatomic , assign)IBOutlet UILabel *lblDeviceVersion;
@property (nonatomic , assign)IBOutlet UILabel *lblSwap;
@property (nonatomic , assign)IBOutlet UILabel *lblVoltage;

@end

@implementation DeviceHealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device Health / Information"];
    [super setBackBarItem:YES];
    [self.scrView setContentSize:CGSizeMake(self.view.frame.size.width, 7*37+10 + 700)];//7 Replace By 13 //Change By DHAWAL 28-Jun-2016
    [super setHelpBarButton:6];//ADDED BY DHAWAL 29-JUN-2017
    
    [self getDeviceHealth];
    [self infoViewDidLoad];
//    _lbliOSVersion.text = [[Harpy sharedInstance] currentAppStoreVersion];
//    _lbliOSVersion.text = [[UIDevice currentDevice] systemVersion];
//    _lblDeviceVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)helpPath {
    return @"0-6";
}

#pragma mark - Action.

- (void)getDeviceHealth {
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GETDEVICEHEALTH withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
//        [self getLocationHealth];
        if (response) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                self.lblCPU.text = [NSString stringWithFormat:@"%@%%",[response objectForKey:@"DeviceCpu"]];
                self.signalType.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"SignalType"]];
                self.signalStrength.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"SignalStrength"]];
                self.lblDisk.text = [NSString stringWithFormat:@"%@%%",[response objectForKey:@"DeviceDisk"]];
                self.lblRAM.text = [NSString stringWithFormat:@"%@%%",[response objectForKey:@"DeviceMem"]];
                self.lblIP.text = [response objectForKey:@"DeviceIp"];
                self.lblLastUpdate.text = [response objectForKey:@"DeviceHealthTime"];
                self.lblSSID.text = [response objectForKey:@"DeviceSsid"];
                self.lblUptime.text = [response objectForKey:@"DeviceUptime"];
                self.lbliOSVersion.text = [response objectForKey:@"iOSVersion"];
                self.lblDeviceVersion.text = [response objectForKey:@"Version"];
                self.lblTitle.text = [NSString stringWithFormat:@"( %@ )",[response objectForKey:@"DeviceName"]];
//                self.lblNewVersion.text = [response objectForKey:@"TimeStamp"];
                self.lblMacAddress.text = [response objectForKey:@"DeviceMac"];
                NSString *swapPercent = [response objectForKey:@"SwapPercent"];
                self.lblSwap.text = [NSString stringWithFormat:@"%@%%",swapPercent];
                NSString* connectionType = [response objectForKey:@"ConnType"];
                
                if ([[response objectForKey:@"SignalEncrption"] isKindOfClass:[NSNull class]]){
                    self.signalEncryption.text = @"";
                }else{
                    self.signalEncryption.text = [response objectForKey:@"SignalEncrption"];
                }
                
                
                if([connectionType isEqualToString:@"wlan0"]){
                    self.lblConnType.text = @"wifi";
                }else if ([connectionType isEqualToString:@"eth0"]){
                    self.lblConnType.text = @"lan";
                }else{
                    self.lblConnType.text = connectionType;
                    if (!connectionType.length) {
                        self.lblConnType.text = @"unknown";
                    }
                }

                self.lblDeviceLocation.text = [response objectForKey:@"DeviceLocation"];
                self.lblDisplayMode.text = [response objectForKey:@"DisplayMode"];
                self.lblIPAddess.text = [response objectForKey:@"DeviceIp"];
                self.lblSSID_.text = [response objectForKey:@"DeviceSsid"];
                self.lblTemperature.text = [response objectForKey:@"Temperature"];
                self.lblVoltage.text = [response objectForKey:@"Voltage"];

                if([[response objectForKey:@"ScreenStatus"] integerValue] == 1){
                    self.lblScreen.text = @"on";
                }else{
                    self.lblScreen.text = @"off";
                }
                

                NSInteger deviceStatus = [[response objectForKey:@"Status"] integerValue];
                if(deviceStatus == 1){
                    self.lblStatus.text = @"active";
                }else if (deviceStatus == -1){
                    self.lblStatus.text = @"deleted";
                }else{
                    self.lblStatus.text = @"inactive";
                }

                NSInteger offline = [[response objectForKey:@"OfflineMode"] integerValue];
                if(offline == 1){
                    self->_lblOffline.text = @"on";
                }else{
                    self->_lblOffline.text = @"off";
                }
                
                bool IsMaster = [[response objectForKey:@"IsMaster"] boolValue];

                if(IsMaster){
                    self->_lblIsMaster.text = @"yes";
                }else{
                    self->_lblIsMaster.text = @"no";
                }
                
                bool IsScheduleActive = [[response objectForKey:@"IsScheduleActive"] boolValue];

                if(IsScheduleActive){
                    self->_lblIsDeviceSchedule.text = @"on";
                }else{
                    self->_lblIsDeviceSchedule.text = @"off";
                }

                
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

//- (void)getLocationHealth {
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    if([[User currentUser] userID])
//        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
//    
//    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
//    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
//    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
//    
//    [afn getDataFromPath:kAPI_PATH_GET_LOCATIONHEALTH withParamData:dictParam withBlock:^(id response, NSError *error) {
//        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
//        if (response) {
//            if ([response isKindOfClass:[NSDictionary class]]) {
//                float temperature = [[response objectForKey:@"Temperature"] floatValue];
//                self.lblTemperature.text = [NSString stringWithFormat:@"%.1f°F",temperature];
//                self.lblHumidity.text = [NSString stringWithFormat:@"%@%%",[response objectForKey:@"Humidity"]];
//                self.lblLocationHealth.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"LocationHealthTime"]];
//            }
//            [self infoViewDidLoad];
//
//        }
//        else{
//            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Info
-(void)infoViewDidLoad{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:)];
    tap.numberOfTapsRequired = 1.0;
    [_imgView addGestureRecognizer:tap];
    if ([Global sharedInstance].selectDeviceRow>-1) {
        if ([Global sharedInstance].DeviceListA.count) {
            _deviceListModel = [Global sharedInstance].DeviceListA[[Global sharedInstance].selectDeviceRow];
        }        
    }

    NSString *strImageUrl = [NSString stringWithFormat:@"https://app.logiqfish.com/user/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
//    NSString *strImageUrl = [NSString stringWithFormat:@"https://app.huddlefly.net/user/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
    
    [self imageData:strImageUrl];
}
- (IBAction)onClickImage:(id)sender
{
    [self performSegueWithIdentifier:@"segueToFullScreen" sender:self];
    
}
- (void)imageData :(NSString *)strUrl{
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:strUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
        if(data){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [UIImage imageWithData:data];
                if(img){
                    self.imgView.userInteractionEnabled = YES;
                    self.imgView.image = img;
                }
                [self.imgView setNeedsDisplay];
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            });
        }
        else
            [[AppDelegate sharedAppDelegate] showToastMessage:connectionError.localizedDescription];
    }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segueToFullScreen"]){
    
        NSString *strImageUrl = [NSString stringWithFormat:@"https://app.logiqfish.com/user/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
//        NSString *strImageUrl = [NSString stringWithFormat:@"https://app.huddlefly.net/user/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
        
        FullScreenVC *full = (FullScreenVC *)segue.destinationViewController;
        full.strImageUrl = strImageUrl;
    }
}
@end
