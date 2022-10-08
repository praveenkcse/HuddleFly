//
//  User.m
//  Flabom
//
//  Created by Jignesh on 14/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "User.h"
#import "Constants.h"

#define UD_USERID                   @"userID"
#define UD_DEVICEID                 @"deviceID"

#define UD_ISDIGITAL                @"IsDigital"
#define UD_WTZIPCODEIDS             @"WTZipCodeIDs"
#define UD_FBALBUMID                @"FBAlbumID"
#define UD_FBALBUMNAME              @"FBAlbumName"
#define UD_CALENDARID               @"CalendarID"
#define UD_WEATHERLOCATION          @"WeatherLocation"
#define UD_EVENTCATEGORY            @"EventCategory"
#define UD_EVENTTIMECHOICE          @"EventTimeChoice"
#define UD_POSTAMESSAGE             @"PostAMessage"
#define UD_YOUTUBEURL               @"YouTubeURL"
#define UD_WEBPAGEURL               @"WebPageURL"
#define UD_EVENTLOCATION            @"EventLocation"
#define UD_CALENDARVIEW             @"CalendarView"
#define UD_EVENTKEYWORD             @"EventKeyWord"
#define UD_SEARCHWITHIN             @"SearchWithIn"
#define UD_EVENTSEARCHON            @"EventSearchOn"
#define UD_NEWSLOCATION             @"NewsLocation"
#define UD_NEWSTRANSIT              @"NewsTransit"
#define UD_STOCKTRANSIT             @"StockTransit"
#define UD_NEWSKEYWORDS             @"NewsKeyWords"
#define UD_NEWSSPLITFLAG            @"NewsSplitFlag"
#define UD_STOCKSPLITFLAG           @"StockSplitFlag"
#define UD_AUDIOHDMI                @"AudioHDMI"
#define UD_LOOPVIDEO                @"LoopVideo"
#define UD_MEDIATOPLAY              @"MediaToPlay"

#define UD_AUDIOJACK                @"AudioJack"
#define UD_SETTINGSTRANSITION       @"SettingsTransition"
#define UD_PIXTRANSITION            @"PictureTransition"

#define UD_SETTINGSREFRESH          @"SettingsRefresh"
#define UD_COMMAND                  @"Command"
#define UD_COMMANDCODE              @"CommandCode"
#define UD_COLOR                    @"Colors"
#define UD_ZOOM                     @"DeviceZoom"
#define UD_DEVICEVIEW               @"DeviceView"
#define UD_GOOGLELOGOUT             @"Google_Logout"
#define UD_FACEBOOKLOGOUT           @"Facebook_Logout"
#define UD_ACCESSTOKEN              @"Access_Token"
#define UD_ACCOUNTTYPE              @"Account_Type"

#define UD_STOCKSYMBOLS             @"StockSymbols"
#define UD_CURRENCYSYMBOLS          @"CurrencySymbols"
#define UD_REMINSERFLAG             @"ReminderFlag"
#define UD_REMINDERYOUTUBEURL       @"ReminderYouTubeURL"

#define UD_HASPAID                  @"HasPaid"

#define UD_WEBURL                   @"WebURL"

#define UD_USER_DATA                @"USER_DATA"

@implementation User

#pragma mark - Init And Shared Object

-(id) init{
    if((self = [super init])) {
        
    }
    return self;
}

+ (User *)currentUser
{
    static User *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[User alloc] init];
    });
    return obj;
}

+ (void)setUserProfile:(NSDictionary *)dict
{
    if(dict){
        
        NSMutableDictionary *dictMutable = [dict mutableCopy];
        [dictMutable removeObjectsForKeys:[dict allKeysForObject:[NSNull null]]];

        
        [[NSUserDefaults standardUserDefaults] setObject:dictMutable forKey:UD_USER_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_USER_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getUserDataWithParam:(NSString *)key
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UD_USER_DATA];
    if (dict){
        NSString *strValue = [NSString stringWithFormat:@"%@",[dict valueForKey:key]];
        if(strValue){
            return strValue;
        }
    }
    return @"";
}

+ (BOOL)isUserPaid
{
    NSString *str = [self getUserDataWithParam:UD_HASPAID];
    if(str && [str isEqualToString:@"1"]){
        return YES;
    }
    return NO;
}

- (void)setUserPaid:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:UD_HASPAID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -  User Data

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:UD_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_USERID];
}

#pragma mark - Device Data

- (void)setDeviceID:(NSString *)deviceId{
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:UD_DEVICEID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDeviceId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_DEVICEID];
}

