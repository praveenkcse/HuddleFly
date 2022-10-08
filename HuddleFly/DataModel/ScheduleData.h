//
//  ScheduleData.h
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleData : NSObject

@property (nonatomic , retain) NSString *strTitleSchedule;
@property (nonatomic , retain) NSString *strTimeSchedule;
@property (nonatomic , assign) BOOL isSwtOn;

@property (nonatomic , retain) NSString *strCreatedDate;
@property (nonatomic , retain) NSString *strDayOfWeek;
@property (nonatomic , retain) NSString *strDeviceAction;
@property (nonatomic , retain) NSString *strCronCmd;
@property (nonatomic , retain) NSString *strScheduleID;
@property (nonatomic , retain) NSString *strStatus;
@property (nonatomic , retain) NSString *strTimeStamp;
@property (nonatomic , retain) NSString *strUserAction;//strTitleSchedule

//Time

@property (nonatomic , retain) NSString *strDays;
@property (nonatomic , retain) NSString *strHours;
@property (nonatomic , retain) NSString *strMinutes;
@property (nonatomic , retain) NSString *strMilliSeconds;
@property (nonatomic , retain) NSString *strSeconds;

/*@property (nonatomic , retain) NSString *strTicks;
@property (nonatomic , retain) NSString *strTotalDays;
@property (nonatomic , retain) NSString *strTotalHours;
@property (nonatomic , retain) NSString *strTotalMilliSeconds;
@property (nonatomic , retain) NSString *strTotalMinutes;
@property (nonatomic , retain) NSString *strTotalSeconds;*/

- (void)setScheduleDataTitle:(NSString *)strTitle time:(NSString *)strTime isOn:(BOOL)isSwtOn;
- (void)setData:(NSDictionary *)dict;
@end

@interface ScheduleDayData : NSObject

@property (nonatomic , retain) NSArray *arrScheduleData;
@property (nonatomic , assign) NSInteger day;

@end
