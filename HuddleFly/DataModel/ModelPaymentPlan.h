//
//  ModelPaymentPlan.h
//  HuddleFly
//
//  Created by BMAC on 27/10/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPaymentPlan : NSObject
@property(nonatomic , retain)NSString *strID;
@property(nonatomic , retain)NSString *strPlanAmt;
@property(nonatomic , retain)NSString *strPlanName;
@property(nonatomic , retain)NSString *strDevices;
@property(nonatomic , retain)NSString *strStatus;
@property(nonatomic , retain)NSString *strName;
@property(nonatomic , retain)id product;

- (void)setData:(NSDictionary *)dict;
@end
