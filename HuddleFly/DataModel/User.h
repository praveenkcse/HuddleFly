//
//  User.h
//  Flabom
//
//  Created by Jignesh on 14/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_PROFILE_FIRSTNAME          @"FirstName"
#define USER_PROFILE_LASTNAME           @"LastName"
#define USER_PROFILE_PAYMENTPLAN        @"PaymentPlan"
#define USER_PROFILE_ISEMAILVERIFIED    @"IsEmailVerified"
#define USER_PROFILE_CREATEDDATE        @"CreatedDate"
#define USER_PROFILE_TIMESTAMP          @"TimeStamp"
#define USER_PROFILE_LOGINTYPE          @"LoginType"
#define USER_PROFILE_EMAILID            @"EmailID"
#define USER_PROFILE_PLANID             @"PlanID"
#define USER_PROFILE_STATUS             @"Status"
#define USER_PROFILE_HASPAID            @"HasPaid"
#define USER_PROFILE_DEVICELIMIT        @"DeviceLimit"
#define USER_PROFILE_DEVICECOUNTER      @"DeviceCounter"

@interface User : NSObject

//init
-(id) init;
+ (User *)currentUser;

+ (void)setUserProfile:(NSDictionary *)dict;
+ (NSString *)getUserDataWithParam:(NSString *)key;
+ (BOOL)isUserPaid;
- (void)setUserPaid:(NSString *)value;

//Property
- (void)setUserID:(NSString *)userID;
- (NSString *)userID;

//Device
- (void)setDeviceID:(NSString *)deviceId;
- (NSString *)getDeviceId;

//PrefProperty
- (void)setREMINDERYOUTUBEURL:(NSString *)REMINDERYOUTUBEURL;
- (NSString *)getREMINDERYOUTUBEURL;
- (void)setREMINSERFLAG:(NSString *)REMINSERFLAG;
- (NSString *)getREMINSERFLAG;
- (void)setCURRENCYSYMBOLS:(NSString *)CURRENCYSYMBOLS;
- (NSString *)getCURRENCYSYMBOLS;
- (void)setSTOCKSYMBOLS:(NSString *)STOCKSYMBOLS;
- (NSString *)getSTOCKSYMBOLS;
- (void)setNEWSKEYWORDS:(NSString *)NEWSKEYWORDS;
- (NSString *)getNEWSKEYWORDS;
- (void)setNEWSSPLITFLAG:(BOOL)ISSELECTED;
- (NSString *)getNEWSSPLITFLAG;
- (void)setSTOCKSPLITFLAG:(BOOL)ISSELECTED;
- (NSString *)getSTOCKSPLITFLAG;
- (void)setNEWSTRANSIT:(NSString *)NEWSTRANSIT;
- (NSString *)getNEWSTRANSIT;
- (void)setSTOCkTRANSIT:(NSString *)STOCKTRANSIT;
- (NSString *)getSTOCKTRANSIT;
- (void)setNEWSLOCATION:(NSString *)NEWSLOCATION;
- (NSString *)getNEWSLOCATION;
- (void)setEVENTSEARCHON:(NSString *)EVENTSEARCHON;
- (NSString *)getEVENTSEARCHON;
- (void)setSEARCHWITHIN:(NSString *)SEARCHWITHIN;
- (NSString *)getSEARCHWITHIN;
- (void)setEVENTKEYWORD:(NSString *)EVENTKEYWORD;
- (NSString *)getEVENTKEYWORD;
- (void)setCALENDARVIEW:(NSString *)CALENDARVIEW;
- (NSString *)getCALENDARVIEW;
- (void)setCALENDARVIEW:(NSString *)CALENDARVIEW forDevice:(NSString *)deviceID;
- (NSString *)getCALENDARVIEWforDevice:(NSString *)deviceID;
- (void)setEVENTLOCATION:(NSString *)EVENTLOCATION;
- (NSString *)getEVENTLOCATION;
- (void)setWEBPAGEURL:(NSString *)WEBPAGEURL;
- (NSString *)getWEBPAGEURL;
- (void)setYOUTUBEURL:(NSString *)YOUTUBEURL;
- (NSString *)getYOUTUBEURL;
- (void)setPOSTAMESSAGE:(NSString *)POSTAMESSAGE;
- (NSString *)getPOSTAMESSAGE;
- (void)setEVENTTIMECHOICE:(NSString *)EVENTTIMECHOICE;
- (NSString *)getEVENTTIMECHOICE;
- (void)setEVENTCATEGORY:(NSString *)EVENTCATEGORY;
- (NSString *)getEVENTCATEGORY;
- (void)setWEATHERLOCATION:(NSString *)WEATHERLOCATION;
- (NSString *)getWEATHERLOCATION;
- (void)setCALENDARID:(NSMutableArray *)CALENDARID;
- (NSMutableArray *)getCALENDARID;
- (void)setFBALBUMID:(NSMutableArray *)FBALBUMID;
- (NSMutableArray *)getFBALBUMID;
- (void)setFBALBUMNAME:(NSString *)FBALBUMNAME;
- (NSString *)getFBALBUMNAME;
- (void)setWTZIPCODEIDS:(NSString *)WTZIPCODEIDS;
- (NSString *)getWTZIPCODEIDS;
- (void)setISDIGITAL:(NSString *)iSDIGITAL;
- (NSString *)getISDIGITAL;
- (void)setAUDIOHDMI:(NSString *)HDMI;
- (NSString *)getAUDIOHDMI;
//- (void)setAUDIOJACK:(NSString *)JACK;
//- (NSString *)getAUDIOJACK;
- (void)setSETTINGSTRANSITION:(NSString *)Tran;
- (NSString *)getSETTINGSTRANSITION;
- (void)setSETTINGSREFRESH:(NSString *)Tran;
- (NSString *)getSETTINGSREFRESH;
- (void)setCOMMAND:(NSString *)CMD;
- (void)setCOMMANDCODE:(NSString *)CMDCODE;
- (NSString *)getCOMMAND;
- (NSString *)getCOMMANDCODE;
- (void)setCOLOR:(NSString *)COLOR;
- (void)setZOOM:(NSString *)ZOOM;
- (NSString *)getCOLOR;
- (NSString *)getZOOM;
- (void)setDEVICEVIEW:(NSString *)VIEW;
- (NSString *)getDEVICEVIEW;
- (void)setGOOGLELOGOUT:(NSString *)LOG;
- (NSString *)getGOOGLELOGOUT;
- (void)setFACEBOOKLOGOUT:(NSString *)LOG;
- (NSString *)getFACEBOOKLOGOUT;

- (void)setTokenForFBORGOOGLEPLUS:(NSString *)token;
- (NSString *)getTokenForFBORGOOGLEPLUS;
- (void)setLOGINTYPE:(NSString *)type;
- (NSString *)getLOGINTYPE;

- (void)setWEBURL:(NSString *)url;
- (NSString *)getWEBURL;

//User Utility
- (BOOL)isLogin;
- (void)logoutUser;

- (void)setPIXTRANSITION:(NSString *)Tran;
- (NSString *)getPIXTRANSITION;
- (void)setLoopVideo:(NSString *)value;
- (NSString *)getLoopVideo;
- (void)setMediaToPlay:(NSString *)value;
- (NSString *)getMediaToPlay;

//HELP
- (void)setConsoleOption:(NSInteger)num;
- (NSInteger)getConsoleOption;

@end
