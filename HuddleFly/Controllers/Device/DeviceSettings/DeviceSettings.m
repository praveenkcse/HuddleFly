//
//  DeviceSettings.m
//  HuddleFly
//
//  Created by BMAC on 29/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "DeviceSettings.h"
#import "LocalEvents.h"
#import "Global.h"
@interface DeviceSettings () {
    int rotation;
    int transition;
}

@end

@implementation DeviceSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Display Settings"];    
    [super setBackBarItem:YES];
    
    [self onTouchHideKeyboard];
    
    [Global roundBorderSet:_updateBtn];
    [Global roundBorderSet:_txtZoom];
    [Global roundBorderSet:_txtColor];
    [Global roundBorderSet:_txtRefresh];
    [Global roundBorderSet:_txtTransition];
    
    [super setHelpBarButton:4];//ADDED BY DHAWAL 29-JUN-2017
    
    rotation = 0;
    transition = 0;
    
    arrNumber = [[NSMutableArray alloc] init];
    arrColors = [[NSMutableArray alloc] init];
    arrZooms = [[NSMutableArray alloc] init];
    arrRotations = [[NSMutableArray alloc] init];
    
    if ([[User currentUser] getSETTINGSTRANSITION] != nil) {
        if ([[User currentUser] getSETTINGSTRANSITION].length > 0) {
            self.txtTransition.text = [[User currentUser] getSETTINGSTRANSITION];
        }
    }
    if([[User currentUser] getCOLOR] != nil){
        if([[User currentUser] getCOLOR].length > 0){
            self.txtColor.text = [[User currentUser] getCOLOR];
        }
    }
    
    if([[User currentUser] getZOOM] != nil){
        if([[User currentUser] getZOOM].length > 0){
            self.txtZoom.text = [[User currentUser] getZOOM];
        }
    }

    if ([[User currentUser] getSETTINGSREFRESH] != nil) {
        if ([[User currentUser] getSETTINGSREFRESH].length > 0) {
            self.txtRefresh.text = [[User currentUser] getSETTINGSREFRESH];
        }
    }
    if ([[User currentUser] getAUDIOHDMI] != nil) {
        if ([[User currentUser] getAUDIOHDMI].length > 0) {
            int flag = [[User currentUser] getAUDIOHDMI].intValue;
            if(flag)
            {
                self.btnHDMI.selected = YES;
                self.btnJack.selected = NO;
            }
            else
            {
                self.btnJack.selected = YES;
                self.btnHDMI.selected = NO;
            }
        }
    }
    frame = self.viewRotatePanel.frame;
    if ([[User currentUser] getDEVICEVIEW] != nil) {
        if ([[User currentUser] getDEVICEVIEW].length > 0) {
            NSString *strDevice = [[User currentUser] getDEVICEVIEW];
            if([strDevice isEqualToString:@"1"])
            {
                self.btnSinglePage.selected = YES;
                self.btnRotatePage.selected = NO;
            }
            else{
                self.btnSinglePage.selected = NO;
                self.btnRotatePage.selected = YES;
            }
            [self changeViewPosition];
        }
    }
    
    
//    if ([[User currentUser] getPIXTRANSITION] != nil) {
//        if ([[User currentUser] getPIXTRANSITION].length > 0) {
//            self.pixTransitionTextField.text = [[User currentUser] getPIXTRANSITION];
//        }
//    }
//    
//    if ([[User currentUser] getLoopVideo] != nil) {
//        if ([[User currentUser] getLoopVideo].length > 0) {
//            int value = [[User currentUser] getLoopVideo].intValue;
//            if(value == 1)
//            {
//                self.btnLoopVideo.selected = YES;
//                self.btnDontLoopVideo.selected = NO;
//            } else {
//                self.btnLoopVideo.selected = NO;
//                self.btnDontLoopVideo.selected = YES;
//            }
//        }
//    }
//
//    
//    if ([[User currentUser] getMediaToPlay] != nil) {
//        if ([[User currentUser] getMediaToPlay].length > 0) {
//            int value = [[User currentUser] getMediaToPlay].intValue;
//            
//            self.btnPicture.selected = NO;
//            self.btnVideo.selected = NO;
//            self.btnPowerPoint.selected = NO;
//
//            if(value == 1)
//                self.btnPicture.selected = YES;
//            else if (value == 2)
//                self.btnVideo.selected = YES;
//            else
//                self.btnPowerPoint.selected = YES;
//        }
//    }
//    [self getTransition];
    [self getSettings];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self animateTextField2:_txtWPUrl up:NO value:(keyboardSize.height-64)];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self animateTextField2:_txtWPUrl up:YES value:(keyboardSize.height-64)];
}

