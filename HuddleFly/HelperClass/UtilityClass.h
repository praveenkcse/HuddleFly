
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static int selectedCount = 0;
static int selectLimit = 0;

static UIButton *btnSel;
static id fbOldSelection;

static NSMutableArray *arrPrefernceSel;
static NSMutableArray *arrSelectedBtn ;

@class Preferences;

@interface UtilityClass : NSObject
{
    
}
@property (nonatomic, strong) NSMutableDictionary *transitions;
@property (nonatomic, strong) NSString *defaultTransition;

//init
-(id) init;
+ (UtilityClass *)sharedObject;

+ (int)countIncrement;
+ (int)countDecrement;
+ (void)reset;
+ (void)setSelectionLimit:(int)value;
+ (int)getSelectionLimit;

+ (void)arrayInit;
+ (void)setElementObj:(id)value;
+ (void)setElementControl:(id)value;
+ (id)getElementObjAtIndex:(int)index;
+ (id)getElementControlAtIndex:(int)index;
+ (NSInteger)checkArraySize;
+ (void)removeAllArrayObj;
+ (void)removeObjAtIndex:(int) index;
+ (void)removeObj:(Preferences*) pref;
+ (BOOL)arrayContainsObj:(id)obj;

+ (void)setFbElementObj:(id)value;
+ (void)setFbElementControl:(id)value;
+ (id)getFbElementObj;
+ (id)getFbElementControl;

//Check String Value
+ (NSString *)valueFromResponse:(NSString *)value;
+ (BOOL)valueIsStringAndNotNull:(NSString *)value;
+ (BOOL)checkResponseSuccessOrNot:(id)response;
+ (BOOL)ValueIsNull:(NSString *)value;
+ (NSString *)isNullStringValue:(NSString *)str;
+ (NSDictionary *)dictionaryRemoveNull:(NSDictionary *)dict;

+ (NSString *)scannerTimeStamp:(NSString *)str;
+ (NSString *)scannerTimeStampGetTime:(NSString *)strTimeStampValue;

//Distance convertion methods
-(double)meterToKilometer:(double)meter;
-(double)kilometerToMeter:(double)kilometer;
-(double)meterToMiles:(double)meter;
-(double)milesToMeter:(double)miles;
-(double)kilometerToMiles:(double)kilometer;
-(double)milesToKilometer:(double)miles;


//String Utillity Functions
-(NSString*) trimString:(NSString *)theString;
-(NSString *) removeNull:(NSString *) string;

//Directory Path Methods
- (NSString *)applicationDocumentDirectoryString;
- (NSString *)applicationCacheDirectoryString;
- (NSURL *)applicationDocumentsDirectoryURL;

//Scale and Rotate according to Orientation
- (UIImage *)scaleAndRotateImage:(UIImage *)image;

//Email Validation
-(BOOL)isValidEmailAddress:(NSString *)email;
- (BOOL)isValidURL:(NSString *)strURL;
-(BOOL)isvalidPassword:(NSString *)password;


//UserDefault helper

//Show Alert
-(void)showAlertWithTitle:(NSString *)strTitle andMessage:(NSString *)strMsg;

//datetime helper
- (NSDate *)stringToDate:(NSString *)dateString;
- (NSDate *)stringToDate:(NSString *)dateString withFormate:(NSString *)format;
- (NSString *)DateToString:(NSDate *)date;
-(NSString *)DateToString:(NSDate *)date withFormate:(NSString *)format;
-(NSString *)DateToStringForScanQueue:(NSDate *)date;
-(int)dateDiffrenceFromDateInString:(NSString *)date1 second:(NSString *)date2;
-(int)dateDiffrenceFromDate:(NSDate *)startDate second:(NSDate *)endDate;

//tableview helper
-(void)setTableViewHeightWithNoLine:(UITableView *)tbl;

//baritem helper
-(UIBarButtonItem *)setBackbarButtonWithName:(NSString *)strName;


@end