#pragma mark -  Pref Data

- (void)setREMINDERYOUTUBEURL:(NSString *)REMINDERYOUTUBEURL {
    [[NSUserDefaults standardUserDefaults] setObject:REMINDERYOUTUBEURL forKey:UD_REMINDERYOUTUBEURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getREMINDERYOUTUBEURL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_REMINDERYOUTUBEURL] == nil) {
        [self setREMINDERYOUTUBEURL:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_REMINDERYOUTUBEURL];
}

- (void)setREMINSERFLAG:(NSString *)REMINSERFLAG {
    [[NSUserDefaults standardUserDefaults] setObject:REMINSERFLAG forKey:UD_REMINSERFLAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getREMINSERFLAG {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_REMINSERFLAG] == nil) {
        [self setREMINSERFLAG:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_REMINSERFLAG];
}

- (void)setCURRENCYSYMBOLS:(NSString *)CURRENCYSYMBOLS {
    [[NSUserDefaults standardUserDefaults] setObject:CURRENCYSYMBOLS forKey:UD_CURRENCYSYMBOLS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getCURRENCYSYMBOLS {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_CURRENCYSYMBOLS] == nil) {
        [self setCURRENCYSYMBOLS:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_CURRENCYSYMBOLS];
}

- (void)setSTOCKSYMBOLS:(NSString *)STOCKSYMBOLS {
    [[NSUserDefaults standardUserDefaults] setObject:STOCKSYMBOLS forKey:UD_STOCKSYMBOLS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getSTOCKSYMBOLS {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_STOCKSYMBOLS] == nil) {
        [self setSTOCKSYMBOLS:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_STOCKSYMBOLS];
}

- (void)setNEWSKEYWORDS:(NSString *)NEWSKEYWORDS {
    [[NSUserDefaults standardUserDefaults] setObject:NEWSKEYWORDS forKey:UD_NEWSKEYWORDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getNEWSKEYWORDS {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSKEYWORDS] == nil) {
        [self setNEWSKEYWORDS:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSKEYWORDS];
}


//Added by - Praveen
- (NSString *)getNEWSSPLITFLAG {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UD_NEWSSPLITFLAG] == false) {
        [self setNEWSSPLITFLAG:false];
    }
    
    NSString * isFlagOn = [NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] boolForKey:UD_NEWSSPLITFLAG]];
    return isFlagOn;
}

- (void)setNEWSSPLITFLAG:(BOOL)ISSELECTED {
    [[NSUserDefaults standardUserDefaults] setBool:ISSELECTED forKey:UD_NEWSSPLITFLAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getSTOCKSPLITFLAG {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UD_STOCKSPLITFLAG] == false) {
        [self setSTOCKSPLITFLAG:false];
    }
    NSString * isFlagOn = [NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] boolForKey:UD_STOCKSPLITFLAG]];
    return isFlagOn;
}

