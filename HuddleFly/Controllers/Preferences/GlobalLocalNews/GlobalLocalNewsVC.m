//
//  GlobalLocalNewsVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "GlobalLocalNewsVC.h"
#import "Global.h"
@interface GlobalLocalNewsVC ()<UITextFieldDelegate>{
    NSMutableArray *arrNumber;
}

@end

@implementation GlobalLocalNewsVC

#pragma mark - Life Cycle

- (NSString *)helpPath {
    return @"10-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017
    [super onTouchHideKeyboard];
    
    self.txtKeyword.text = [[User currentUser] getNEWSKEYWORDS];
    self.txtZipCode.text = [[User currentUser] getNEWSLOCATION];
    self.txtTransit.text = [[User currentUser] getNEWSTRANSIT];
    
    NSString *splitTransitFlag = [[User currentUser] getNEWSSPLITFLAG];
    if ([splitTransitFlag isEqualToString:@"0"]){
        [self.txtTransit setHidden:true];
        [self.splitTransitLbl setHidden:true];
        [self.splitBtn setSelected:false];
    }else{
        [self.txtTransit setHidden:false];
        [self.splitTransitLbl setHidden:false];
        [self.splitBtn setSelected:true];
    }
    
    arrNumber = [[NSMutableArray alloc] init];
    [self getGetGlobalNLocalNews];
    [Global roundBorderSet:_txtKeyword];
    [Global roundBorderSet:_txtZipCode];
    [Global roundBorderSet:_updateBtn];
}

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    if (self.txtKeyword.text.length > 0) {
        [[User currentUser] setNEWSKEYWORDS:self.txtKeyword.text];
    }
    if (self.txtZipCode.text.length > 0) {
        [[User currentUser] setNEWSLOCATION:self.txtZipCode.text];
    }
    if (self.txtTransit.text.length > 0) {
        [[User currentUser] setNEWSTRANSIT:self.txtTransit.text];
    }
    [[User currentUser] setNEWSSPLITFLAG: [_splitBtn isSelected]];
    [self updateGlobalAndLocal];
}

// Added by - Praveen
- (IBAction)onClickSplit:(UIButton*)sender {
    if ([sender isSelected]){
        [sender setSelected:false];
        [self.txtTransit setHidden:true];
        [self.splitTransitLbl setHidden:true];
        [[User currentUser] setNEWSSPLITFLAG: false];
    }else{
        [sender setSelected:true];
        [self.txtTransit setHidden:false];
        [self.splitTransitLbl setHidden:false];
        [[User currentUser] setNEWSSPLITFLAG: true];
    }
}
//end

- (IBAction)splitTxtClicked:(UITextField *)sender{
        [sender becomeFirstResponder];
        [sender resignFirstResponder];
        [arrNumber removeAllObjects];
        
        NSString* pickerTitle;

        for (int i = 1 ; i <= 60; i++) {
            [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
        }
        pickerTitle = @"Transition Duration(in Seconds)";

        [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:arrNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            sender.text = [self->arrNumber objectAtIndex:selectedIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:sender];
}

- (void)getGetGlobalNLocalNews
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_GLOBALNLOCALNEWS withParamData:dictParam withBlock:^(id response, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        });
        
        if (response && error==nil) {
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strKeyword = [dict objectForKey:kAPI_PARAM_NEWSKEYWORDS];
            NSString *strZipcode = [dict objectForKey:kAPI_PARAM_NEWSLOCATION] ;
            NSString *strTransit = [dict objectForKey:kAPI_PARAM_NEWSSPLITTRANSIT];
            NSString *splitFlag = [dict objectForKey:kAPI_PARAM_NEWSSPLITFLAG];
            NSString *strNumber = [dict objectForKey:@"NewsItems"] ;
            self.txtKeyword.text = strKeyword;
            self.txtZipCode.text = strZipcode;
            self.txtTransit.text = strTransit;
            self.txtItemstNumber.text = strNumber;
            if ([splitFlag isEqualToString:@"0"]){
                [self.splitBtn setSelected:false];
                [self.txtTransit setHidden:true];
                [self.splitTransitLbl setHidden:true];
            }else{
                [self.splitBtn setSelected:true];
                [self.txtTransit setHidden:false];
                [self.splitTransitLbl setHidden:false];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)updateGlobalAndLocal
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getNEWSLOCATION] forKey:kAPI_PARAM_NEWSLOCATION];
    [dictParam setObject:[[User currentUser] getNEWSKEYWORDS] forKey:kAPI_PARAM_NEWSKEYWORDS];
    [dictParam setObject:[[User currentUser] getNEWSTRANSIT] forKey:kAPI_PARAM_NEWSSPLITTRANSIT];
    [dictParam setObject:[[User currentUser] getNEWSSPLITFLAG] forKey:kAPI_PARAM_NEWSSPLITFLAG];
    
    [dictParam setObject:self.txtItemstNumber.text forKey:@"NewsItems"];
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_GLOBALNLOCALNEWS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"News Updated successfully."];
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    
    if (textField == self.txtZipCode) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        if (self.txtZipCode.text.length == 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSArray *strArr = [textView.text componentsSeparatedByString:@","];
    if ([strArr count] > 2){
        if([text isEqualToString:@""]){
            return YES;
        }else{
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Max: 2 items"];
            return NO;
        }
    }

    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
