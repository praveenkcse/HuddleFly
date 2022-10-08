//
//  PostAWebsite.m
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "PostAWebsite2.h"
#import "Global.h"
#import "ActionSheetStringPicker.h"

@interface PostAWebsite2 ()

@end

@implementation PostAWebsite2

- (NSString *)helpPath {
    return @"101-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavBarTitle:@"Play Website(s) 2"];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

     _lblMsg.hidden = YES;
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];

    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];

    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    //NSString *apiPath = [NSString stringWithFormat:@"%@?UserID=%@&%@=%@",kAPI_PATH_GET_POSTAWEBSITE,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];

    [afn getDataFromPath:@"GetPlayWebsites2" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSDictionary class]]) {
            
                NSString* websites = [((NSDictionary*) response) objectForKey:@"PlayWebsites"];
                if([[websites stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
                    self.txtViewWebUrl.text = websites;
                
                
                NSString *PlayWebsiteFor = [((NSDictionary*) response) objectForKey:@"PlayWebsiteFor"] ;
                if(![PlayWebsiteFor isKindOfClass:[NSNull class]]) {
                    self.durationTextField.text = PlayWebsiteFor;
                }

                    
            }

        } else{
        }
    }];
    
//    NSString *strWebUrl = [[User currentUser] getWEBURL];
 //   if(strWebUrl)
 //       self.txtViewWebUrl.text = strWebUrl;
    
    [[self.txtViewWebUrl layer] setCornerRadius:5.0f];
    [[self.txtViewWebUrl layer] setMasksToBounds:YES];
    
    
    [[self.txtViewWebUrl layer] setBorderWidth: 1.0f];
    [[self.txtViewWebUrl layer] setBorderColor:[UIColor blackColor].CGColor];

    [Global roundBorderSet:_submitBtn];
    [Global roundBorderSet:self.txtViewWebUrl];
}

#pragma mark - Action

- (IBAction)onClickSubmit:(id)sender
{
   /* NSArray* urls = [self.txtViewWebUrl.text componentsSeparatedByString:@","];
    
    for (NSString* url in urls) {
    
        NSString* weburl = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![[UtilityClass sharedObject] isValidURL:weburl]){
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Enter Valid Url."];
        return;
    }
    }
    */
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    [[User currentUser] setWEBURL:self.txtViewWebUrl.text];
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[self.txtViewWebUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kAPI_PARAM_WEBURL];

    //TODO 1 to 60
    [dictParam setObject:self.durationTextField.text forKey:@"PlayWebsiteFor"];

    
    [afn getDataFromPath:@"PlayWebsites2" withParamData:dictParam withBlock:^(id response, NSError *error) {
        
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)setUrlMessage:(NSString *)msg color:(UIColor *)color
{
    _lblMsg.text = msg;
    _lblMsg.textColor = color;
    if(_lblMsg.hidden){
        _lblMsg.hidden = NO;
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length > 0){
        if([[UtilityClass sharedObject] isValidURL:textField.text]){
            [self setUrlMessage:@"Valid Url" color:[UIColor greenColor]];
        }else{
            [self setUrlMessage:@"Unvalid Url" color:[UIColor redColor]];
        }
    }
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
   if (textView.text.length + text.length > 255 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

- (IBAction)onClickTextField:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    
    NSString* pickerTitle;
    
    NSMutableArray* arrNumber = [[NSMutableArray alloc] init];
    for (int i = 1 ; i <= 60; i++) {
        [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    pickerTitle = @"Show website for:" ;
    
    [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:arrNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        sender.text = [arrNumber objectAtIndex:selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
    
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
