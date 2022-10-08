//
//  LocalEvents.m
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "LocalEvents.h"
#import "UtilityClass.h"

@implementation LocalEvents

@synthesize strId,strName,isSelected;

- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        strId = [dictData objectForKey:@"id"];
        strName = [dictData objectForKey:@"name"];
        isSelected = NO;
    }
}

@end


@implementation DeviceCommand

@synthesize strCommand,strValue;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        strCommand = [dictData objectForKey:@"Name"];
        strValue = [dictData objectForKey:@"Value"];
    }
}
@end



@implementation Color

@synthesize strColor,strValue;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        strColor = [dictData objectForKey:@"Name"];
        strValue = [dictData objectForKey:@"Value"];
    }
}
@end

@implementation Zoom

@synthesize strZoom,strValue;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        strZoom = [dictData objectForKey:@"Name"];
        strValue = [dictData objectForKey:@"Value"];
    }
}
@end

@implementation Rotation

@synthesize name,value;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        name = [dictData objectForKey:@"Name"];
        value = [dictData objectForKey:@"Value"];
    }
}
@end

@implementation Transition

@synthesize name,value;


- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        name = [dictData objectForKey:@"Name"];
        value = [dictData objectForKey:@"Value"];
    }
}
@end

@implementation FbData

@synthesize strName,isSelected,strId;

-(id)initWithCoder:(NSCoder *)coder{
    self=[[FbData alloc]init];
    if (self!=nil) {
        self.strId = [coder decodeObjectForKey:@"strId"];
        self.strName = [coder decodeObjectForKey:@"strName"];
        self.isSelected = [coder decodeBoolForKey:@"isSelected"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeBool:self.isSelected forKey:@"isSelected"];
    [coder encodeObject:self.strId forKey:@"strId"];
    [coder encodeObject:self.strName forKey:@"strName"];
}

- (void)setData:(NSDictionary *)dictData {
    if (dictData) {
        strName = [dictData objectForKey:@"name"];
        strId = [dictData objectForKey:@"id"];
        isSelected = NO;
    }
}
@end

@implementation FbDetail

-(id)initWithCoder:(NSCoder *)coder{
    self=[[FbDetail alloc]init];
    if (self!=nil) {
        self.strRefreshToken = [coder decodeObjectForKey:@"strRefreshToken"];
        self.arrFbData = [coder decodeObjectForKey:@"arrFbData"];
        self.strColor = [coder decodeObjectForKey:@"strColor"];
        self.strEmail = [coder decodeObjectForKey:@"strEmail"];
        self.strAccountID = [coder decodeObjectForKey:@"strAccountID"];
        
        self.isShowTask = [coder decodeBoolForKey:@"isShowTask"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeBool:self.isShowTask forKey:@"isShowTask"];
    
    [coder encodeObject:self.strRefreshToken forKey:@"strRefreshToken"];
    [coder encodeObject:self.arrFbData forKey:@"arrFbData"];
    [coder encodeObject:self.strColor forKey:@"strColor"];
    [coder encodeObject:self.strEmail forKey:@"strEmail"];
    [coder encodeObject:self.strAccountID forKey:@"strAccountID"];
}

-(void)setData:(NSDictionary *)dict
{
    if(dict && [dict isKindOfClass:[NSDictionary class]]){
        
    }
}

@end

@implementation GoogleDisplayData

@synthesize strId,isSelected,strName;

-(id)initWithCoder:(NSCoder *)coder{
    self=[[GoogleDisplayData alloc]init];
    if (self!=nil) {
        self.strId = [coder decodeObjectForKey:@"strId"];
        self.isSelected = [coder decodeBoolForKey:@"isSelected"];
        self.strName = [coder decodeObjectForKey:@"strName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeBool:self.isSelected forKey:@"isSelected"];
    [coder encodeObject:self.strId forKey:@"strId"];
    [coder encodeObject:self.strName forKey:@"strName"];
}

- (void)setData:(NSDictionary *)dictData{
    if (dictData) {
        strId = [dictData objectForKey:@"id"];
        NSString *strSummary = [dictData objectForKey:@"summary"]; //Added By DHAWAL 18-July-2017
        if (!strSummary || [strSummary isKindOfClass:[NSNull class]]){
            strSummary = @"";
        }
        strName = strSummary;
        isSelected = NO;
    }
}

@end

@implementation GoogleData


-(id)initWithCoder:(NSCoder *)coder{
    self=[[GoogleData alloc]init];
    if (self!=nil) {
        
        self.strRefreshToken = [coder decodeObjectForKey:@"strRefreshToken"];
        self.arrGoogleDisplayData = [coder decodeObjectForKey:@"arrGoogleDisplayData"];
        self.strColor = [coder decodeObjectForKey:@"strColor"];
        self.strEmail = [coder decodeObjectForKey:@"strEmail"];
        self.strAccountID = [coder decodeObjectForKey:@"strAccountID"];
        self.isShowTask = [coder decodeBoolForKey:@"isShowTask"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeBool:self.isShowTask forKey:@"isShowTask"];
    
    [coder encodeObject:self.strRefreshToken forKey:@"strRefreshToken"];
    [coder encodeObject:self.arrGoogleDisplayData forKey:@"arrGoogleDisplayData"];
    [coder encodeObject:self.strColor forKey:@"strColor"];
    [coder encodeObject:self.strEmail forKey:@"strEmail"];
    [coder encodeObject:self.strAccountID forKey:@"strAccountID"];
}


- (void)setData:(NSDictionary *)dict
{
    if(dict && [dict isKindOfClass:[NSDictionary class]]){
        
    }
}
@end


@implementation DeviceList

@synthesize strCreatedDate,strDeviceId,strDeviceLocation,strDeviceName,strIPAddr,strMacAddr,strToken,strTimeStamp,strUserId,strStatus,strConnType,strDisplayMode,strSSID,strScreen,strIsMaster,strIsFollowMaster,strOfflineMode,strDeviceSchedule,strScreenStatus;

- (void)setData:(NSDictionary *)dictData{
//    BOOL flag;
    if(dictData){
        strUserId = [self isNullString:[dictData objectForKey:@"UserID"]];
        strDeviceId = [self isNullString:[dictData objectForKey:@"DeviceID"]];
        strDeviceLocation = [self isNullString:[dictData objectForKey:@"DeviceLocation"]];
        strDeviceName = [self isNullString:[dictData objectForKey:@"DeviceName"]];
        strTimeStamp = [UtilityClass scannerTimeStamp:[self isNullString:[dictData objectForKey:@"TimeStamp"]]];
        strIPAddr = [self isNullString:[dictData objectForKey:@"IPAddr"]];
        strMacAddr = [self isNullString:[dictData objectForKey:@"MacAddr"]];
        strToken = [self isNullString:[dictData objectForKey:@"Token"]];
        strCreatedDate = [self isNullString:[dictData objectForKey:@"CreatedDate"]];
        strStatus = [self isNullString:[dictData objectForKey:@"Status"]];
        strConnType = [self isNullString:[dictData objectForKey:@"ConnType"]];
        strDisplayMode = [self isNullString:[dictData objectForKey:@"DisplayMode"]];
        strSSID = [self isNullString:[dictData objectForKey:@"SSID"]];
        strScreen = [self isNullString:[dictData objectForKey:@"ScreenShot"]];
        strIsMaster = [self isNullString:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"IsMaster"]]];
        strIsFollowMaster = [self isNullString:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"FollowMaster"]]];
        strOfflineMode = [self isNullString:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"OfflineMode"]]];
        strDeviceSchedule = [self isNullString:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"IsScheduleActive"]]];
