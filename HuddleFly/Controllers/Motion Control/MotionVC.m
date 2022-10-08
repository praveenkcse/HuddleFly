//
//  MotionVC.m
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "MotionVC.h"
#import "ActionSheetStringPicker.h"
#import "Global.h"
@interface MotionVC ()

@end

@implementation MotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavBarTitle:@"Activity Sensor"];
    
    arrMotion = [[NSMutableArray alloc] init];
    
    //viewTitle.layer.borderColor = [UIColor blackColor].CGColor;
    //viewTitle.layer.borderWidth = 1.0;
//    for(UIView *v in viewTitle.subviews){
//        v.layer.borderColor = [UIColor blackColor].CGColor;
//        v.layer.borderWidth = 1.0;
//    }
    
    [super setHelpBarButton:8];//ADDED BY DHAWAL 29-JUN-2017
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 42);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [colMotion setCollectionViewLayout:flowLayout];

    [self getMotionData];
    
    [Global roundBorderSet:_updateBtn];
    [Global roundBorderSet:txtPIRFlag];
    [Global roundBorderSet:txtPIRDelay];
 
    [super setBackBarItem];

}

#pragma mark - ApiCalls
#pragma mark - Get Motion Data

- (void)getMotionData
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_MOTION withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            NSDictionary *dict = response;
            if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:kAPI_PARAM_PIRFLAG]])
            {
                txtPIRFlag.text = [[dict objectForKey:kAPI_PARAM_PIRFLAG] isEqualToString:@"1"]?@"Yes":@"No";//[dict objectForKey:kAPI_PARAM_PIRFLAG];
            }
            /*if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:kAPI_PARAM_PIRTYPE]])
            {
                txtPIRType.text = [[dict objectForKey:kAPI_PARAM_PIRTYPE] isEqualToString:@"1"]?@"Picture":@"Video";//[dict objectForKey:kAPI_PARAM_PIRTYPE];
            }*/
            if([UtilityClass valueIsStringAndNotNull:[dict objectForKey:kAPI_PARAM_PIRDELAY]])
            {
                txtPIRDelay.text = [dict objectForKey:kAPI_PARAM_PIRDELAY];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [self getListAlert];
    }];
}

- (IBAction)btnUpDateMotionClicked:(id)sender
{
    
    int deviceLimit = [[User getUserDataWithParam:USER_PROFILE_DEVICELIMIT] intValue];
    
    if (deviceLimit > 1) { //Not a FREE account
        
    /*if (txtPIRType.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter type"];
        return;
    }
    else*/
    if(txtPIRFlag.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please pick activity status"];
        return;
    }

    else if (txtPIRDelay.text.length == 0)
    {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter activity delay"];
        return;
    }
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:txtPIRDelay.text forKey:kAPI_PARAM_PIRDELAY];
    [dictParam setObject:[txtPIRFlag.text isEqualToString:@"Yes"]?@"1":@"0" forKey:kAPI_PARAM_PIRFLAG];
    //[dictParam setObject:[txtPIRType.text isEqualToString:@"Picture"]?@"1":@"2" forKey:kAPI_PARAM_PIRTYPE];
    NSLog(@"dict :%@",dictParam);
    

    
    [afn getDataFromPath:kAPI_UpdateMotionSensor withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if([UtilityClass checkResponseSuccessOrNot:response])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Activity sensor updated!"];
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Activity sensor not updated!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
    }
    else{ //If it is a FREE account
        
        [[AppDelegate sharedAppDelegate] showToastMessage:@"This is a paid feature. Click Profile/Pay in Device List."];
        return;
    }
}

- (void)getListAlert
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];//
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];//
    [dictParam setObject:@"2" forKey:kAPI_PARAM_ALERTTYPE];
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_ALERTLIST withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [arrMotion removeAllObjects];
                for (NSDictionary *dict in response) {
                    AlertList *t = [[AlertList alloc] init];
                    [t setData:dict];
                    [arrMotion addObject:t];
                }
                [colMotion reloadData];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)onClickText:(id)sender
{
    UITextField *txt = (UITextField *)sender;
    [txt becomeFirstResponder];
    [txt resignFirstResponder];
    
    NSArray *arr;
    NSString *strTitle;
    if([txt isEqual:txtPIRDelay])
    {
        strTitle = @"Sensor Delay";
        arr = @[@5, @10, @15,@30, @60];
    }
    else if ([txt isEqual:txtPIRFlag])
    {
        strTitle = @"Enable Activity Sensor?";
        arr = @[@"Yes",@"No"];
    }
    /*else if ([txt isEqual:txtPIRType])
    {
        strTitle = @"MediaType";
        arr = @[@"Picture",@"Video"];
    }*/
    
    [ActionSheetStringPicker showPickerWithTitle:strTitle rows:arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        if([txt isEqual:txtPIRDelay])
            txt.text = [[arr objectAtIndex:selectedIndex] stringValue];
        else
            txt.text = [arr objectAtIndex:selectedIndex];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:txt];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrMotion.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   MotionCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MotionCell" forIndexPath:indexPath];
    AlertList *alert = (AlertList *)[arrMotion objectAtIndex:indexPath.row];
    [cell setCellData:alert];
    return cell;
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
