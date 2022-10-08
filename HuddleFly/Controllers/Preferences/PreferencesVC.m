//
//  PreferencesVC.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "PreferencesVC.h"
#import "Preferences.h"
#import "ModelMenu.h"
#import "Global.h"
@interface PreferencesVC (){
    NSString *selectedPreferenceName;
}

@end

@implementation PreferencesVC

#pragma mark - Life Cycle


- (NSString *)helpPath {
    return @"0-11";
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
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
//    [self getOptionData];
    
    [super setHelpBarButton:11];//ADDED BY Kumar 19-JUL-2017

    
    /*Added By DHAWAL Jan - 10 - 2016 */
    if(![AppDelegate sharedAppDelegate].arrMenuFeature){
        [AppDelegate sharedAppDelegate].arrMenuFeature = [NSMutableArray new];
    }else{
        [[AppDelegate sharedAppDelegate].arrMenuFeature removeAllObjects];
    }
    
    if([AppDelegate sharedAppDelegate].arrMenuFeature){
        NSArray *arrMenu = @[@"Play YouTube",@"Play PowerPoint",@"Play USB",@"Play OffLine Mode",@"Motion Sensor",@"Add Device"];
        for (int i = 0; i < arrMenu.count; i++) {
            ModelMenu *menu = [[ModelMenu alloc] init];
            menu.strId = [NSString stringWithFormat:@"%d",(101+i)];
            if (i == 0 || i == 2) {
                menu.strPaid = @"0";
            }else{
                menu.strPaid = @"1";
            }
            menu.strMenuName = arrMenu[i];
            
            [[AppDelegate sharedAppDelegate].arrMenuFeature addObject:menu];
        }
        
        for (int i = 0; i < [AppDelegate sharedAppDelegate].arrMenuFeature.count; i++) {
            [self menuIspaid:[AppDelegate sharedAppDelegate].arrMenuFeature[i]];
        }
    }
    [Global roundBorderSet:_submitPrefernceBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getOptionData];
}

#pragma mark - Menu 

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

#pragma mark - Get Option Data From Api.

-(void)getOptionData
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_CONSOLE_OPTION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
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
                    pf.isSelected = NO;
                    
                    [self->arrOptionData addObject:pf];
                    [self->optionsData[category] addObject:pf];
                }
                [self.tblPreference reloadData];
                [self getUserPreferenceSelected];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

/*Response Of GetUserPreference Api 5th Aug 2016
 {
 error = "";
 result = "0,1||10";
 }
 */
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
            NSArray *firstRun = [strOrigin componentsSeparatedByString:@"||"];
            UtilityClass.sharedObject.defaultTransition = @"60";//firstRun[1];
            NSArray *arr = [firstRun[0] componentsSeparatedByString:@";"];
            
            NSMutableDictionary *transitions = [NSMutableDictionary new];//[UtilityClass sharedObject].transitions;//
            
            for(NSString *item in arr) {
                NSArray *values = [item componentsSeparatedByString:@","];
                int idx = [values[0] intValue];
                if (transitions[@(idx)] == nil) {
                    transitions[@(idx)] = values[1];
                }
                
                for(Preferences *t in self->arrOptionData) {
                    if (t.ID_ == idx) {
                        t.isSelected = YES;
                    }
                }
            }
            
            [UtilityClass sharedObject].transitions = transitions;
            
//            NSInteger c = [arrOptionData count];
//            for (int i = 0 ; i < arr.count ; i++)
//            {
//                int ids = [[arr objectAtIndex:i] intValue];
//
//                for(int j = 0 ; j < c ; j++)
//                {
//                    Preferences *t = arrOptionData[j];
//                    if (t.ID_ == ids)
//                    {
//                        // add >
////                        if ([t.IsPaid isEqualToString:@"1"]) {
//                        // < add
//                            t.isSelected = YES;
////                        }
//
//                        break;
//                    }
//                }
//            }
            [self.tblPreference reloadData];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - UITableview Datasorce

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return arrOptionData.count;
//}
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferencesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreferenceCell"];
    if(cell == nil)
    {
        cell = [[PreferencesCell alloc] init];
    }
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
//    if([cell.lblTitle.text containsString:@"Play"]||
//       [cell.lblTitle.text containsString:@"Upload"]||
//       [cell.lblTitle.text containsString:@"Offline"]){
//        [cell.btnCheckMark setHidden:YES];
//    }else{
//        [cell.btnCheckMark setHidden:NO];
//    }
 // < add
 
    return cell;
}

