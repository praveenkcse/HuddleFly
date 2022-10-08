//
//  LiveStreamingVC.m
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "LiveStreamingVC.h"
#import "Global.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface LiveStreamingVC ()

@end

@implementation LiveStreamingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldRect = scrView.frame;
    txtYoutubeUrl.layer.borderWidth = 1.0;
    txtYoutubeUrl.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewEditing)];
    tap.numberOfTapsRequired = 1;
    [txtYoutubeUrl addGestureRecognizer:tap];
    
    [super setNavBarTitle:@"Live Streaming"];
    [self getStreamingData];
    [super onTouchHideKeyboard];
    
    [Global roundBorderSet:_startBtn];
    [Global roundBorderSet:_stopBtn];
    [Global roundBorderSet:txtStreamUrl];
    [Global roundBorderSet:txtStreamKey];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:animated];
}

-(void)textViewEditing
{
    txtYoutubeUrl.editable = !txtYoutubeUrl.isEditable;
    [txtYoutubeUrl becomeFirstResponder];
}

#pragma mark - Keyboard.

-(void)keyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"Key size :%@",NSStringFromCGRect(keyboardFrameBeginRect));
    [self moveKeyboard:keyboardFrameBeginRect.size.height];
}

-(void)keyboardHide:(NSNotification *)notification
{
    scrView.frame = oldRect;
    scrView.contentSize = CGSizeMake(scrView.frame.size.width, scrView.frame.size.height);
    scrView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)moveKeyboard:(CGFloat)keyheight
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyheight, 0.0);
        scrView.contentInset = contentInsets;
        scrView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyheight;
        if (!CGRectContainsPoint(aRect, txtActive.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, -70);//txtActive.frame.origin.y-keyheight
            [scrView setContentOffset:scrollPoint animated:YES];
        }
    }];
    
}


#pragma mark - ApiCalls
#pragma mark - Get Streaming Data

- (void)getStreamingData
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_LIVESTREAMING withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:KAPI_PARAM_STREAMURL]])
            {
                txtStreamUrl.text = [dict objectForKey:KAPI_PARAM_STREAMURL];
            }
            if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:kAPI_PARAM_STREAMKEY_GET]])
            {
                txtStreamKey.text = [dict objectForKey:kAPI_PARAM_STREAMKEY_GET];
            }
            if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:kAPI_PARAM_STREAMYOUTUBEURL]])
            {
                txtYoutubeUrl.text = [dict objectForKey:kAPI_PARAM_STREAMYOUTUBEURL];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)updateStreaming
{
    if(txtStreamUrl.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter url"];
        return;
    }
    else if (![[UtilityClass sharedObject] isValidURL:txtStreamUrl.text])
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid url"];
        return;
    }
    else if (txtStreamKey.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter key"];
        return;
    }
    else if (txtYoutubeUrl.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter youtube url"];
        return;
    }
    else if (![[UtilityClass sharedObject] isValidURL:txtYoutubeUrl.text])
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid youtube url"];
        return;
    }
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:txtStreamUrl.text forKey:kAPI_PARAM_RTMPURL];
    [dictParam setObject:txtStreamKey.text forKey:kAPI_PARAM_STREAMKEY];
    [dictParam setObject:txtYoutubeUrl.text forKey:kAPI_PARAM_STREAMYOUTUBEURL];
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_UPDATE_LIVESTREAMING withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if([UtilityClass checkResponseSuccessOrNot:response])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Streaming updated!"];
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Streaming not updated!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)stopStreaming
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_STOP_LIVESTREAMING withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if([UtilityClass checkResponseSuccessOrNot:response])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Streaming stopped!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - Textfield Delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtActive = textField.frame;
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"Tap");
    txtActive = textView.frame;
    if([text isEqualToString:@"\n"]) {
        textView.editable = NO;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"Url :%@",URL);
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
