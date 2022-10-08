//
//  OptionsViewController.m
//  HuddleFly
//
//  Created by Anton Boyarkin on 22/02/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import "OptionsViewController.h"
//#import "UIView+Utils.h"
#import "Preferences.h"
#import "ModelMenu.h"
#import "Global.h"

@implementation OptionsCell

//- (void)awakeFromNib {
    // Initialization code
//    self.imgView.backgroundColor = [UIColor darkGrayColor];
//    [self.imgView applyFullCornerWithColor:[UIColor darkGrayColor]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)onClickCheckMark:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([cellData isKindOfClass:[Preferences class]]) {
        
        Preferences *pref = (Preferences *)cellData;
        
        /*Checking for User Paid or not if paid then select option,else not*/
//        if ([pref.IsPaid isEqualToString:@"1"]) {
//            if([[User getUserDataWithParam:USER_PROFILE_HASPAID] isEqualToString:@"0"]){
//                [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
//                return;
//            }
//        }
        /*End*/
        
        btn.selected = !btn.selected;
        
        pref.isSelected = btn.selected;
        
        if(btn.isSelected) {
            if([UtilityClass checkArraySize]==0)
            {
                [UtilityClass arrayInit];
            }
        }
        else if([UtilityClass checkArraySize] > 0) {
            [UtilityClass removeObj:pref];
        }
        
        [self sendSelectedOption];
        
        if ([cellParent respondsToSelector:@selector(reloadPreferenceData)])
            [cellParent performSelector:@selector(reloadPreferenceData)];
    }
}

- (void)setCellData:(Preferences*)data withParent:(id)parent {
    cellData = data;
    cellParent = parent;
    if ([cellData isKindOfClass:[Preferences class]]) {
        Preferences *pref = (Preferences *)cellData;
        self.lblTitle.text = pref.Name;
        self.btnCheckMark.selected = pref.isSelected;
    }
}

-(void)sendSelectedOption
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [dictParam setObject:@(cellData.ID_) forKey:@"ConsoleID"];
    [dictParam setObject:(cellData.isSelected?@"1":@"0") forKey:@"Status"];
    
    
    NSLog(@"Dict :%@",dictParam);
    [afn getDataFromPath:@"UpdateDeviceConsole" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error==nil) {
            
            NSString *strSelectedOption = [response objectForKey:@"result"] ;
            if([strSelectedOption isKindOfClass:[NSNull class]])
                return;
            if([strSelectedOption isEqualToString:@"0"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Options updated."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

@end

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_strTitle) {
        [super setNavBarTitle:_strTitle];
        [[NSUserDefaults standardUserDefaults] setObject:_strTitle forKey:@"DeviceName"];
    }else{
        _strTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceName"];
        [super setNavBarTitle:_strTitle];
    }
    [super setBackBarItem:YES];
    arrOptionData = [[NSMutableArray alloc] init];
    optionsData = [NSMutableDictionary new];
    categories = [NSMutableArray new];
    [self getOptionData];
    
    
    /*Added By DHAWAL Jan - 10 - 2016 */
    if(![AppDelegate sharedAppDelegate].arrMenuFeature){
        [AppDelegate sharedAppDelegate].arrMenuFeature = [NSMutableArray new];
    }else{
        [[AppDelegate sharedAppDelegate].arrMenuFeature removeAllObjects];
    }
    
    [Global roundBorderSet:_submitPrefernceBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuIspaid:(ModelMenu *)menuObj
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setValue:menuObj.strId forKey:@"FeatureID"];
    
    [afn getStringFromPath:kAPI_PATH_ISPREMIUMFEATURE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        
        if ([response isKindOfClass:[NSNumber class]]) {
            NSString *strVal = [NSString stringWithFormat:@"%@",response];
            //NSLog(@"Response :%@ Strid :%@ strName :%@ strPaid :%@",response,menuObj.strId,menuObj.strMenuName,menuObj.strPaid);
            if([[strVal lowercaseString] isEqualToString:@"0"])
            {
                menuObj.strPaid = @"1";
            }else{
                menuObj.strPaid = @"0";
            }
            //NSLog(@"Response :%@ Strid :%@ strName :%@ strPaid :%@",response,menuObj.strId,menuObj.strMenuName,menuObj.strPaid);
        }
    }];
}