#pragma mark - UITableview Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Preferences *pf = optionsData[categories[indexPath.section]][indexPath.row];
    selectedPreferenceName = pf.Name;
//    Preferences *pf = [arrOptionData objectAtIndex:indexPath.row];
    
//     add >
//    
//    if(![[[User getUserDataWithParam:USER_PROFILE_HASPAID] lowercaseString] isEqualToString:@"1"]){
//        if ([pf.IsPaid isEqualToString:@"1"]) {
//            [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
//            return;
//        }
//    }  
    
    
//     < add
    
//     add unactive >
    
    if (pf.ID_ == 2){
        [[UtilityClass sharedObject] showAlertWithTitle:@"HuddleFly" andMessage:@"Google Task account needs to be selected within Google Calendar(s) option."];
        return;
    }
    
//    if ([pf.IsPaid isEqualToString:@"1"]) {
//        [[UtilityClass sharedObject] showAlertWithTitle:@"HuddleFly" andMessage:@"Google Task account needs to be selected within Google Calendar(s) option."];
//        if([[User getUserDataWithParam:USER_PROFILE_HASPAID] isEqualToString:@"0"]){
//            [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
//            [[AppDelegate sharedAppDelegate] showToastMessage:@"Google Task account needs to be selected within Google Calendar(s) option."];
//            [[UtilityClass sharedObject] showAlertWithTitle:@"HuddleFly" andMessage:@"Google Task account needs to be selected within Google Calendar(s) option."];
//            return;
//        }
//    }
    
//     < add unactive
    [[User currentUser] setConsoleOption:(pf.ID_ * 10)+1];//Added By DHAWAL 29-Jun-2017
    switch (pf.ID_) {
        case 1:
            [self performSegueWithIdentifier:kSEGUE_GOOGLECALENDAR sender:self];
            break;
        case 2:
            break;
        case 3:
            [self performSegueWithIdentifier:kSEGUE_FACEBOOKALBUM sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:kSEGUE_WEATHERFORECAST sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:kSEGUE_POSTMESSAGE sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"segueToPostAUrl" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:kSEGUE_SHOWWORLDTIME sender:self];
            break;
        case 8:
            [self performSegueWithIdentifier:kSEGUE_LOCALEVENTS sender:self];
            break;
//        case 9:
//        [self performSegueWithIdentifier:kSEGUE_POSTAWEBSITE sender:self];
//        break;
        case 101:
            [self performSegueWithIdentifier:@"segueToPostAWebsite2" sender:self];
            break;
        case 10:
            [self performSegueWithIdentifier:kSEGUE_GLOBALLOCALNEWS sender:self];
            break;
        case 11:
            [self performSegueWithIdentifier:kSEGUE_STOCKCURRENCY sender:self];
            break;
        case 100:
            [self performSegueWithIdentifier:kSEGUE_PLAYYOUTUBE sender:self];
            break;
//        case 101:
//            [self performSegueWithIdentifier:kSEGUE_PLAYUSB sender:self];
//            break;
        case 102:
            [self performSegueWithIdentifier:kSEGUE_PLAYUSB sender:self];

       //     [self showPlayMediaModeAlert];
//            [self performSegueWithIdentifier:kSEGUE_PLAYUSB sender:self];
            break;
        case 103:
            [self performSegueWithIdentifier:@"segueToPlayOffline" sender:self];
//            [self showPlayMediaModeAlert];
//            [self performSegueWithIdentifier:kSEGUE_TAKESELFIE sender:self];
            break;
        case 600:
            [self performSegueWithIdentifier:@"segueToDevicePreferences" sender:self];
            break;
        default:
            break;
    }
    /*
    NSString *strOptionName = [[arrOptionData objectAtIndex:indexPath.row] valueForKey:@"Name"];

    if([strOptionName isEqualToString:@"Google Calendar"] )
    {
     
    }
     */
}
-(void)showPlayMediaModeAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Currently this feature can only be configured on our web application. Using the same email account, please login to huddlefly.co and click Login/Register button."
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   
//                               }];
    
    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - Actions


