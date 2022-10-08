//
//  StockCurrencyVC.m
//  HuddleFly
//
//  Created by BMAC on 01/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "StockCurrencyVC.h"
#import "Global.h"
#import "LocalEvents.h"

@interface StockCurrencyVC () <UITextFieldDelegate>{
    NSMutableArray *arrNumber;
}
@end

@implementation StockCurrencyVC

- (NSString *)helpPath {
    return @"11-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    self.txtCurrency.text = [[User currentUser] getCURRENCYSYMBOLS];
    self.txtStock.text = [[User currentUser] getSTOCKSYMBOLS];
    
    NSString *splitTransitFlag = [[User currentUser] getSTOCKSPLITFLAG];
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
    [self getTransitions];
    [self getStockNCurrency];
    [Global roundBorderSet:_updateBtn];
    [Global roundBorderSet:_txtStock];
    [Global roundBorderSet:_txtCurrency];
}

-(void)getStockNCurrency
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kAPI_PATH_GET_STOCKNCURRENCY withParamData:dictParam withBlock:^(id response, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        });
        
        if (response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSString *strCurrency = [dict objectForKey:kAPI_PARAM_CURRENCYSYMBOLS];
            NSString *strSymbol = [dict objectForKey:kAPI_PARAM_STOCKSYMBOLS];
            NSString *strTransit = [dict objectForKey:kAPI_PARAM_STOCKSPLITTRANSIT];
            NSString *splitFlag = [dict objectForKey:kAPI_PARAM_STOCKSPLITFLAG];
            self.txtCurrency.text = strCurrency;
            self.txtStock.text = strSymbol;
            self.txtTransit.text = strTransit;
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
    }];

}

- (IBAction)onClickSubmit:(id)sender
{
    [[User currentUser] setSTOCKSYMBOLS:self.txtStock.text];
    [[User currentUser] setCURRENCYSYMBOLS:self.txtCurrency.text];
    if (self.txtTransit.text.length > 0) {
        [[User currentUser] setSTOCkTRANSIT:self.txtTransit.text];
    }
    [[User currentUser] setSTOCKSPLITFLAG: [_splitBtn isSelected]];
    [self updateStockAndCurrency];
}

- (IBAction)onClickSplit:(UIButton*)sender{
    if ([sender isSelected]){
        [sender setSelected:false];
        [self.txtTransit setHidden:true];
        [self.splitTransitLbl setHidden:true];
        [[User currentUser] setSTOCKSPLITFLAG: false];
    }else{
        [sender setSelected:true];
        [self.txtTransit setHidden:false];
        [self.splitTransitLbl setHidden:false];
        [[User currentUser] setSTOCKSPLITFLAG: true];
    }
}




- (void) getTransitions
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:@"GetTransitionList" withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrNumber removeAllObjects];
                for (NSDictionary *dict in response) {
                    Transition *d = [[Transition alloc] init];
                    [d setData:dict];
                    [arrNumber addObject:d];
                }
                
            }
        }
    }];
}



- (IBAction)splitTxtClicked:(UITextField *)sender {
    
        [sender becomeFirstResponder];
        [sender resignFirstResponder];
        [arrNumber removeAllObjects];
        
        NSString* pickerTitle;

    //    arrNumber = [NSMutableArray arrayWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", nil];
//        for (int i = 1 ; i <= 60; i++) {
//            [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
//        }
        pickerTitle = @"Transition Duration(in Seconds)";

        
        NSMutableArray *transitions = [[NSMutableArray alloc] init];
          for (int i = 0 ; i < arrNumber.count; i++) {
              Transition * obj = [arrNumber objectAtIndex:i];
              [transitions addObject: obj.value];
          }
          [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:transitions initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
              
              sender.text = transitions[selectedIndex];
          } cancelBlock:^(ActionSheetStringPicker *picker) {
              
          } origin:sender];
          
        
    
}

-(void)updateStockAndCurrency
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getSTOCKSYMBOLS] forKey:kAPI_PARAM_STOCKSYMBOLS];
    [dictParam setObject:[[User currentUser] getCURRENCYSYMBOLS] forKey:kAPI_PARAM_CURRENCYSYMBOLS];
    [dictParam setObject:[[User currentUser] getSTOCKTRANSIT] forKey:kAPI_PARAM_STOCKSPLITTRANSIT];
    [dictParam setObject:[[User currentUser] getSTOCKSPLITFLAG] forKey:kAPI_PARAM_STOCKSPLITFLAG];
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_STOCKSNCURRENCY withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Stock and Currency Updated successfully."];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@""]){
        return YES;
    }
    NSArray *strArr = [textView.text componentsSeparatedByString:@","];
   
    if (textView == _txtStock){
        if ([strArr count] > 20){
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Max: 20 items"];
            return NO;
            
        }
    }else if (textView == _txtCurrency){
        if ([strArr count] > 10){
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Max: 10 items"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
