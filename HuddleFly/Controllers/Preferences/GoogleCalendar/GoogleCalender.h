//
//  GoogleCalender.h
//  HuddleFly
//
//  Created by BMAC on 17/08/16.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import "BaseVC.h"

@interface GoogleCalender : BaseVC
{
    NSMutableArray *arrGoogleCalendar;
}
//@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
//@property (weak, nonatomic) IBOutlet UIButton *btnRemindeMe;
//@property (weak, nonatomic) IBOutlet UITextField *txtYoutubeUrl;
@property (nonatomic, weak) IBOutlet UITableView *tblCalender;
//@property (weak, nonatomic) IBOutlet UIButton *btnMonth;
//@property (weak, nonatomic) IBOutlet UIButton *btnWeek;
//@property (weak, nonatomic) IBOutlet UIButton *btnDay;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
//@property (weak, nonatomic) IBOutlet UIButton *btnShowTask;
@property (weak, nonatomic) IBOutlet UIButton *btnColorPicker;
@property (nonatomic,weak)IBOutlet UITextField *pixTransitionTextField;
//- (IBAction)onClickMonth:(id)sender;
//- (IBAction)onClickWeek:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDropDown;
    
@end
