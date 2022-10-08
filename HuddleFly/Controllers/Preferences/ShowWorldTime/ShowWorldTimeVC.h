//
//  ShowWorldTimeVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface ShowWorldTimeVC : BaseVC <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrWorldTime;
    NSMutableArray *arrSaveData;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSearchKeyword;

@property (weak, nonatomic) IBOutlet UIButton *btnAnalogClock;
@property (weak, nonatomic) IBOutlet UIButton *btnDigitalClock;
@property (weak, nonatomic) IBOutlet UIButton *btnNone;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UITableView *tblWorldTime;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


- (IBAction)onClickAnalogClock:(id)sender;
- (IBAction)onClickDigitalClock:(id)sender;
- (IBAction)onClickNone:(id)sender;
- (IBAction)onClickCountry:(id)sender;
- (IBAction)onClickCity:(id)sender;
- (IBAction)onClickGo:(id)sender;
- (IBAction)onClickSubmit:(id)sender;

@end
