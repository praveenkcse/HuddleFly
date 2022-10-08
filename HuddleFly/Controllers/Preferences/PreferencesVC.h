//
//  PreferencesVC.h
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "PreferencesCell.h"


@interface PreferencesVC : BaseVC<UITableViewDataSource , UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *arrOptionData;
    NSMutableDictionary *optionsData;
    NSMutableArray *categories;
}
@property (nonatomic, weak) IBOutlet UITableView *tblPreference;
@property (nonatomic , strong) NSString *strTitle;
@property (weak, nonatomic) IBOutlet UIButton *submitPrefernceBtn;

@property (weak, nonatomic) IBOutlet UIButton *deviceListBtn;
@property (weak, nonatomic) IBOutlet UIButton *displaySetBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceCommandBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceHealthBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceSchaduleBtn;

@property (weak, nonatomic) IBOutlet UILabel *deviceListL;
@property (weak, nonatomic) IBOutlet UILabel *displaySetL;
@property (weak, nonatomic) IBOutlet UILabel *deviceCommandL;
@property (weak, nonatomic) IBOutlet UILabel *deviceHealthL;
@property (weak, nonatomic) IBOutlet UILabel *deviceSchaduleL;

- (IBAction)onClickSavePreferences:(id)sender;
- (IBAction)onClickSchedule:(id)sender;
- (void) getOptionData;


@end