- (void)setSTOCKSPLITFLAG:(BOOL)ISSELECTED {
    [[NSUserDefaults standardUserDefaults] setBool:ISSELECTED forKey:UD_STOCKSPLITFLAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNEWSTRANSIT:(NSString *)NEWSTRANSIT {
    [[NSUserDefaults standardUserDefaults] setObject:NEWSTRANSIT forKey:UD_NEWSTRANSIT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getNEWSTRANSIT {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSTRANSIT] == nil) {
        [self setNEWSTRANSIT:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSTRANSIT];
}

- (void)setSTOCkTRANSIT:(NSString *)STOCKTRANSIT {
    [[NSUserDefaults standardUserDefaults] setObject:STOCKTRANSIT forKey:UD_STOCKTRANSIT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getSTOCKTRANSIT {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_STOCKTRANSIT] == nil) {
        [self setSTOCkTRANSIT:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_STOCKTRANSIT];
}

//end

- (void)setNEWSLOCATION:(NSString *)NEWSLOCATION {
    [[NSUserDefaults standardUserDefaults] setObject:NEWSLOCATION forKey:UD_NEWSLOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getNEWSLOCATION {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSLOCATION] == nil) {
        [self setNEWSLOCATION:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_NEWSLOCATION];
}

- (void)setEVENTSEARCHON:(NSString *)EVENTSEARCHON {
    [[NSUserDefaults standardUserDefaults] setObject:EVENTSEARCHON forKey:UD_EVENTSEARCHON];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getEVENTSEARCHON {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTSEARCHON] == nil) {
        [self setEVENTSEARCHON:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTSEARCHON];
}

- (void)setSEARCHWITHIN:(NSString *)SEARCHWITHIN {
    [[NSUserDefaults standardUserDefaults] setObject:SEARCHWITHIN forKey:UD_SEARCHWITHIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getSEARCHWITHIN {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_SEARCHWITHIN] == nil) {
        [self setSEARCHWITHIN:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_SEARCHWITHIN];
}

- (void)setEVENTKEYWORD:(NSString *)EVENTKEYWORD {
    [[NSUserDefaults standardUserDefaults] setObject:EVENTKEYWORD forKey:UD_EVENTKEYWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getEVENTKEYWORD {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTKEYWORD] == nil) {
        [self setEVENTKEYWORD:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTKEYWORD];
}

- (void)setCALENDARVIEW:(NSString *)CALENDARVIEW {
    [[NSUserDefaults standardUserDefaults] setObject:CALENDARVIEW forKey:UD_CALENDARVIEW];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getCALENDARVIEW {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_CALENDARVIEW] == nil) {
        [self setCALENDARVIEW:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_CALENDARVIEW];
}

- (void)setCALENDARVIEW:(NSString *)CALENDARVIEW forDevice:(NSString *)deviceID {
    NSString *key = [NSString stringWithFormat:@"%@_%@", deviceID, UD_CALENDARVIEW];
    
    [[NSUserDefaults standardUserDefaults] setObject:CALENDARVIEW forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getCALENDARVIEWforDevice:(NSString *)deviceID {
    NSString *key = [NSString stringWithFormat:@"%@_%@", deviceID, UD_CALENDARVIEW];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        [self setCALENDARVIEW:@"" forDevice:deviceID];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setEVENTLOCATION:(NSString *)EVENTLOCATION {
    [[NSUserDefaults standardUserDefaults] setObject:EVENTLOCATION forKey:UD_EVENTLOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getEVENTLOCATION {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTLOCATION] == nil) {
        [self setEVENTLOCATION:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTLOCATION];
}

- (void)setWEBPAGEURL:(NSString *)WEBPAGEURL {
    [[NSUserDefaults standardUserDefaults] setObject:WEBPAGEURL forKey:UD_WEBPAGEURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getWEBPAGEURL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_WEBPAGEURL] == nil) {
        [self setWEBPAGEURL:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_WEBPAGEURL];
}

- (void)setYOUTUBEURL:(NSString *)YOUTUBEURL {
    [[NSUserDefaults standardUserDefaults] setObject:YOUTUBEURL forKey:UD_YOUTUBEURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getYOUTUBEURL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_YOUTUBEURL] == nil) {
        [self setYOUTUBEURL:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_YOUTUBEURL];
}

- (void)setPOSTAMESSAGE:(NSString *)POSTAMESSAGE {
    [[NSUserDefaults standardUserDefaults] setObject:POSTAMESSAGE forKey:UD_POSTAMESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getPOSTAMESSAGE {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_POSTAMESSAGE] == nil) {
        [self setPOSTAMESSAGE:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_POSTAMESSAGE];
}

- (void)setEVENTTIMECHOICE:(NSString *)EVENTTIMECHOICE {
    [[NSUserDefaults standardUserDefaults] setObject:EVENTTIMECHOICE forKey:UD_EVENTTIMECHOICE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getEVENTTIMECHOICE {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTTIMECHOICE] == nil) {
        [self setEVENTTIMECHOICE:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTTIMECHOICE];
}

- (void)setEVENTCATEGORY:(NSString *)EVENTCATEGORY {
    [[NSUserDefaults standardUserDefaults] setObject:EVENTCATEGORY forKey:UD_EVENTCATEGORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getEVENTCATEGORY {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTCATEGORY] == nil) {
        [self setEVENTCATEGORY:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_EVENTCATEGORY];
}

- (void)setWEATHERLOCATION:(NSString *)WEATHERLOCATION {
    [[NSUserDefaults standardUserDefaults] setObject:WEATHERLOCATION forKey:UD_WEATHERLOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getWEATHERLOCATION {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_WEATHERLOCATION] == nil) {
        [self setWEATHERLOCATION:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_WEATHERLOCATION];
}

- (void)setCALENDARID:(NSMutableArray *)CALENDARID {
    
    //NSMutableArray *arr = [self getCALENDARID];
    //[arr addObject:CALENDARID];
    
    NSString* calendarkey = [NSString stringWithFormat:@"%@%@", UD_CALENDARID,[[User currentUser] getDeviceId]];
    
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_CALENDARID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:calendarkey];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
  //  [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:CALENDARID] forKey:UD_CALENDARID];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:CALENDARID] forKey:calendarkey];

    [[NSUserDefaults standardUserDefaults] synchronize];
    /*
    [[NSUserDefaults standardUserDefaults] setObject:CALENDARID forKey:UD_CALENDARID];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
}
- (NSMutableArray *)getCALENDARID {
    /*if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_CALENDARID] == nil) {
        [self setCALENDARID:@""];
    }*/
    
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];
    NSString* calendarkey = [NSString stringWithFormat:@"%@%@", UD_CALENDARID,[[User currentUser] getDeviceId]];

   // NSData *dataRepresentingSavedArray = [[NSUserDefaults standardUserDefaults] objectForKey:UD_CALENDARID];

    NSData *dataRepresentingSavedArray = [[NSUserDefaults standardUserDefaults] objectForKey:calendarkey];

    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
    }
    return objectArray;
}

- (void)setCALENDARDICTIONARY:(NSDictionary *)Calender
{
    NSString* calendarkey = [NSString stringWithFormat:@"%@%@", UD_CALENDARID,[[User currentUser] getDeviceId]];

   // [[NSUserDefaults standardUserDefaults] setObject:Calender forKey:UD_CALENDARID];
    [[NSUserDefaults standardUserDefaults] setObject:Calender forKey:calendarkey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFBALBUMID:(NSMutableArray *)FBALBUMID {
   /* [[NSUserDefaults standardUserDefaults] setObject:FBALBUMID forKey:UD_FBALBUMID];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
    
    NSString* facebookkey = [NSString stringWithFormat:@"%@%@", UD_FBALBUMID,[[User currentUser] getDeviceId]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:facebookkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:FBALBUMID] forKey:facebookkey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (NSMutableArray *)getFBALBUMID {
    /*if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_FBALBUMID] == nil) {
        [self setFBALBUMID:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_FBALBUMID];*/
    
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];
    NSString* facebookkey = [NSString stringWithFormat:@"%@%@", UD_FBALBUMID,[[User currentUser] getDeviceId]];

    NSData *dataRepresentingSavedArray = [[NSUserDefaults standardUserDefaults] objectForKey:facebookkey];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
    }
    return objectArray;
}

- (void)setFBALBUMNAME:(NSString *)FBALBUMNAME {
    [[NSUserDefaults standardUserDefaults] setObject:FBALBUMNAME forKey:UD_FBALBUMNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getFBALBUMNAME {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_FBALBUMNAME] == nil) {
        [self setFBALBUMNAME:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_FBALBUMNAME];
}

- (void)setWTZIPCODEIDS:(NSString *)WTZIPCODEIDS {
    [[NSUserDefaults standardUserDefaults] setObject:WTZIPCODEIDS forKey:UD_WTZIPCODEIDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getWTZIPCODEIDS {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_WTZIPCODEIDS] == nil) {
        [self setWTZIPCODEIDS:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_WTZIPCODEIDS];
}

- (void)setISDIGITAL:(NSString *)iSDIGITAL {
    [[NSUserDefaults standardUserDefaults] setObject:iSDIGITAL forKey:UD_ISDIGITAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getISDIGITAL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_ISDIGITAL] == nil) {
        [self setISDIGITAL:@"0"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_ISDIGITAL];
}

- (void)setAUDIOHDMI:(NSString *)HDMI
{
    [[NSUserDefaults standardUserDefaults] setObject:HDMI forKey:UD_AUDIOHDMI];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getAUDIOHDMI
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_AUDIOHDMI] == nil) {
        [self setAUDIOHDMI:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_AUDIOHDMI];
}

/*- (void)setAUDIOJACK:(NSString *)JACK
{
    [[NSUserDefaults standardUserDefaults] setObject:JACK forKey:UD_AUDIOJACK];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getAUDIOJACK
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_AUDIOJACK] == nil) {
        [self setAUDIOJACK:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_AUDIOJACK];
}*/

- (void)setSETTINGSTRANSITION:(NSString *)Tran
{
    [[NSUserDefaults standardUserDefaults] setObject:Tran forKey:UD_SETTINGSTRANSITION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getSETTINGSTRANSITION
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_SETTINGSTRANSITION] == nil) {
        [self setSETTINGSTRANSITION:@"10"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_SETTINGSTRANSITION];
}

- (void)setPIXTRANSITION:(NSString *)Tran
{
    [[NSUserDefaults standardUserDefaults] setObject:Tran forKey:UD_PIXTRANSITION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getPIXTRANSITION
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_PIXTRANSITION] == nil) {
        [self setPIXTRANSITION:@"5"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_PIXTRANSITION];
}

- (void)setLoopVideo:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:UD_LOOPVIDEO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getLoopVideo
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_LOOPVIDEO] == nil) {
        [self setLoopVideo:@"0"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_LOOPVIDEO];
}

- (void)setMediaToPlay:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:UD_MEDIATOPLAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getMediaToPlay
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_MEDIATOPLAY] == nil) {
        [self setMediaToPlay:@"1"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_MEDIATOPLAY];
}


- (void)setSETTINGSREFRESH:(NSString *)Tran
{
    [[NSUserDefaults standardUserDefaults] setObject:Tran forKey:UD_SETTINGSREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getSETTINGSREFRESH
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_SETTINGSREFRESH] == nil) {
        [self setSETTINGSREFRESH:@"5"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_SETTINGSREFRESH];
}

- (void)setCOMMAND:(NSString *)CMD
{
    
    [[NSUserDefaults standardUserDefaults] setObject:CMD forKey:UD_COMMAND];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCOMMANDCODE:(NSString *)CMDCODE{
    [[NSUserDefaults standardUserDefaults] setObject:CMDCODE forKey:UD_COMMANDCODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCOMMAND
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_COMMAND] == nil) {
        [self setCOMMAND:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_COMMAND];
}

- (NSString *)getCOMMANDCODE{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_COMMANDCODE] == nil) {
        [self setCOMMAND:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_COMMANDCODE];
}

- (void)setCOLOR:(NSString *)COLOR
{
    [[NSUserDefaults standardUserDefaults] setObject:COLOR forKey:UD_COLOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setZOOM:(NSString *)ZOOM
{
    [[NSUserDefaults standardUserDefaults] setObject:ZOOM forKey:UD_ZOOM];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCOLOR
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_COLOR] == nil) {
        [self setCOLOR:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_COLOR];
}

- (NSString *)getZOOM
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_ZOOM] == nil) {
        [self setZOOM:@""];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_ZOOM];
}

- (void)setDEVICEVIEW:(NSString *)VIEW
{
    [[NSUserDefaults standardUserDefaults] setObject:VIEW forKey:UD_DEVICEVIEW];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getDEVICEVIEW
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_DEVICEVIEW] == nil) {
        [self setDEVICEVIEW:@"1"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_DEVICEVIEW];
}

- (void)setGOOGLELOGOUT:(NSString *)LOG{
    [[NSUserDefaults standardUserDefaults] setObject:LOG forKey:UD_GOOGLELOGOUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getGOOGLELOGOUT{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_GOOGLELOGOUT] == nil) {
        [self setGOOGLELOGOUT:@"1"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_GOOGLELOGOUT];
}

- (void)setFACEBOOKLOGOUT:(NSString *)LOG{
    [[NSUserDefaults standardUserDefaults] setObject:LOG forKey:UD_FACEBOOKLOGOUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getFACEBOOKLOGOUT{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_FACEBOOKLOGOUT] == nil) {
        [self setFACEBOOKLOGOUT:@"1"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_FACEBOOKLOGOUT];
}

- (void)setTokenForFBORGOOGLEPLUS:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:UD_ACCESSTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getTokenForFBORGOOGLEPLUS{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_ACCESSTOKEN] == nil) {
        [self setTokenForFBORGOOGLEPLUS:@"0"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_ACCESSTOKEN];
}

- (void)setLOGINTYPE:(NSString *)type
{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:UD_ACCOUNTTYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLOGINTYPE{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_ACCOUNTTYPE] == nil) {
        [self setLOGINTYPE:@"0"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:UD_ACCOUNTTYPE];
}

#pragma mark - POST A WEBSITE

- (void)setWEBURL:(NSString *)url
{
    if(url.length == 0)
        return;
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:UD_WEBURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getWEBURL
{
    NSString *strWebUrl = [[NSUserDefaults standardUserDefaults] objectForKey:UD_WEBURL];
    if(strWebUrl)
        return strWebUrl;
    return @"";
}

#pragma mark - User Utility

- (BOOL)isLogin {
    BOOL isLogin = NO;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UD_USERID];
    if (userID != nil && ![userID isEqualToString:@""]) {
        isLogin = YES;
    }
    return isLogin;
}

- (void)logoutUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Help
- (void)setConsoleOption:(NSInteger)num
{
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"HELP_INDEX_CONSOLE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getConsoleOption{
   return [[NSUserDefaults standardUserDefaults] integerForKey:@"HELP_INDEX_CONSOLE"];
}

@end
