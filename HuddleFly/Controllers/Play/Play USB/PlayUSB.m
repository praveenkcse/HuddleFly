//
//  PlayUSB.m
//  HuddleFly
//
//  Created by BMAC on 12/07/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "PlayUSB.h"
#import "ActionSheetStringPicker.h"
#import "Global.h"
#import "LocalEvents.h"
@interface PlayUSB ()<UITextFieldDelegate> {
    NSMutableArray *arrNumber;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space;

@end

@implementation PlayUSB

- (NSString *)helpPath {
    return @"102-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setMultimedia:@"1"];
    [super setBackBarItem:YES];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017
    [Global roundBorderSet:_playUsbBtn];
    [Global roundBorderSet:_stopUsbBtn];
    [[_stopUsbBtn layer] setCornerRadius:5.0f];
    [[_stopUsbBtn layer] setMasksToBounds:YES];
    [[_stopUsbBtn layer] setBorderWidth: 1.0f];
    [[_stopUsbBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [_stopUsbBtn setBackgroundColor:COLOR_BTN_REDBACK];
    [Global roundBorderSet:self.txtMediaUrl];
        [[self.txtMediaUrl layer] setCornerRadius:4.0f];
    [[self.txtMediaUrl layer] setBorderWidth: 1.0f];
    [[self.txtMediaUrl layer] setBorderColor:[UIColor blackColor].CGColor];

    [[self.txtMediaUrl layer] setMasksToBounds:YES];
    
    arrNumber = [[NSMutableArray alloc] init];
    [self getTransition];
//    self.mediumView.hidden = true;
//    self.txtMediaUrl.hidden = true;
//    self.medialUrlLabel.hidden = true;
//    self.placeHolderLabel.hidden = true;
    
    if ([[User currentUser] getPIXTRANSITION] != nil) {
        if ([[User currentUser] getPIXTRANSITION].length > 0) {
            self.pixTransitionTextField.text = [[User currentUser] getPIXTRANSITION];
        }
    }
    
    if ([[User currentUser] getMediaToPlay] != nil) {
        if ([[User currentUser] getMediaToPlay].length > 0) {
            int value = [[User currentUser] getMediaToPlay].intValue;
            
            self.btnPicture.selected = NO;
            self.btnVideo.selected = NO;
            self.btnPowerPoint.selected = NO;
            
            if(value == 1)
            self.btnPicture.selected = YES;
            else if (value == 2)
            self.btnVideo.selected = YES;
            else
            self.btnPowerPoint.selected = YES;
        }
    }
    
    self.space.constant = 8;
    
    [self getPlayMedia];
    

    [self setupInputAccessoryViews];
    
    [self updateUI];
}

-(void) getPlayMedia {
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
//    NSString *apiPath = [NSString stringWithFormat:@"%@?%@=%@&%@=%@",@"GetPlayMedia",kAPI_PARAM_USERID,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_PLAY_FROM_CLOUD withParamData:dictParam withBlock:^(id response, NSError * error) {
    
   // [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            
//            NSString *mediaMode = [[dict objectForKey:@"MediaMode"] stringValue];
//            if(![mediaMode isKindOfClass:[NSNull class]] && [mediaMode isEqualToString:@"1"])
//            {
//                self.btnOnline.selected = YES;
//                self.btnOffline.selected = NO;
//                
//                self.mediumView.hidden = false;
//            }
//            else if(![mediaMode isKindOfClass:[NSNull class]] && [mediaMode isEqualToString:@"2"])
//            {
//                self.btnOnline.selected = NO;
//                self.btnOffline.selected = YES;
//                self.mediumView.hidden = false;
//
//            } else {
//                self.btnOnline.selected = NO;
//                self.btnOffline.selected = NO;
//                self.mediumView.hidden = true;
//
//            }

//            NSString *MediaMedium = [[dict objectForKey:@"MediaMedium"] stringValue];
//            if(![MediaMedium isKindOfClass:[NSNull class]] && [MediaMedium isEqualToString:@"1"])
//            {
//                self.btnExternalUSB.selected = YES;
//                self.btnDeviceHardDerive.selected = NO;
//
//            }
//            else if(![MediaMedium isKindOfClass:[NSNull class]] && [MediaMedium isEqualToString:@"2"])
//            {
//                self.btnExternalUSB.selected = NO;
//                self.btnDeviceHardDerive.selected = YES;
//                
//                self.txtMediaUrl.text = [dict objectForKey:@"MediaURL"];
//
//                self.txtMediaUrl.hidden = false;
//                self.medialUrlLabel.hidden = false;
//                self.placeHolderLabel.hidden = false;
//                
//                self.space.constant = 128;
//            }
            self.txtMediaUrl.text = [dict objectForKey:@"MediaURL"];
            self.pixTransitionTextField.text = [[dict objectForKey:@"MediaTransit"] stringValue];
            
            self.btnPicture.selected = NO;
            self.btnVideo.selected = NO;
            self.btnPowerPoint.selected = NO;
            
            if(![[dict objectForKey:kAPI_PARAM_MEDIATOPLAY] isKindOfClass:[NSNull class]])
            {
                NSString* mediaToPlay = [[dict objectForKey:kAPI_PARAM_MEDIATOPLAY] stringValue];
                
                if ([mediaToPlay isEqualToString:@"1"])
                self.btnPicture.selected = YES;
                else if ([mediaToPlay isEqualToString:@"2"])
                self.btnVideo.selected = YES;
                else
                self.btnPowerPoint.selected = YES;
            }
            
            [self updateUI];
        }
    }];
}