- (void) animateTextField2: (UITextView*) textField up: (BOOL) up value:(int)val
{
    //    const int movementDistance = val; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    //    int movement = (up ? -movementDistance : movementDistance);
    
    CGRect frame = self.view.frame;
    
    if (up) {
        frame.origin.y = -val;
    } else {
        frame.origin.y = 64;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    //    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

- (void)changeViewPosition
{
//    self.viewSinglePanel.hidden = self.btnSinglePage.isSelected;
//    self.viewRotatePanel.hidden = self.btnSinglePage.isSelected;
    
    if(self.btnSinglePage.isSelected)
    {
//        self.viewRotatePanel.frame = self.viewSinglePanel.frame;
//        self.viewRotatePanel.hidden = !self.btnSinglePage.isSelected;

//        self.lblRotation.hidden = YES;
//        self.txtRotation.hidden = YES;
        [[User currentUser] setDEVICEVIEW:@"1"];
//        self.space.constant = 10;
//        self.topSpace.constant = -70;
//        [UIView animateWithDuration:0.5 animations:^{
//            self.viewRotatePanel.transform = CGAffineTransformMakeTranslation(0, -70);
//        }];
    }
    else
    {
        self.lblRotation.hidden = NO;
        self.txtRotation.hidden = NO;
//        self.viewRotatePanel.frame = frame;
        [[User currentUser] setDEVICEVIEW:@"2"];
//        self.space.constant = 70;
//        self.topSpace.constant = 0;
//        [UIView animateWithDuration:0.5 animations:^{
//            self.viewRotatePanel.transform = CGAffineTransformIdentity;
//        }];
    }

//    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
//    }];
    
}

- (IBAction)onClickTextField:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
//    [arrNumber removeAllObjects];
    
//    NSString* pickerTitle;
    
//    if (sender == self.txtRotation) {
//
//        arrNumber = [NSMutableArray arrayWithObjects:@"0", @"90", @"180", @"270", nil];
//
//        pickerTitle = @"Display rotaion";
//
//    } else {
//        for (int i = sender == self.txtTransition ?1:5 ; i < 59; i++) {
//            [arrNumber addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//        pickerTitle = sender == self.txtTransition ?@"Transitions":@"Refresh" ;
    
//    }

//    [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:arrNumber initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//        sender.text = [arrNumber objectAtIndex:selectedIndex];
//    } cancelBlock:^(ActionSheetStringPicker *picker) {
//
//    } origin:sender];
    
    
    if (sender == self.txtTransition) {
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < arrNumber.count; i++) {
            Transition *z = arrNumber[i];
            [arr addObject:z.name];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"Rotation" rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            Transition *z = [self->arrNumber objectAtIndex:selectedIndex];
            self.txtTransition.text = z.name;
            self.txtTransition.accessibilityValue = z.value;
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:sender];
    } else {
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < arrNumber.count; i++) {
            Transition *z = arrNumber[i];
            [arr addObject:z.name];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"Refresh" rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            Transition *z = [self->arrNumber objectAtIndex:selectedIndex];
            sender.text = [z value];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:sender];
    }
    
}

- (IBAction)onclickHdmi:(id)sender
{
    self.btnHDMI.selected = YES;
    self.btnJack.selected = NO;
    [[User currentUser] setAUDIOHDMI:@"1"];
    //[[User currentUser] setAUDIOJACK:@"0"];
}

