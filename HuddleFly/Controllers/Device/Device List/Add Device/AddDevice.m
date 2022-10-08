//
//  AddDevice.m
//  HuddleFly
//
//  Created by BMAC on 28/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "AddDevice.h"
#import "Global.h"
#import "QRCodeReaderViewController.h"

@interface AddDevice () <QRCodeReaderDelegate> {
    QRCodeReader *reader;
    QRCodeReaderViewController *vc;
}
@end

@implementation AddDevice

- (NSString *)helpPath {
    return @"0-3";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Global roundBorderSet:btnAdd];
    
    [super setHelpBarButton:3];
    
    oldRect = scrView.frame;
    oldRect.size.height -= 70;
    NSString *strTitle = @"Add Device";
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    if(_isEdited){
        [self hideEditField:NO];
        strTitle = @"Edit Device";
        [btnAdd setTitle:@"Update" forState:UIControlStateNormal];
        txtDeviceName.text = _listObj.strDeviceName;
        txtToken.text = _listObj.strToken;
        txtDeviceLocation.text = _listObj.strDeviceLocation;
        
        //txtConnection.text = _listObj.strConnType;
        if([_listObj.strConnType isEqualToString:@"wlan0"]){
            txtConnection.text = @"wifi";
        }else if ([_listObj.strConnType isEqualToString:@"eth0"]){
            txtConnection.text = @"lan";
        }else{
            txtConnection.text = _listObj.strConnType;
        }
        
        NSInteger isMaster = 0;
        if([_listObj.strIsMaster isKindOfClass:[NSString class]]){
            isMaster = [_listObj.strIsMaster integerValue];
        }else{
            isMaster = (NSInteger)_listObj.strIsMaster;
        }
        if(isMaster){
            btnIsMaster.selected = YES;
        }else{
            btnIsMaster.selected = NO;
        }
        
        NSInteger isFollowMaster = 0;
        if([_listObj.strIsFollowMaster isKindOfClass:[NSString class]]){
            isFollowMaster = [_listObj.strIsFollowMaster integerValue];
        }else{
            isFollowMaster = (NSInteger)_listObj.strIsFollowMaster;
        }
        if(isFollowMaster){
            btnIsFollowMaster.selected = YES;
        }else{
            btnIsFollowMaster.selected = NO;
        }

        self.addButtonToMasterViewContarint.constant = 215;
        self.addButtonToTimeLabelContarint.constant = 19;
        viewContainerFollowMaster.hidden = NO;
        txtDisplay.text = _listObj.strDisplayMode;
        txtIPAddress.text = _listObj.strIPAddr;
        txtTimeStamp.text = _listObj.strTimeStamp;
        txtWifiNetwork.text = _listObj.strSSID;
        scrView.contentSize = CGSizeMake(scrView.frame.size.width, (btnAdd.frame.size.height + btnAdd.frame.origin.y+15));
    }else{
        self.addButtonToMasterViewContarint.constant = 20;
        self.addButtonToTimeLabelContarint.constant = 0;
        viewContainerFollowMaster.hidden = YES;
        CGRect rect = viewContainerIsMaster.frame;
        rect.origin.y = txtDeviceLocation.frame.origin.y + txtDeviceLocation.frame.size.height + 15;
        viewContainerIsMaster.frame = rect;
        
        rect = btnAdd.frame;
        rect.origin.y = viewContainerIsMaster.frame.origin.y + viewContainerIsMaster.frame.size.height + 15;
        btnAdd.frame = rect;
        
        scrView.contentSize = CGSizeMake(scrView.frame.size.width, (btnAdd.frame.size.height + btnAdd.frame.origin.y+15));
        
        [self hideEditField:YES];
        [IsMasterL setHidden:NO];
    }
    
    [super setNavBarTitle:strTitle];
    [super setBackBarItem];
    [super onTouchHideKeyboard];
    
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

- (void)hideEditField:(BOOL)v
{
    [scrView viewWithTag:10].hidden = v;
    [scrView viewWithTag:20].hidden = v;
    [scrView viewWithTag:30].hidden = v;
    [scrView viewWithTag:40].hidden = v;
    [scrView viewWithTag:50].hidden = v;
    [scrView viewWithTag:60].hidden = v;
    [scrView viewWithTag:70].hidden = v;
    [scrView viewWithTag:80].hidden = v;
    [scrView viewWithTag:90].hidden = v;
    [scrView viewWithTag:100].hidden = v;
    [scrView viewWithTag:110].hidden = v;
    [scrView viewWithTag:120].hidden = v;
    
    if(v)
        self.addButtonContarint.constant = -200;
    else
        self.addButtonContarint.constant = 16;
}