- (void)updateUI {
    if (self.btnPicture.selected == YES) {
        self.pixTransitionLabel.hidden = NO;
        self.pixTransitionTextField.hidden = NO;
    } else {
        self.pixTransitionLabel.hidden = YES;
        self.pixTransitionTextField.hidden = YES;
    }
}

#pragma mark - Action

-(void)setMultimedia:(NSString *) multimediaValue{
}

- (void) getTransition
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject: @"1" forKey:kAPI_PARAM_MULTIMEDIA];
    [afn getDataFromPath:@"GetTransitionList2" withParamData:dictParam withBlock:^(id response, NSError *error) {
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


- (IBAction)onClickTextField:(UITextField *)sender
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
    //    [arrNumber removeAllObjects];
    
    NSString* pickerTitle;
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

- (IBAction)onClickPlayUSB:(id)sender
{
   /* if (_durationL.text.length == 0 && _btnPicuters.isSelected) {
    
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please select transition duration."
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion: nil];
        
        return;
    }
*/
    
    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
//    if(self.btnOnline.isSelected){
        [dictParam setObject:@"1" forKey:kAPI_PARAM_MEDIAMODE];
//    }else if (self.btnOffline.isSelected)
//        [dictParam setObject:@"2" forKey:kAPI_PARAM_MEDIAMODE];
//    else {
//
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Please select media mode."
//                                              message:nil
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
//                                   style:UIAlertActionStyleCancel
//                                   handler:nil];
//
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion: nil];
//
//        return;
//    }

//    if (self.btnExternalUSB.isSelected) {
//        [dictParam setObject:@"1" forKey:kAPI_PARAM_MEDIAMEDIUM];
//        [dictParam setObject:@"" forKey:kAPI_PARAM_MEDIAURL];
//
//    }
//    else if (self.btnDeviceHardDerive.isSelected) {
        [dictParam setObject:@"2" forKey:kAPI_PARAM_MEDIAMEDIUM];
    
        NSString* mediaUrl = [self.txtMediaUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (mediaUrl.length == 0 || ![mediaUrl containsString:@"dropbox.com"]) {
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Please enter valid dropbox url."
                                                  message:nil
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion: nil];
            
            return;
        } else
            [dictParam setObject:mediaUrl forKey:kAPI_PARAM_MEDIAURL];

//    }
//    
//    else {
//        
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Please select media medium."
//                                              message:nil
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
//                                   style:UIAlertActionStyleCancel
//                                   handler:nil];
//        
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion: nil];
//        
//        return;
//    }
    
    [dictParam setObject:self.pixTransitionTextField.text forKey:kAPI_MEDIA_TRANSIT];
    
    if (self.btnPicture.isSelected)
    [dictParam setObject:@"1" forKey:kAPI_PARAM_MEDIATOPLAY];
    else if (self.btnVideo.isSelected)
    [dictParam setObject:@"2" forKey:kAPI_PARAM_MEDIATOPLAY];
    else //powerpoint is selected
    [dictParam setObject:@"3" forKey:kAPI_PARAM_MEDIATOPLAY];

    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];

    [afn getDataFromPath:kAPI_PATH_PLAY_FROM_CLOUD withParamData:dictParam withBlock:^(id response, NSError *error) {
        
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            
            NSLog(@"Play usb Response :%@",response);
            
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[User currentUser] setPIXTRANSITION:self.pixTransitionTextField.text];
                
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)setupInputAccessoryViews {
    
    UIToolbar* accessoryView = [[UIToolbar alloc] init];
    
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:nil action:@selector(dismissKeyboard)];
    UIBarButtonItem *flexSpace   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    [accessoryView sizeToFit];
    [accessoryView setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil] animated:YES];
    
    self.txtMediaUrl.inputAccessoryView = accessoryView;
}

