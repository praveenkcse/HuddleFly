//
//  Preferences.m
//  HuddleFly
//
//  Created by Jignesh on 15/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

@synthesize ID_;
@synthesize Name;
@synthesize Status;
@synthesize isSelected;
@synthesize IsPaid;

- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        ID_ = [[dictData objectForKey:@"ID"] intValue];
        Name = [dictData objectForKey:@"Name"];
        Status = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"Status"]];
        IsPaid = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"IsPaid"]];
        isSelected = [Status isEqualToString: @"1"] ? YES : NO;//NO;
//        isSelected = NO;
    }
}



@end
