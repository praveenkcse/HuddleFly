//
//  PreferencesCell.h
//  HuddleFly
//
//  Created by BMAC on 11/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesCell : UITableViewCell {
    id cellData;
    id cellParent;
}

@property (nonatomic , assign)IBOutlet UILabel *lblTitle;
@property (nonatomic , weak) IBOutlet UIButton *btnCheckMark;
@property (nonatomic , assign)IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *masterL;
@property (weak, nonatomic) IBOutlet UILabel *alonemasterL;
@property (weak, nonatomic) IBOutlet UILabel *followMasterL;
@property (weak, nonatomic) IBOutlet UILabel *commaL;

@property (nonatomic , assign)IBOutlet UILabel *lblLastContact;
@property (weak, nonatomic) IBOutlet UIImageView *premiumImg;
@property (nonatomic , assign)IBOutlet UIButton *btnDeviceInfo;
/*
@property (nonatomic , assign)IBOutlet UILabel *lblMacAddress;
@property (nonatomic , assign)IBOutlet UILabel *lblIPAddess;
@property (nonatomic , assign)IBOutlet UILabel *lblDeviceLocation;
@property (nonatomic , assign)IBOutlet UILabel *lblStatus;
@property (nonatomic , assign)IBOutlet UILabel *lblDisplayMode;
@property (nonatomic , assign)IBOutlet UILabel *lblConnType;
@property (nonatomic , assign)IBOutlet UILabel *lblSSID;
@property (nonatomic , assign)IBOutlet UILabel *lblScreen;
*/

- (IBAction)onClickCheckMark:(id)sender;

- (void)setCellData:(id)data withParent:(id)parent;

@end