- (IBAction)onClickIsMasterBtn:(UIButton *)sender
{
    btnIsMaster.selected = !sender.isSelected;
    if (!btnIsMaster.selected) {
        btnIsFollowMaster.selected = NO;
    }
}
- (IBAction)onClickIsFollowMasterBtn:(UIButton *)sender
{
    if (!btnIsMaster.isSelected) {
        return;
    }
    btnIsFollowMaster.selected = !sender.isSelected;
    if (btnIsFollowMaster.selected) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please note if this option is chosen, all the devices in this account will follow the user preferences of this master device."
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        

       // [[AppDelegate sharedAppDelegate] showToastMessage:@"Please note if this option is chosen, all the devices in this account will follow the user preferences of this device."];
    }
}

- (IBAction)btnAddCliked:(id)sender
{
    [self.view endEditing:YES];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    
    if (_isEdited)
    {
        [dictParam setObject:_listObj.strDeviceId forKey:kAPI_PARAM_DEVICEID];
        [dictParam setObject:txtDeviceName.text forKey:kAPI_PARAM_DEVICENAME];
        [dictParam setObject:txtToken.text forKey:kAPI_PARAM_TOKEN];
        [dictParam setObject:txtDeviceLocation.text forKey:kAPI_PARAM_DEVICELOCATION];
        if(btnIsMaster.isSelected){
            [dictParam setObject:@"true" forKey:kAPI_PARAM_ISMASTER];
        }else{
            [dictParam setObject:@"false" forKey:kAPI_PARAM_ISMASTER];
        }
        if(btnIsFollowMaster.isSelected){
            [dictParam setObject:@"true" forKey:kAPI_PARAM_ISFOLLOWMASTER];
        }else{
            [dictParam setObject:@"false" forKey:kAPI_PARAM_ISFOLLOWMASTER];
        }
        [afn getDataFromPath:kAPI_PATH_UPDATE_DEVICE withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            
            /*
            if (response) {
                NSDictionary *dict = response;
                if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
                {
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"Device updated!"];
                    [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                }
                else
                {
                    NSString* errorCode = [response objectForKey:@"result"];
                    
                    if ([errorCode isEqualToString:@"-1"])
                    {
                        [[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                        [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                    }
                }
                */
            
            if (response) {
                NSDictionary *dict = response;
                if(![[dict objectForKey:@"result"] isEqualToString:@"0"] )//&& [[dict objectForKey:@"error"] isEqualToString:@""]
                {
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"Device updated!"];
                    [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                }
                else
                {
                    NSString* errorCode = [response objectForKey:@"result"];
                    
                    if ([errorCode isEqualToString:@"0"])
                    {
                        [[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                        [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                    }
                }
                
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }];
    }
    else{
        if(txtDeviceName.text.length == 0){
            [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter device name."];
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            return;
        }
        else if (txtToken.text.length == 0)
        {
            [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter device token."];
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            return;
        }
        else if (txtDeviceLocation.text.length == 0)
        {
            [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter device location."];
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            return;
        }else if ([txtDeviceLocation.text isEqualToString:@"0000"])
        {
            [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter a valid device location."];
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            return;
        }
        
        [dictParam setObject:txtDeviceName.text forKey:kAPI_PARAM_DEVICENAME];
        [dictParam setObject:txtToken.text forKey:kAPI_PARAM_TOKEN];
        [dictParam setObject:txtDeviceLocation.text forKey:kAPI_PARAM_DEVICELOCATION];
        if(btnIsMaster.isSelected){
            [dictParam setObject:@"true" forKey:kAPI_PARAM_ISMASTER];
        }else{
            [dictParam setObject:@"false" forKey:kAPI_PARAM_ISMASTER];
        }
        NSLog(@"Dict :%@",dictParam);
        
        //"kAPI_PATH_ADD_DEVICE" Replace By "kAPI_PATH_REGISTER_DEVICE" 17-Aug-2016
        
        [afn getDataFromPath:kAPI_PATH_REGISTER_DEVICE withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            if (response) {
                NSDictionary *dict = response;
                if (![[dict objectForKey:@"result"] isEqualToString:@"0"] ) //&& [[dict objectForKey:@"error"] isEqualToString:@""]
                {
                    txtDeviceName.text = @"";
                    txtToken.text = @"";
                    txtDeviceLocation.text = @"";
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"New Device added!"];
                    [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                }
                else
                {
                    NSString* errorCode = [response objectForKey:@"result"];
                    
                    if ( ([errorCode isEqualToString:@"0"]) || ([errorCode isEqualToString:@"-1"]) )
                    {
                        [[AppDelegate sharedAppDelegate] showToastMessage:[response objectForKey:@"error"]];
                        [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                    }
                }
            
            
            
                /*
                NSDictionary *dict = response;
                if(![[dict objectForKey:@"result"] isEqualToString:@"-1"] && [[dict objectForKey:@"error"] isEqualToString:@""])
                {
                    txtDeviceName.text = @"";
                    txtToken.text = @"";
                    txtDeviceLocation.text = @"";
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"New Device added."];
                    [self performSegueWithIdentifier:kSEGUE_DEVICELIST sender:nil];
                    
                }
                else if ([[dict objectForKey:@"result"] isEqualToString:@"-1"] && [[dict objectForKey:@"error"] isEqualToString:@""])
                {
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"Invalid device token..."];
                }
                */
                
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtActive = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == txtToken) {
        if([string isEqualToString:@""])
        {
            return YES;
        }
        NSString *strText = txtToken.text;
        
        if(txtToken.text.length == 2 || txtToken.text.length == 5 || txtToken.text.length ==8 || txtToken.text.length == 11 || txtToken.text.length == 14)
        {
            strText = [strText stringByAppendingString:@":"];
            txtToken.text = strText;
        }
        
        if (txtToken.text.length == 17) {
            return NO;
        }
    }
    else if (textField == txtDeviceLocation) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        if([string isEqualToString:@""])
        {
            return YES;
        }
        if (txtDeviceLocation.text.length == 5) {
            return NO;
        }
    }
    return YES;
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
    //oldRect.size.height -= 70;//Added By DHAWAL 2-Aug-2016
    scrView.frame = oldRect;
    scrView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrView.contentSize = CGSizeMake(scrView.frame.size.width, (btnAdd.frame.size.height + btnAdd.frame.origin.y+15));//scrView.frame.size.height //Added By DHAWAL 2-Aug-2016
   // scrView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
   // scrView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //scrView.contentOffset = CGPointZero;
}

-(void)moveKeyboard:(CGFloat)keyheight
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyheight, 0.0);
        scrView.contentInset = contentInsets;
        //scrView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyheight;
        
        NSLog(@"Active Textfield :%@",txtActive);
        if (!CGRectContainsPoint(aRect, txtActive.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, -70);//txtActive.frame.origin.y-keyheight
            [scrView setContentOffset:scrollPoint animated:YES];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scanQRCode:(id)sender {
    if ([QRCodeReader isAvailable]) {
        // Create the reader object
        reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        // Instantiate the view controller
        vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
        
        // Set the presentation style
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        
        // Define the delegate receiver
        vc.delegate = self;
        
        // Or use blocks
        __block AddDevice *blockSelf = self;
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            [blockSelf dismissViewControllerAnimated:YES completion:^{
                NSLog(@"%@", resultAsString);
                
                NSURL *url = [NSURL URLWithString:resultAsString];
                if (url != nil) {
                    NSDictionary<NSString *, NSString *> *params = [blockSelf queryParametersFromURL:url];
                    NSString *token = params[@"Tkn"];
                    if(token != nil && ![token isEqualToString:@""]) {
                        blockSelf->txtToken.text = token;
                    } else {
                        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Token not found" preferredStyle:UIAlertControllerStyleAlert];
                        [vc addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [blockSelf presentViewController:vc animated:YES completion:NULL];
                    }
                } else {
                    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Token not found" preferredStyle:UIAlertControllerStyleAlert];
                    [vc addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [blockSelf presentViewController:vc animated:YES completion:NULL];
                }
            }];
            
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Your device don't support QR code scanner" preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

- (NSDictionary<NSString *, NSString *> *)queryParametersFromURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary<NSString *, NSString *> *queryParams = [NSMutableDictionary<NSString *, NSString *> new];
    for (NSURLQueryItem *queryItem in [urlComponents queryItems]) {
        if (queryItem.value == nil) {
            continue;
        }
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    return queryParams;
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