-(IBAction)onClickJack:(id)sender
{
    self.btnHDMI.selected = NO;
    self.btnJack.selected = YES;
    //[[User currentUser] setAUDIOJACK:@"1"];
    [[User currentUser] setAUDIOHDMI:@"0"];
}

- (IBAction)onClickSubmit:(id)sender
{
    if (self.txtTransition.text.length == 0 ) {
        self.txtTransition.text = @"30";
    }
    if (self.txtRefresh.text.length == 0 ) {
        self.txtRefresh.text = @"5";
    }
    [self updateDeviceSettings];
}

- (void)updateDeviceSettings
{
    if (![self.txtWPUrl.text isEqualToString:@""] && ![self.txtWPUrl.text.lowercaseString containsString:@".jpg"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Url must be to JPG image" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [[User currentUser] setCOLOR:self.txtColor.text];
    [[User currentUser] setZOOM:self.txtZoom.text];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:[[User currentUser] getDEVICEVIEW] forKey:kAPI_PARAM_DEVICEVIEW];
    [dictParam setObject:self.txtColor.text forKey:kAPI_PARAM_DISPLAYCOLOR];
    [dictParam setObject:self.txtRotation.accessibilityValue forKey:kAPI_PARAM_DISPLAYROTATION];
    if(self.txtZoom.accessibilityValue){
        [dictParam setObject:self.txtZoom.accessibilityValue forKey:kAPI_PARAM_DEVICEZOOM];
    }else{
        CGFloat perZoom =  [[self.txtZoom.text stringByReplacingOccurrencesOfString:@"%" withString:@""] integerValue];
        [dictParam setObject:[NSString stringWithFormat:@"%f",(perZoom*100)] forKey:kAPI_PARAM_DEVICEZOOM];
    }
    
    if(self.btnHDMI.isSelected)
    {
        [dictParam setObject:@"hdmi" forKey:kAPI_PARAM_AUDIOMODE];
    }
    else if(self.btnJack.isSelected){
        [dictParam setObject:@"ajack" forKey:kAPI_PARAM_AUDIOMODE];
    }
    else{
        [dictParam setObject:@"" forKey:kAPI_PARAM_AUDIOMODE];
    }
//    if(!self.btnSinglePage.isSelected)
//    {
    
    float time = self.txtTransition.accessibilityValue.floatValue;
//    time /= 60;
//    NSString *timeSTR = [NSString stringWithFormat:@"%f", time];
//    NSString * escapedQuery = [timeSTR stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        [dictParam setObject:self.txtRefresh.text forKey:kAPI_PARAM_RELOADEVERY];
        [dictParam setObject:@(time) forKey:kAPI_PARAM_ROTATEEVERY];
    
    dictParam[@"WallPaperURL"] = self.txtWPUrl.text;
//    }
//    else{
//        [dictParam setObject:@"5" forKey:kAPI_PARAM_RELOADEVERY];
//        [dictParam setObject:@"10" forKey:kAPI_PARAM_ROTATEEVERY];
//    }
    
//    [dictParam setObject:self.pixTransitionTextField.text forKey:kAPI_PIX_TRANSITION];
//
//    if (self.btnLoopVideo.isSelected)
//        [dictParam setObject:@"1" forKey:kAPI_PARAM_VIDEOLOOP];
//    else
//        [dictParam setObject:@"0" forKey:kAPI_PARAM_VIDEOLOOP];
//
//    if (self.btnPicture.isSelected)
//        [dictParam setObject:@"1" forKey:kAPI_PARAM_MEDIATOPLAY];
//    else if (self.btnVideo.isSelected)
//        [dictParam setObject:@"2" forKey:kAPI_PARAM_MEDIATOPLAY];
//    else //powerpoint is selected
//        [dictParam setObject:@"3" forKey:kAPI_PARAM_MEDIATOPLAY];

    
    NSLog(@"Dict Param :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_UPDATE_SETTINGS withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Settings saved successfully."];
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
                

//                [[User currentUser] setPIXTRANSITION:self.pixTransitionTextField.text];
                [[User currentUser] setLoopVideo:[dictParam objectForKey:kAPI_PARAM_VIDEOLOOP ]];
                [[User currentUser] setMediaToPlay:[dictParam objectForKey:kAPI_PARAM_MEDIATOPLAY ]];
                
                UtilityClass.sharedObject.transitions.removeAllObjects;
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getSettings
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?%@=%@&%@=%@",kAPI_PATH_GET_SETTINGS,kAPI_PARAM_USERID,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            
            self.txtColor.text = [dict objectForKey:kAPI_PARAM_DISPLAYCOLOR];
            CGFloat zoomValue = [[dict objectForKey:kAPI_PARAM_DEVICEZOOM] floatValue];
            
            rotation = [[dict objectForKey:@"DisplayRotation"] floatValue];
            transition = [[dict objectForKey:kAPI_PARAM_ROTATEEVERY] floatValue];
            
            if(zoomValue > 0.0) {
                NSInteger percentageValue = zoomValue*100;
                self.txtZoom.text = [NSString stringWithFormat:@"%ld%%", (long)percentageValue];
                self.txtZoom.accessibilityValue = [dict objectForKey:kAPI_PARAM_DEVICEZOOM];//Added By DHAWAL 14-Jul-2016
            }
            self.txtTransition.text = [dict objectForKey:kAPI_PARAM_ROTATEEVERY];
            self.txtRefresh.text = [NSString stringWithFormat:@"%d",[[dict objectForKey:kAPI_PARAM_RELOADEVERY] intValue]];
            NSString *strDeviceView = [dict objectForKey:kAPI_PARAM_DEVICEVIEW];
            if(![strDeviceView isKindOfClass:[NSNull class]] && [strDeviceView isEqualToString:@"1"])
            {
                self.btnSinglePage.selected = YES;
                self.btnRotatePage.selected = NO;
            }
            else
            {
                self.btnSinglePage.selected = NO;
                self.btnRotatePage.selected = YES;
            }
            [self changeViewPosition];
            
            NSString *strAudioMode = [dict objectForKey:kAPI_PARAM_AUDIOMODE];
            
            if(![strAudioMode isKindOfClass:[NSNull class]] && [strAudioMode isEqualToString:@"hdmi"])
            {
                self.btnHDMI.selected = YES;
                self.btnJack.selected = NO;
                [[User currentUser] setAUDIOHDMI:@"1"];
            }
            else if(![strAudioMode isKindOfClass:[NSNull class]] && [strAudioMode isEqualToString:@"ajack"])
            {
                self.btnHDMI.selected = NO;
                self.btnJack.selected = YES;
                [[User currentUser] setAUDIOHDMI:@"0"];
            }
            else
            {
                self.btnHDMI.selected = NO;
                self.btnJack.selected = NO;
            }
            
            self.txtWPUrl.text = dict[@"WallPaperURL"];
            
//            self.pixTransitionTextField.text = [dict objectForKey:kAPI_PIX_TRANSITION];
//
//            if(![[dict objectForKey:kAPI_PARAM_VIDEOLOOP] isKindOfClass:[NSNull class]] && [[dict objectForKey:kAPI_PARAM_VIDEOLOOP] isEqualToString:@"1"])
//            {
//                self.btnLoopVideo.selected = YES;
//                self.btnDontLoopVideo.selected = NO;
//            }
//            else
//            {
//                self.btnLoopVideo.selected = NO;
//                self.btnDontLoopVideo.selected = YES;
//            }
//
//            self.btnPicture.selected = NO;
//            self.btnVideo.selected = NO;
//            self.btnPowerPoint.selected = NO;
//
//            if(![[dict objectForKey:kAPI_PARAM_MEDIATOPLAY] isKindOfClass:[NSNull class]])
//            {
//                NSString* mediaToPlay = [dict objectForKey:kAPI_PARAM_MEDIATOPLAY];
//                
//                if ([mediaToPlay isEqualToString:@"1"])
//                    self.btnPicture.selected = YES;
//                else if ([mediaToPlay isEqualToString:@"2"])
//                    self.btnVideo.selected = YES;
//                else
//                    self.btnPowerPoint.selected = YES;
//            }

            
            [[User currentUser] setSETTINGSREFRESH:self.txtRefresh.text];
            [[User currentUser] setSETTINGSTRANSITION:self.txtTransition.text];
            
            [self getColor];
        }
    }];
}

