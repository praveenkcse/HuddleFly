//
//  DeviceInfoVC.m
//  HuddleFly
//
//  Created by BMAC on 02/08/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "DeviceInfoVC.h"
#import "LocalEvents.h"
#import "FullScreenVC.h"

@interface DeviceInfoVC ()

@property (nonatomic , assign)IBOutlet UILabel *lblTitle;
@property (nonatomic , assign)IBOutlet UILabel *lblLastContact;
@property (nonatomic , assign)IBOutlet UILabel *lblMacAddress;
@property (nonatomic , assign)IBOutlet UILabel *lblIPAddess;
@property (nonatomic , assign)IBOutlet UILabel *lblDeviceLocation;
@property (nonatomic , assign)IBOutlet UILabel *lblStatus;
@property (nonatomic , assign)IBOutlet UILabel *lblDisplayMode;
@property (nonatomic , assign)IBOutlet UILabel *lblConnType;
@property (nonatomic , assign)IBOutlet UILabel *lblSSID;
@property (nonatomic , assign)IBOutlet UILabel *lblScreen;
@property (nonatomic , assign)IBOutlet UIImageView *imgView;

@property (nonatomic , assign)IBOutlet UILabel *lblOffline;
@property (nonatomic , assign)IBOutlet UILabel *lblIsMaster;
@end

@implementation DeviceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Device Information"];
    [super setBackBarItem:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:)];
    tap.numberOfTapsRequired = 1.0;
    [_imgView addGestureRecognizer:tap];
    
    self.lblTitle.font = [UIFont boldSystemFontOfSize:15];
    self.lblTitle.text = _deviceListModel.strDeviceName;
    self.lblLastContact.text = _deviceListModel.strTimeStamp;
    self.lblMacAddress.text = _deviceListModel.strMacAddr;
    
    
    if([_deviceListModel.strConnType isEqualToString:@"wlan0"]){
        self.lblConnType.text = @"wifi";
    }else if ([_deviceListModel.strConnType isEqualToString:@"eth0"]){
        self.lblConnType.text = @"lan";
    }else{
        self.lblConnType.text = _deviceListModel.strConnType;
        if (!_deviceListModel.strConnType.length) {
            self.lblConnType.text = @"unknown";
        }
    }
    
    self.lblDeviceLocation.text = _deviceListModel.strDeviceLocation;
    self.lblDisplayMode.text = _deviceListModel.strDisplayMode;
    self.lblIPAddess.text = _deviceListModel.strIPAddr;
    self.lblSSID.text = _deviceListModel.strSSID;
    
    //self.lblScreen.text = [NSString stringWithFormat:@"Screen:%@",_deviceListModel.strScreen];
    if([_deviceListModel.strStatus integerValue] == 1){
        self.lblScreen.text = @"on";
    }else{
        self.lblScreen.text = @"off";
    }
    
    //self.lblStatus.text = [NSString stringWithFormat:@"Status:%@",_deviceListModel.strStatus];
    
    NSInteger deviceStatus = [_deviceListModel.strStatus integerValue];
    if(deviceStatus == 1){
        self.lblStatus.text = @"active";
    }else if (deviceStatus == -1){
        self.lblStatus.text = @"deleted";
    }else{
        self.lblStatus.text = @"inactive";
    }
    
    if([_deviceListModel.strOfflineMode integerValue] == 1){
        _lblOffline.text = @"on";
    }else{
        _lblOffline.text = @"off";
    }
    
    if([_deviceListModel.strIsMaster integerValue] == 1){
        _lblIsMaster.text = @"true";
    }else{
        _lblIsMaster.text = @"false";
    }
    
    NSString *strImageUrl = [NSString stringWithFormat:@"https://app.huddlefly.net/uploads/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
    [self imageData:strImageUrl];
}

- (IBAction)onClickBtnURL:(id)sender
{
    //[self imageData:_btnURL.currentTitle];
}

- (IBAction)onClickImage:(id)sender
{
    [self performSegueWithIdentifier:@"segueToFullScreen" sender:self];
   /* UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width-50,view.frame.size.height-50)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = _imgView.image;
    [view addSubview:imageView];
    imageView.center = view.center;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((imageView.frame.origin.x + imageView.frame.size.width)-10, imageView.frame.origin.y-10, 30, 30);
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.layer.cornerRadius = 15;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;*/
    
}
/*
- (void)closePopup:(UIButton *)btn
{
    [btn.superview removeFromSuperview];
}
*/

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segueToFullScreen"]){
        
        NSString *strImageUrl = [NSString stringWithFormat:@"https://app.huddlefly.net/uploads/screencap/%@_%@_screencap.png",_deviceListModel.strUserId,_deviceListModel.strDeviceId];
        
        FullScreenVC *full = (FullScreenVC *)segue.destinationViewController;
        full.strImageUrl = strImageUrl;
    }
}


@end
