//
//  Preferences.h
//  HuddleFly
//
//  Created by Jignesh on 15/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

@property (nonatomic, assign) int ID_;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic, strong) NSString *IsPaid;

@property (nonatomic, assign) BOOL isSelected;

- (void)setData:(NSDictionary *)dictData;



@end
