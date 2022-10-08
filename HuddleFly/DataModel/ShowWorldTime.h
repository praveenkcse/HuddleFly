//
//  ShowWorldTime.h
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowWorldTime : NSObject

@property (nonatomic , assign) int ID;
@property (nonatomic , strong) NSString *strCountry;
@property (nonatomic , strong) NSString *strCity;
@property (nonatomic , strong) NSString *strState;
@property (nonatomic , assign) BOOL isSelected;

- (void)setData:(NSDictionary *)dictData;

@end