- (void) getColor
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_DISPLAYCOLORS withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrColors removeAllObjects];
                for (NSDictionary *dict in response) {
                    Color *d = [[Color alloc] init];
                    [d setData:dict];
                    [arrColors addObject:d];
                }
            }
            [self getDeviceZoom];
        }
    }];
}

- (void) getDeviceZoom
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_DEVICEZOOM withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrZooms removeAllObjects];
                for (NSDictionary *dict in response) {
                    Zoom *d = [[Zoom alloc] init];
                    [d setData:dict];
                    [arrZooms addObject:d];
                }
                
                [self getDisplayRotation];
            }
            
        }
    }];
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
                
                if (arrRotations.count > transition) {
                    Transition *r = arrNumber[transition];
                    self.txtTransition.text = r.name;
                    self.txtTransition.accessibilityValue = r.value;
                }
            }
        }
    }];
}

- (void) getDisplayRotation
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_DISPLAYROTATIONS withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrRotations removeAllObjects];
                for (NSDictionary *dict in response) {
                    Rotation *d = [[Rotation alloc] init];
                    [d setData:dict];
                    [arrRotations addObject:d];
                }
                
                if (arrRotations.count > rotation) {
                    Rotation *r = arrRotations[rotation];
                    self.txtRotation.text = r.name;
                    self.txtRotation.accessibilityValue = r.value;
                }
            }
            
            [self getTransitions];
        }
    }];
}

