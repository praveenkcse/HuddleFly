//
//  LocalEventsVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface LocalEventsVC : BaseVC <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrLocalEvents;
    NSString *strEventCategory;
    CGRect oldFrame;
}
@property (weak, nonatomic) IBOutlet UILabel *lblMsgEvent;
@property (weak, nonatomic) IBOutlet UIView *viewPanel;
@property (weak, nonatomic) IBOutlet UITableView *tblLocation;

@property (weak, nonatomic) IBOutlet UITextField *txtKeyword;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchIn;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;

@property (weak, nonatomic) IBOutlet UIButton *btnChooseEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnEnterKeyword;
@property (weak, nonatomic) IBOutlet UIButton *btnThisWeek;
@property (weak, nonatomic) IBOutlet UIButton *btnNextWeek;
@property (weak, nonatomic) IBOutlet UIButton *btnThisMonth;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

- (IBAction)onClickEventCat:(id)sender;
- (IBAction)onClickEnterKeyword:(id)sender;
- (IBAction)onClickSubmit:(id)sender;
- (IBAction)onClickThisWeek:(id)sender;
- (IBAction)onClickNextWeek:(id)sender;
- (IBAction)onClickThisMonth:(id)sender;

@end
