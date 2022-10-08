//
//  ShowWorldTime.m
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "ShowWorldTime.h"

@implementation ShowWorldTime

@synthesize ID,strCity,strCountry,strState,isSelected;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        ID = [[dictData objectForKey:@"ID"] intValue];
        strCountry = [dictData objectForKey:@"country"];
        strState = [dictData objectForKey:@"state"];
        strCity = [dictData objectForKey:@"city"];
        isSelected = NO;
    }
}

@end