- (IBAction)onClickSchedule:(id)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Schedule"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Device Schedule"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
        [self performSegueWithIdentifier:kSEGUE_DEVICESCHEDULE sender:self];
                                }];

    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Display Schedule"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
        UIAlertController * alert2 = [UIAlertController
        alertControllerWithTitle:@"Display Schedule"
        message:@"Display Schedule can currently be configured on the Web app.\nLogin via huddlefly.co"
        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesBtn = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert2 addAction:yesBtn];
        [self presentViewController:alert2 animated:YES completion:nil];
        
                               }];

    //Add your buttons to alert controller

    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)onClickSavePreferences:(id)sender {
    BOOL isOptionSelected = false;
    for (int i=0; i<[arrOptionData count]; i++) {
        Preferences *pf = [arrOptionData objectAtIndex:i];
        if (pf.isSelected){
            isOptionSelected = true;
        }
    }
    
    if (!isOptionSelected){
        UtilityClass *utility = [[UtilityClass alloc] init];
        [utility showAlertWithTitle:@"HuddleFly" andMessage:@"\nCannot submit preferences without making a choice."];
    }else{
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
    /* NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if([[User currentUser] userID])
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    
    [dictParam setObject:@"0" forKey:kAPI_PARAM_REMINSERFLAG];
    [dictParam setObject:[[User currentUser] getISDIGITAL] forKey:kAPI_PARAM_ISDIGITAL];
    [dictParam setObject:[[User currentUser] getEVENTCATEGORY] forKey:kAPI_PARAM_EVENTCATEGORY];
    [dictParam setObject:[[User currentUser] getEVENTKEYWORD] forKey:kAPI_PARAM_EVENTKEYWORD];
    [dictParam setObject:[[User currentUser] getSEARCHWITHIN] forKey:kAPI_PARAM_SEARCHWITHIN];
    [dictParam setObject:[[User currentUser] getEVENTTIMECHOICE] forKey:kAPI_PARAM_EVENTTIMECHOICE];
    [dictParam setObject:[[User currentUser] getEVENTLOCATION] forKey:kAPI_PARAM_EVENTLOCATION];
    [dictParam setObject:[[User currentUser] getEVENTSEARCHON] forKey:kAPI_PARAM_EVENTSEARCHON];
    
    NSMutableArray *arrConsoleChoices = [[NSMutableArray alloc] init];

    for (int i=0; i<[arrOptionData count]; i++) {
        Preferences *pf = [arrOptionData objectAtIndex:i];
        //pf.isSelected = YES;
        switch (pf.ID_) {
            case 1:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    
                    [dictParam setObject:[[User currentUser] getCALENDARID] forKey:kAPI_PARAM_CALENDARID];
                    [dictParam setObject:[[User currentUser] getCALENDARVIEW] forKey:kAPI_PARAM_CALENDARVIEW];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_CALENDARID];
                    [dictParam setObject:@"" forKey:kAPI_PARAM_CALENDARVIEW];
                }
                break;
            case 2:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                }
                break;
            case 3:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    [dictParam setObject:[[User currentUser] getFBALBUMID] forKey:kAPI_PARAM_FBALBUMID];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_FBALBUMID];
                }
                break;
            case 4:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    [dictParam setObject:[[User currentUser] getWEATHERLOCATION] forKey:kAPI_PARAM_WEATHERLOCATION];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_WEATHERLOCATION];
                }
                break;
            case 5:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    [dictParam setObject:[[User currentUser] getPOSTAMESSAGE] forKey:kAPI_PARAM_POSTAMESSAGE];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_POSTAMESSAGE];
                }
                break;
            case 6:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    [dictParam setObject:[[User currentUser] getYOUTUBEURL] forKey:kAPI_PARAM_YOUTUBEURL];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_YOUTUBEURL];
                }
                break;
            case 7:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    //[dictParam setObject:[[User currentUser] getISDIGITAL] forKey:kAPI_PARAM_ISDIGITAL];
                    [dictParam setObject:[[User currentUser] getWTZIPCODEIDS] forKey:kAPI_PARAM_WTZIPCODEIDS];
                }
                else{
                    //[dictParam setObject:@"" forKey:kAPI_PARAM_ISDIGITAL];
                    [dictParam setObject:@"" forKey:kAPI_PARAM_WTZIPCODEIDS];
                }
                break;
            case 8:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                }
                break;
            case 9:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                }
                break;
            case 10:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    [dictParam setObject:[[User currentUser] getNEWSLOCATION] forKey:kAPI_PARAM_NEWSLOCATION];
                    [dictParam setObject:[[User currentUser] getNEWSKEYWORDS] forKey:kAPI_PARAM_NEWSKEYWORDS];
                }
                else{
                    [dictParam setObject:@"" forKey:kAPI_PARAM_NEWSLOCATION];
                    [dictParam setObject:@"" forKey:kAPI_PARAM_NEWSKEYWORDS];
                }
                break;
            case 11:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                }
                break;
            default:
                break;
        }
    }
    [dictParam setObject:[arrConsoleChoices componentsJoinedByString:@","] forKey:kAPI_PARAM_CONSOLECHOICES];
    
    //NSLog(@"Dict :%@",dictParam);
    NSLog(@"array :%@",arrConsoleChoices);
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSLog(@"strapi :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_SAVEUSERPREFERENCE withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Preferences sent!"];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];*/
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
        NSString *transition = UtilityClass.sharedObject.transitions[@(pf.ID_)];
        if (transition == nil) transition = UtilityClass.sharedObject.defaultTransition;// @"60";
        if (pf.isSelected)
            [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d,%@",pf.ID_,transition]];
        /*switch (pf.ID_) {
            case 1:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 2:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 3:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 4:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                    
                break;
            case 5:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
            break;
            case 6:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 7:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 8:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 9:
                if (pf.isSelected) {
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                }
                break;
            case 10:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 11:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 12:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 14://Added By DHAWAL 2-Aug-2016
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            case 15:
                if (pf.isSelected)
                    [arrConsoleChoices addObject:[NSString stringWithFormat:@"%d",pf.ID_]];
                break;
            default:
                break;
        }*/
    }
    [dictParam setObject:[arrConsoleChoices componentsJoinedByString:@";"] forKey:kAPI_PARAM_CONSOLECHOICES];
    
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

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseVC *vc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:kSEGUE_GOOGLECALENDAR]) {vc.pid = 1; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_FACEBOOKALBUM]) {vc.pid = 3; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_WEATHERFORECAST]){ vc.pid = 4; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_POSTMESSAGE]) {vc.pid = 5; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:@"segueToPostAUrl"]) {vc.pid = 6; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_SHOWWORLDTIME]) {vc.pid = 7; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_LOCALEVENTS]) {vc.pid = 8; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_POSTAWEBSITE]) {vc.pid = 9; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:@"segueToPostAWebsite2"]) {vc.pid = 101; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_GLOBALLOCALNEWS]) {vc.pid = 10; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_STOCKCURRENCY]) {vc.pid = 11; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_PLAYYOUTUBE]) {vc.pid = 100; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_PLAYUSB]) {vc.pid = 102; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:@"segueToPlayOffline"]) {vc.pid = 103; vc.heading = selectedPreferenceName;}
    else if ([segue.identifier isEqualToString:kSEGUE_DEVICE_PREFERENCES]) {}
}

-(void) reloadPreferenceData {
    [self.tblPreference reloadData];
}

@end
