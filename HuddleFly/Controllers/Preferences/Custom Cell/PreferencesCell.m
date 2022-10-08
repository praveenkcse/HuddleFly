//
//  PreferencesCell.m
//  HuddleFly
//
//  Created by BMAC on 11/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "PreferencesCell.h"
#import "UIView+Utils.h"
#import "Preferences.h"
#import "UtilityClass.h"
#import "User.h"
#import "AppDelegate.h"
#import "LocalEvents.h"
#import "Constants.h"
@implementation PreferencesCell

- (void)awakeFromNib {
    // Initialization code
    self.imgView.backgroundColor = [UIColor darkGrayColor];
    [self.imgView applyFullCornerWithColor:[UIColor darkGrayColor]];
    
    if(self.btnDeviceInfo){
        _btnDeviceInfo.layer.cornerRadius = 3.0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)onClickCheckMark:(id)sender {

    UIButton *btn = (UIButton *)sender;
    
    if ([cellData isKindOfClass:[Preferences class]]) {
    
        Preferences *pref = (Preferences *)cellData;
        
        /*Checking for User Paid or not if paid then select option,else not*/
        if ([pref.IsPaid isEqualToString:@"1"]) {
            if([[User getUserDataWithParam:USER_PROFILE_HASPAID] isEqualToString:@"0"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
                return;
            }
        }
        /*End*/
        
        btn.selected = !btn.selected;

        pref.isSelected = btn.selected;
        
        if(btn.isSelected) {
            
            // if it is Photo Album (FaceBook)  or Post A website the all other options should be deselected
//            if(/*pref.ID_ == 3 ||*/ pref.ID_ == 9 || pref.ID_ == 14 || pref.ID_ == 100 || pref.ID_ == 101 || pref.ID_ == 102) {
//                
//                for (int index = 0; index < [UtilityClass checkArraySize]; index++) {
//                    
//                    Preferences *p = (Preferences *)[UtilityClass getElementObjAtIndex:index];
//                    UIButton *b = (UIButton *)[UtilityClass getElementControlAtIndex:index];
//                    b.selected = NO;
//                    p.isSelected = NO;
//                    
//                }
//                
//                [UtilityClass removeAllArrayObj];
//            } else {
//                
//                // if other option is selcted then Photo Album (FaceBook)  or Post A website  should be deselected
//                for (int index = 0; index < [UtilityClass checkArraySize]; index++) {
//                    
//                    Preferences *pref = (Preferences *)[UtilityClass getElementObjAtIndex:index];
//                    UIButton *b = (UIButton *)[UtilityClass getElementControlAtIndex:index];
//                    
//                    if(/*pref.ID_ == 3 || */pref.ID_ == 9 || pref.ID_ == 14 || pref.ID_ == 100 || pref.ID_ == 101 || pref.ID_ == 102) {
//
//                        b.selected = NO;
//                        pref.isSelected = NO;
//                        [UtilityClass removeObjAtIndex:index];
//                        index = index - 1;
//                    }
//                }
//
//            }

            
            if([UtilityClass checkArraySize]==0)
            {
                [UtilityClass arrayInit];
            }
            
//            [UtilityClass setElementObj:pref];
//            [UtilityClass setElementControl:btn];
        }
        else if([UtilityClass checkArraySize] > 0) {
            [UtilityClass removeObj:pref];
        }
     
        if ([cellParent respondsToSelector:@selector(reloadPreferenceData)])
            [cellParent performSelector:@selector(reloadPreferenceData)];
    }
}

//
//- (IBAction)onClickCheckMark:(id)sender {
//    // add >
////    if ([cellData isKindOfClass:[Preferences class]]) {
////        Preferences *pref = (Preferences *)cellData;
////        if ([pref.IsPaid isEqualToString:@"0"]) {
////                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
////                return;
////        }
////    }
//    // < add
//    UIButton *btn = (UIButton *)sender;
//    btn.selected = !btn.selected;
//    if ([cellData isKindOfClass:[Preferences class]]) {
//        Preferences *pref = (Preferences *)cellData;
//        
//        /*Checking for User Paid or not if paid then select option,else not*/
//        if ([pref.IsPaid isEqualToString:@"1"]) {
//            if([[User getUserDataWithParam:USER_PROFILE_HASPAID] isEqualToString:@"0"]){
//                btn.selected = !btn.selected;
//                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
//                return;
//            }
//        }
//        /*End*/
//        
//        pref.isSelected = btn.selected;
//        
//        if(btn.isSelected)
//        {
//            if([UtilityClass checkArraySize] == 1)
//            {
//                Preferences *p = (Preferences *)[UtilityClass getElementObjAtIndex:0];
//                UIButton *b = (UIButton *)[UtilityClass getElementControlAtIndex:0];
//                
//                //(id 3) for Facebook (id 14) for LockScreen
//                // (id 14) Added By DHAWAL 29-Jun-2016
//                
//                if(p.ID_ == 3 || p.ID_ == 6 || p.ID_ == 14)
//                {
//                    b.selected = NO;
//                    p.isSelected = NO;
//                    [UtilityClass removeAllArrayObj];
//                }
//            }
//            if(pref.ID_ == 3 || pref.ID_ == 6 || pref.ID_ == 14)
//            {
//                for(int i = 0 ; i < [UtilityClass checkArraySize] ; i++)
//                {
//                    Preferences *p = (Preferences *)[UtilityClass getElementObjAtIndex:i];
//                    UIButton *b = (UIButton *)[UtilityClass getElementControlAtIndex:i];
//                    
//                    b.selected = NO;
//                    p.isSelected = NO;
//                    
//                }
//                [UtilityClass removeAllArrayObj];
//            }
//            
//            if([UtilityClass checkArraySize]==0)
//            {
//                [UtilityClass arrayInit];
//            }
//            
//            if([UtilityClass arrayContainsObj:pref]){
//                [UtilityClass removeAllArrayObj];
//            }
//            [UtilityClass setElementObj:pref];
//            [UtilityClass setElementControl:btn];
//        }
//        else{
//            if([UtilityClass checkArraySize] == 1)
//            {
//                Preferences *p = (Preferences *)[UtilityClass getElementObjAtIndex:0];
//                if(p.ID_ == 3 || p.ID_ == 6 || p.ID_ == 14)
//                {
//                    [UtilityClass removeAllArrayObj];
//                }
//            }
//        }
//    }
//}

- (void)setCellData:(id)data withParent:(id)parent {
    cellData = data;
    cellParent = parent;
    if ([cellData isKindOfClass:[Preferences class]]) {
        Preferences *pref = (Preferences *)cellData;
        self.lblTitle.text = pref.Name;
        // add >
//        if ([pref.IsPaid isEqualToString:@"1"]) {
        // add<
        self.btnCheckMark.selected = pref.isSelected;
//        }
    }
    else if ([cellData isKindOfClass:[DeviceList class]]){
        DeviceList *list = (DeviceList *)cellData;
        self.lblTitle.font = [UIFont boldSystemFontOfSize:15];
        self.lblTitle.text = list.strDeviceName;
        self.lblLastContact.text = [NSString stringWithFormat:@"Last Update:%@",list.strTimeStamp];//Contact
        
        /* //Remove By DHAWAL 2-Aug-2016
        self.lblMacAddress.text = [NSString stringWithFormat:@"Mac:%@",list.strMacAddr];
        self.lblConnType.text = [NSString stringWithFormat:@"Conn:%@",list.strConnType];
        self.lblDeviceLocation.text = [NSString stringWithFormat:@"Location:%@",list.strDeviceLocation];
        self.lblDisplayMode.text = [NSString stringWithFormat:@"Display:%@",list.strDisplayMode];
        self.lblIPAddess.text = [NSString stringWithFormat:@"IP:%@",list.strIPAddr];
        self.lblSSID.text = [NSString stringWithFormat:@"SSID:%@",list.strSSID];
        self.lblStatus.text = [NSString stringWithFormat:@"Status:%@",list.strStatus];
        self.lblScreen.text = [NSString stringWithFormat:@"Screen:%@",list.strScreen];
        */
    }
}


@end
