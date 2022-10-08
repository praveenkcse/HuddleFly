//
//  WeMoVC.m
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "WeMoVC.h"
#import "LocalEvents.h"
#import "WemoCell.h"

@interface WeMoVC ()

@end

@implementation WeMoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavBarTitle:@"WeMo"];
    arrWemo = [[NSMutableArray alloc] init];
    [self getList];
}

#pragma mark - GetList

- (void)getList
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_GET_WEMOLIST withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if ([response isKindOfClass:[NSArray class]]) {
                [arrWemo removeAllObjects];
                int c=0;
                for (NSDictionary *dict in response) {
                    WeMo *w = [[WeMo alloc] init];
                    [w setData:dict index:c];
                    [arrWemo addObject:w];
                    ++c;
                }
                [tblWeMo reloadData];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (void)UpdateSelectedSwitch:(NSString *)name status:(NSString *)status
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:name forKey:kAPI_PARAM_WEMOID];
    [dictParam setObject:status forKey:kAPI_PARAM_WEMOSTATUS];
    
    NSLog(@"dict :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_UPDATE_WEMOLIST withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            if([UtilityClass checkResponseSuccessOrNot:response])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"WeMo status updated!"];
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:@"WeMo status not updated!"];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWemo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeMoCell"];
    cell.delegate = self;
    if (cell == nil){
        cell = [[WemoCell alloc] init];
    }
    WeMo *w = (WeMo *)[arrWemo objectAtIndex:indexPath.row];
    [cell setCellData:w index:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - WeMoCell Delegate Mathod

- (void)selectedSwitch:(NSInteger)index status:(int)status{
    
    WeMo *w = (WeMo *)[arrWemo objectAtIndex:index];
    [self UpdateSelectedSwitch:w.strID status:[NSString stringWithFormat:@"%d",status]];//w.strStatus
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