-(void)getOptionData
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:@"GetAllConsoleOptions" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [UtilityClass removeAllArrayObj];//Added By DHAWAL 9-Aug-2016
                
                if ([response isKindOfClass:[NSArray class]]) {
                    [arrOptionData removeAllObjects];
                    [optionsData removeAllObjects];
                    [categories removeAllObjects];
                    
                    for (NSDictionary *dict in response) {
                        
                        NSString *category = dict[@"Category"];
                        
                        if (![categories containsObject:category]) {
                            [categories addObject:category];
                        }
                        if (optionsData[category] == nil) optionsData[category] = [NSMutableArray new];
                        
                        Preferences *pf = [[Preferences alloc] init];
                        [pf setData:dict];
                        [arrOptionData addObject:pf];
                        [optionsData[category] addObject:pf];
                    }
                    [self.tblPreference reloadData];
//                    [self getUserPreferenceSelected];
                }
            }
        } else {
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)getUserPreferenceSelected
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_USERPREFERENCE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error==nil) {
            NSString *strSelectedOption = [response objectForKey:@"result"] ;
            if([strSelectedOption isKindOfClass:[NSNull class]])
                return;
            
            NSString *strOrigin = [strSelectedOption substringWithRange:NSMakeRange(0, MAX((int)[strSelectedOption length], 1))];
            NSLog(@"String selected :%@",strOrigin);
            NSArray *arr = [strOrigin componentsSeparatedByString:@","];
            NSInteger c = [arrOptionData count];
            for (int i = 0 ; i < arr.count ; i++)
            {
                int ids = [[arr objectAtIndex:i] intValue];
                
                for(int j = 0 ; j < c ; j++)
                {
                    Preferences *t = arrOptionData[j];
                    if (t.ID_ == ids)
                    {
                        t.isSelected = YES;
                        
                        break;
                    }
                }
            }
            [self.tblPreference reloadData];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [optionsData[categories[section]] count];
}
    -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return categories[section];
    }
    
    - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 35.f;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Preferences *pf = optionsData[categories[indexPath.section]][indexPath.row];
    
//    Preferences *pf = [arrOptionData objectAtIndex:indexPath.row];
    [cell setCellData:pf withParent:self];
    // add >
    if ([pf.IsPaid isEqualToString:@"1"]) {
        [cell.premiumImg setHidden:NO];
    }else{
        [cell.premiumImg setHidden:YES];
    }
    
    if(pf.isSelected)
    {
        if([UtilityClass checkArraySize] == 0)
        {
            [UtilityClass arrayInit];
        }
        // UIButton *b = (UIButton *)cell.contentView.subviews.lastObject;
        
        if([UtilityClass checkArraySize]==0)
        {
            [UtilityClass arrayInit];
        }
        
        [UtilityClass setElementObj:pf];
        [UtilityClass setElementControl:cell.btnCheckMark];
    }
    return cell;
}

- (IBAction)onClickSavePreferences:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Send your preferences to HuddleFly?"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self sendSelectedOption];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion: nil];
}

-(void)sendSelectedOption
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSMutableArray *arrConsoleChoices = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[arrOptionData count]; i++) {
        Preferences *pf = [arrOptionData objectAtIndex:i];
        if (pf.isSelected)
            [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
    }
    [dictParam setObject:[arrConsoleChoices componentsJoinedByString:@","] forKey:kAPI_PARAM_CONSOLECHOICES];
    
    NSLog(@"Dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_USERCHOICES withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error==nil) {
            
            NSString *strSelectedOption = [response objectForKey:@"result"] ;
            if([strSelectedOption isKindOfClass:[NSNull class]])
                return;
            if([strSelectedOption isEqualToString:@"0"]){
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Preferences sent to device. Please wait 15-30 secs to take effect."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void) reloadPreferenceData {
    [self.tblPreference reloadData];
}

@end