- (IBAction)onClickColorTextfield:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < arrColors.count; i++) {
        Color *c = arrColors[i];
        [arr addObject:c.strColor];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Colors" rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        Color *c = [arrColors objectAtIndex:selectedIndex];
        self.txtColor.text = c.strColor;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)onClickRotationTextfield:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < arrRotations.count; i++) {
        Rotation *z = arrRotations[i];
        [arr addObject:z.name];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Rotation" rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        Rotation *z = [arrRotations objectAtIndex:selectedIndex];
        self.txtRotation.text = z.name;
        self.txtRotation.accessibilityValue = z.value;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)onClickZoomTextfield:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < arrZooms.count; i++) {
        Zoom *z = arrZooms[i];
        [arr addObject:z.strZoom];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Zoom" rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        Zoom *z = [arrZooms objectAtIndex:selectedIndex];
        self.txtZoom.text = z.strZoom;
        self.txtZoom.accessibilityValue = z.strValue;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

#pragma mark - Page Button

-(IBAction)onClickSinglePage:(id)sender
{
    self.btnSinglePage.selected = YES;
    self.btnRotatePage.selected = NO;
    
    self.txtRefresh.enabled = NO;
    self.txtTransition.enabled = NO;
    
    [self changeViewPosition];
}

-(IBAction)onClickRotatePage:(id)sender
{
    self.btnSinglePage.selected = NO;
    self.btnRotatePage.selected = YES;
    
    self.txtRefresh.enabled = YES;
    self.txtTransition.enabled = YES;
    
    [self changeViewPosition];
}

//-(IBAction)onClickLoopVideoButtons:(UIButton*)sender
//{
//    self.btnLoopVideo.selected = NO;
//    self.btnDontLoopVideo.selected = NO;
//    sender.selected = YES;
//}

//-(IBAction)onClickMediaButtons:(UIButton*)sender
//{
//    self.btnPicture.selected = NO;
//    self.btnVideo.selected = NO;
//    self.btnPowerPoint.selected = NO;
//    sender.selected = YES;
//}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [textField resignFirstResponder];
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    if (textField == self.txtRefresh ) {
        
        if (self.txtRefresh.text.length == 2)
        {
            return NO;
        }
    }
    else
    {
        if (self.txtTransition.text.length == 2)
        {
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)helpPath {
    return @"0-4";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
