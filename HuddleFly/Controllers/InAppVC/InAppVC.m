//
//  InAppVC.m
//  HuddleFly
//
//  Created by BMAC on 27/10/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "InAppVC.h"
#import "InAppHelper.h"
#import "ModelPaymentPlan.h"
#import "InAppCell.h"

@interface InAppVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *dictProducts;
    NSMutableArray *arrProductIdentifier;
    NSMutableArray *arrPaymentPlan;
    
    NSString *strSelectedPlanID;
}

@property (nonatomic , weak)IBOutlet UITableView *tblView;
@end//$(PRODUCT_BUNDLE_IDENTIFIER)

@implementation InAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@"Pay"];
    [super setBackBarItem:YES];
    [super setHelpBarButton:10];
    
    [_tblView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    dictProducts = [[NSMutableDictionary alloc] init];
    
    [self inAppFetchProducts];
}

- (NSString *)helpPath {
    return @"0-10";
}

- (void)getPaymentPlan
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_GET_PAYMENTPLANS withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if([response isKindOfClass:[NSArray class]]){
                NSArray *arr = (NSArray *)response;
                if(arrPaymentPlan == nil){
                    arrPaymentPlan = [[NSMutableArray alloc] init];
                }
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *d = arr[i];
                    NSArray *arrPlan = [[UtilityClass valueFromResponse:[d valueForKey:@"PlanName"]] componentsSeparatedByString:@" "];
                    if(arrPlan.count > 0){
                        NSString *strPlanName = arrPlan[0];
                        for(int j = 0; j < arrProductIdentifier.count; j++){
                            SKProduct *product = arrProductIdentifier[j];
                            NSArray *arrProductName = [product.localizedTitle componentsSeparatedByString:@" "];
                            if(arrProductName.count > 0){
                                NSString *strProductName = arrProductName[1];//0 Change BY DHAWAL DEC-16-2016
                                if([self matchString:[strPlanName lowercaseString] WithString:[strProductName lowercaseString]]){
                                    ModelPaymentPlan *model = [[ModelPaymentPlan alloc] init];
                                    [model setData:d];
                                    model.product = product;
                                    model.strName = strPlanName;
                                    [arrPaymentPlan addObject:model];
                                }
                            }
                        }
                    }
                }
                if(arrPaymentPlan.count > 0){
                    [_tblView reloadData];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (BOOL)matchString:(NSString *)str WithString:(NSString *)str1
{
    if ([str rangeOfString:str1].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}



#pragma mark -
#pragma mark - InApp Purchase
#pragma mark -

- (void)inAppFetchProducts
{
    //In-APP
    if ([[dictProducts allKeys] count] == 0) {
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
        [[InAppHelper sharedObject]fetchAvailableProductsWithBlock:^(BOOL result) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            if (result) {
                [dictProducts removeAllObjects];
                [dictProducts addEntriesFromDictionary:[InAppHelper sharedObject].allValidProducts];
                if(dictProducts){
                    [self fetchIdentifier];
                }
            }
            else{
                NSLog(@"No Products");
                [[UtilityClass sharedObject] showAlertWithTitle:@"Products!" andMessage:@"No Products"];
            }
        }];
    }
}

- (void)fetchIdentifier
{
    if(!arrProductIdentifier){
        arrProductIdentifier = [[NSMutableArray alloc] init];
    }else{
        [arrProductIdentifier removeAllObjects];
    }
    for(int i = 0; i < [dictProducts allKeys].count ; i++)
    {
        SKProduct *product = [dictProducts objectForKey:[[dictProducts allKeys] objectAtIndex:i]];
        
        [arrProductIdentifier addObject:product];
        
        NSLog(@"Product identifier :%@ localize Title :%@",product.productIdentifier,[product localizedTitle]);
    }
    
    [self getPaymentPlan];
}

- (void)purchaseProduct:(SKProduct *)productSelected
{
    if(productSelected){
        SKProduct *product = productSelected;
        
        NSString *strProductIdentifier = product.productIdentifier;
        
        if(dictProducts)
        {
            if([[dictProducts allKeys] containsObject:strProductIdentifier])
            {
                SKProduct *product = [dictProducts objectForKey:strProductIdentifier];
                NSString *strProductIdetifier = product.productIdentifier;
                [self purchaseWithProductID:strProductIdetifier];
            }
        }
    }
}

- (void)purchaseWithProductID:(NSString *)strProductID {
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:nil];
    
    [[InAppHelper sharedObject]purchaseProduct:strProductID withBlock:^(Transaction result, NSError *error) {
        switch (result) {
            case TransactionPurchasing:
                
                break;
            case TransactionPurchased:
            {
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                
                [[UtilityClass sharedObject] showAlertWithTitle:@"Succcess!" andMessage:@"Purchased"];
                [[AppDelegate sharedAppDelegate] setPlanUpdatedRemain:YES];
                [[AppDelegate sharedAppDelegate] updatePlanWithProgressView:YES];
                
                NSLog(@"Purchased");
            }
                break;
            case TransactionRestored:
            {
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                NSLog(@"Restored");
            }
                break;
            case TransactionNoProduct:
            {
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:@"No Product"];
                
            }
                break;
            case TransactionFailed:
            {
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
//                [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:@"Purchase Failed, Please try again."];
                
                if (error.code != SKErrorPaymentCancelled) {
                    [[UtilityClass sharedObject] showAlertWithTitle:@"Purchase Failed" andMessage:error.localizedDescription];
                } else {
//                    [[UtilityClass sharedObject] showAlertWithTitle:@"Purchase Cancelled" andMessage:@""];
                }
            }
                break;
            default:
            {
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:@"Can't connect with apple store, Please try again."];
            }
                break;
        }
    }];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPaymentPlan.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrPaymentPlan.count > indexPath.row){
        return 70;
    }
    return 270;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrPaymentPlan.count > indexPath.row){
        InAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellInApp"];
        if(cell == nil){
            cell = [[InAppCell alloc] init];
        }
        
        ModelPaymentPlan *obj = (ModelPaymentPlan *)arrPaymentPlan[indexPath.row];
        cell.lblPlanName.text = obj.strName;
        cell.lblPlanDesc.text = obj.strPlanName;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPaymentDetail"];
        if(cell == nil){
            cell = [[UITableViewCell alloc] init];
        }
        return cell;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(arrPaymentPlan.count > indexPath.row){
        ModelPaymentPlan *obj = (ModelPaymentPlan *)[arrPaymentPlan objectAtIndex:indexPath.row];
        strSelectedPlanID = obj.strID;
        [[AppDelegate sharedAppDelegate]setSelectedPlanId:obj.strID];
        [self purchaseProduct:(SKProduct *)obj.product];
    }
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

