//
//  LocalEvents.h
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalEvents : NSObject

@property (nonatomic , strong) NSString *strId;
@property (nonatomic , strong) NSString *strName;
@property (nonatomic , assign) BOOL isSelected;

- (void)setData:(NSDictionary *)dictData;
@end


@interface DeviceCommand : NSObject

@property (nonatomic , strong) NSString *strCommand;
@property (nonatomic , strong) NSString *strValue;

- (void)setData:(NSDictionary *)dictData;
@end


@interface Color : NSObject

@property (nonatomic , strong) NSString *strColor;
@property (nonatomic , strong) NSString *strValue;

- (void)setData:(NSDictionary *)dictData;
@end

@interface Zoom : NSObject

@property (nonatomic , strong) NSString *strZoom;
@property (nonatomic , strong) NSString *strValue;

- (void)setData:(NSDictionary *)dictData;
@end

@interface Rotation : NSObject

@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *value;

- (void)setData:(NSDictionary *)dictData;
@end

@interface Transition : NSObject

@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *value;

- (void)setData:(NSDictionary *)dictData;
@end

@interface FbData : NSObject

@property (nonatomic , strong) NSString *strName;
@property (nonatomic , strong) NSString *strId;
@property (nonatomic , assign) BOOL isSelected;
-(void)setData:(NSDictionary *)dictData;

@end

@interface FbDetail : NSObject

@property (nonatomic , strong) NSArray *arrFbData;
@property (nonatomic , strong) NSString *strEmail;
@property (nonatomic , strong) NSString *strRefreshToken;
@property (nonatomic , strong) NSString *strColor;
@property (nonatomic , strong) NSString *strAccountID;
@property (nonatomic) BOOL isShowTask;

- (void)setData:(NSDictionary *)dict;
@end

@interface GoogleDisplayData : NSObject

@property (nonatomic , strong) NSString *strId;
@property (nonatomic , strong) NSString *strName;

@property (nonatomic , assign) BOOL isSelected;

- (void)setData:(NSDictionary *)dictData;

@end

@interface GoogleData : NSObject

@property (nonatomic , strong) NSArray *arrGoogleDisplayData;
//@property (nonatomic , assign) NSDictionary* calendarDict;
@property (nonatomic , strong) NSString *strEmail;
@property (nonatomic , strong) NSString *strServerAuthCode;
@property (nonatomic , strong) NSString *strRefreshToken;
@property (nonatomic , strong) NSString *strColor;
@property (nonatomic , strong) NSString *strAccountID;
@property (nonatomic) BOOL isShowTask;

- (void)setData:(NSDictionary *)dict;
@end


@interface DeviceList : NSObject
@property (nonatomic , strong) NSString *strDeviceId;
@property (nonatomic , strong) NSString *strUserId;
@property (nonatomic , strong) NSString *strDeviceName;
@property (nonatomic , strong) NSString *strMacAddr;
@property (nonatomic , strong) NSString *strToken;
@property (nonatomic , strong) NSString *strIPAddr;
@property (nonatomic , strong) NSString *strDeviceLocation;
@property (nonatomic , strong) NSString *strTimeStamp;
@property (nonatomic , strong) NSString *strCreatedDate;
@property (nonatomic , strong) NSString *strStatus;

@property (nonatomic , strong) NSString *strDisplayMode;
@property (nonatomic , strong) NSString *strConnType;
@property (nonatomic , strong) NSString *strSSID;
@property (nonatomic , strong) NSString *strScreen;
@property (nonatomic , strong) NSString *strIsMaster;
@property (nonatomic , strong) NSString *strIsFollowMaster;
@property (nonatomic , strong) NSString *strOfflineMode;
@property (nonatomic , strong) NSString *strDeviceSchedule;
@property (nonatomic , strong) NSString *strScreenStatus;
- (void)setData:(NSDictionary *)dictData;
@end


@interface AlertList : NSObject

@property (nonatomic , strong) NSString *strAlertType;
@property (nonatomic , strong) NSString *strAlertMsg;
@property (nonatomic , strong) NSString *strMediaType;
@property (nonatomic , strong) NSString *strTimestamp;
@property (nonatomic , strong) NSString *strMediaUrl;

- (void)setData:(NSDictionary *)dictData;
@end


@interface WeMo : NSObject

@property (nonatomic , strong) NSString *strSwitch;
@property (nonatomic , strong) NSString *strStatus;
@property (nonatomic , strong) NSString *strID;
@property (nonatomic , strong) NSString *strLastContactDate;
@property (nonatomic , assign) int idSwitch;

- (void)setData:(NSDictionary *)dictData index:(int)index;
@end

