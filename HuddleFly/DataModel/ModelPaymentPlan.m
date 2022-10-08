//
//  ModelPaymentPlan.m
//  HuddleFly
//
//  Created by BMAC on 27/10/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "ModelPaymentPlan.h"
#import "UtilityClass.h"

@implementation ModelPaymentPlan

- (void)setData:(NSDictionary *)dict
{
    if([dict isKindOfClass:[NSDictionary class]]){
        _strID = [UtilityClass valueFromResponse:[dict valueForKey:@"ID"]];
        _strDevices = [UtilityClass valueFromResponse:[dict valueForKey:@"Devices"]];
        _strPlanAmt = [UtilityClass valueFromResponse:[dict valueForKey:@"PlanAmt"]];
        _strPlanName = [UtilityClass valueFromResponse:[dict valueForKey:@"PlanName"]];
        _strStatus = [UtilityClass valueFromResponse:[dict valueForKey:@"Status"]];
    }
}
@end
