//
//  ScheduleData.m
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "ScheduleData.h"
#import "UtilityClass.h"

@implementation ScheduleData

- (void)setScheduleDataTitle:(NSString *)strTitle time:(NSString *)strTime isOn:(BOOL)isSwtOn
{
    _strTimeSchedule = strTime;
    _strTitleSchedule = strTitle;
    _isSwtOn = isSwtOn;
}

- (void)setData:(NSDictionary *)dict
{
    NSArray *arrDay = @[@"Wake",@"Leave",@"Return",@"Sleep"];
    if([dict isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dictData = [self dictionaryRemoveNull:dict];
        NSDictionary *dictTime = [self dictionaryRemoveNull:[dict objectForKey:@"Time"]];
        
        if([dictTime isKindOfClass:[NSDictionary class]]){
            
            //_strCreatedDate = [UtilityClass scannerTimeStamp:[dictData objectForKey:@"CreatedDate"]];
            //_strCronCmd = [dictData objectForKey:@"CronCmd"];
            _strDayOfWeek = [dictData objectForKey:@"DayOfWeek"];
            _strDeviceAction = [dictData objectForKey:@"DeviceAction"];
            _strScheduleID = [dictData objectForKey:@"ScheduleId"];
            _strStatus = [dictData objectForKey:@"Status"];
            //_strTimeStamp = [UtilityClass scannerTimeStampGetTime:[dictData objectForKey:@"TimeStamp"]];
            _strUserAction = [dictData objectForKey:@"UserAction"];
            
            //Time
            
            _strDays = [dictTime objectForKey:@"Days"];
            _strHours = [dictTime objectForKey:@"Hours"];
           // _strMilliSeconds = [dictTime objectForKey:@"Milliseconds"];
            _strMinutes = [dictTime objectForKey:@"Minutes"];
           // _strSeconds = [dictTime objectForKey:@"Seconds"];
            
            _strTitleSchedule = arrDay[([_strUserAction intValue]-1)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"]; //hh:mm a //HH:mm
            NSString *strDate = [NSString stringWithFormat:@"%@:%@",_strHours,_strMinutes];
            NSDate *date = [dateFormatter dateFromString:strDate];
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSString *currentTime = [dateFormatter stringFromDate:date];
            
            _strTimeSchedule = currentTime;//_strTimeStamp
            _isSwtOn = [_strDeviceAction intValue];//_strStatus
        }
    }
}

- (NSDictionary *)dictionaryRemoveNull:(NSDictionary *)dict
{
    if([dict isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dictRet = [[NSMutableDictionary alloc] init];
        NSArray *arrKeys = [dict allKeys];
        for(int i = 0; i < arrKeys.count ; i++){
            NSString *key = arrKeys[i];
            NSString *value = [UtilityClass isNullStringValue:[dict objectForKey:key]];
            if([value isKindOfClass:[NSNumber class]]){
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                value = [formatter stringFromNumber:(NSNumber *)value];
            }
            [dictRet setObject:value forKey:key];
        }
        return dictRet;
        
    }else{
        return dict;
    }
}
@end

@implementation ScheduleDayData



@end
