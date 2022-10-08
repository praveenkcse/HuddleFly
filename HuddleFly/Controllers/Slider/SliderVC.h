//
//  SliderVC.h
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface SliderVC : BaseVC
{
    IBOutlet UILabel *lblUsername;
    IBOutlet UIScrollView *scrBg;
    IBOutlet UIButton *btnLogout;
}
- (IBAction)onClickPref:(id)sender;
- (IBAction)onClickRegiDevice:(id)sender;
- (IBAction)onClickRegiLocation:(id)sender;
- (IBAction)onClickDeviceCmd:(id)sender;
- (IBAction)onClickLogout:(id)sender;
- (IBAction)onClickDeviceHealth:(id)sender;
- (IBAction)onClickDeviceSettings:(id)sender;
- (IBAction)onClickConfigurationHuddlyFly:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *promiumYoutuImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumPowerImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumUsbImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumDevicesImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumDisplayImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumCommandImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumShcaduleImg;
@property (weak, nonatomic) IBOutlet UIImageView *promiumHealthImg;


@end