//        flag = [NSNumber numberWithBool: dictData[@"IsScheduleActive"]];
//        if (flag) {
//            strDeviceSchedule = @"YES";
//        }else{
//            strDeviceSchedule = @"NO";
//        }
        strScreenStatus = [self isNullString:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"ScreenStatus"]]];
    }
}

- (NSString *)isNullString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]])
        return @"";
    if([str isKindOfClass:[NSString class]]){
        if(str.length == 0)
            return @"";
    }
    return str;
}
@end


@implementation AlertList

@synthesize strAlertMsg,strAlertType,strMediaType,strMediaUrl,strTimestamp;

- (void)setData:(NSDictionary *)dictData{
    if(dictData){
        if([UtilityClass ValueIsNull:[dictData objectForKey:@"AlertType"]])
            strAlertType = [[dictData objectForKey:@"AlertType"] stringValue];
        if([UtilityClass valueIsStringAndNotNull:[dictData objectForKey:@"AlertMsg"]])
            strAlertMsg = [dictData objectForKey:@"AlertMsg"];
        if([UtilityClass ValueIsNull:[dictData objectForKey:@"MediaType"]])
            strMediaType = [[dictData objectForKey:@"MediaType"] stringValue];
        if([UtilityClass valueIsStringAndNotNull:[dictData objectForKey:@"MediaURL"]])
            strMediaUrl = [dictData objectForKey:@"MediaURL"];
        if([UtilityClass valueIsStringAndNotNull:[dictData objectForKey:@"TimeStamp"]])
            strTimestamp = [dictData objectForKey:@"TimeStamp"];
    }
}

@end


@implementation WeMo

@synthesize strSwitch,idSwitch,strStatus,strID,strLastContactDate;

- (void)setData:(NSDictionary *)dictData index:(int)index
{
    if(dictData){
        strSwitch = [dictData objectForKey:@"Switch"];
        strID = [dictData objectForKey:@"WeMoID"];
        strStatus = [dictData objectForKey:@"Status"];
        strLastContactDate = [UtilityClass scannerTimeStamp:[dictData objectForKey:@"TimeStamp"]];
        idSwitch = index;
    }
}

@end