-(void) dismissKeyboard {

    [self.txtMediaUrl resignFirstResponder];
}

- (IBAction)onClickStopUSB:(id)sender
{
//    if (_btnPowerPoint.isSelected) {
//        [self onClickStopPowerPointPresentation];
//        return;
//    }
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];    
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSLog(@"Stop USB Dict :%@",dictParam);
    
    [afn getDataFromPath:kAPI_PATH_STOP_USB withParamData:dictParam withBlock:^(id response, NSError *error) {
        
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            
            NSLog(@"Stop usb Response :%@",response);
            
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"USB Stopped"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)onClickStopPowerPointPresentation
{
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_STOP_PRESENTATION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"Presentation Stopped"];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)onClickMediaMode:(UIButton*)sender {
    
    self.btnOnline.selected = false;
    self.btnOffline.selected = false;
    
    sender.selected = true;
    
    self.mediumView.hidden = false;
}

- (IBAction)onClickMedium:(UIButton*)sender {

    if (sender == self.btnExternalUSB) {
        
        self.btnExternalUSB.selected = true;
        self.btnDeviceHardDerive.selected = false;
        
        self.medialUrlLabel.hidden = true;
        self.placeHolderLabel.hidden = true;

        self.txtMediaUrl.hidden = true;
        
        self.space.constant = 8;
    } else if (sender == self.btnDeviceHardDerive) {
        
        self.btnExternalUSB.selected = false;
        self.btnDeviceHardDerive.selected = true;
        
        self.medialUrlLabel.hidden = false;
        self.placeHolderLabel.hidden = false;
        self.txtMediaUrl.hidden = false;
        
        self.space.constant = 128;
    }
}

-(IBAction)onClickMediaButtons:(UIButton*)sender
{
    self.btnPicture.selected = NO;
    self.btnVideo.selected = NO;
    self.btnPowerPoint.selected = NO;
    sender.selected = YES;
    [self updateUI];
}

/*
- (IBAction)onClickPictures:(id)sender
{
//    _txtDuration.hidden = NO;
    _durationL.hidden = NO;
    _btnPlayLoop.hidden = YES;
    _durationBtn.hidden = NO;
    
    _btnPicuters.selected = YES;
    _btnVideos.selected = NO;
    _btnPowerPoint.selected = NO;
}

- (IBAction)onClickVideos:(id)sender
{
    _viewSeprator.hidden = NO;
    _btnPlayLoop.hidden = NO;
//    _txtDuration.hidden = YES;
    _durationL.hidden = YES;
    _durationBtn.hidden = YES;
    
    _btnPicuters.selected = NO;
    _btnVideos.selected = YES;
    _btnPowerPoint.selected = NO;
}
- (IBAction)onClickPowerPoint:(id)sender
{
    _viewSeprator.hidden = NO;
    _btnPlayLoop.hidden = YES;
    //    _txtDuration.hidden = YES;
    _durationL.hidden = YES;
    _durationBtn.hidden = YES;
    
    _btnPicuters.selected = NO;
    _btnVideos.selected = NO;
    _btnPowerPoint.selected = YES;
}
- (IBAction)onClickPlayLoop:(id)sender
{
    _btnPlayLoop.selected = !_btnPlayLoop.isSelected;
}
- (IBAction)onClickDurationBtn:(UIButton *)sender
{
    NSArray *arrSec = @[@"5",@"10",@"15",@"30",@"60"];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Trasition Duration(in Seconds)" rows:arrSec initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        _durationL.text = [arrSec objectAtIndex:selectedIndex];
//        [sender resignFirstResponder];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
//        [sender resignFirstResponder];
    } origin:sender];
}
*/
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
