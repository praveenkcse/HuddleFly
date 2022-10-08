//
//  GoogleLoginClass.h
//  GoogleCalendar
//
//  Created by BMAC on 11/07/16.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppAuth.h"


//New Google Key by Rajinder:

//#define GoogleCustomKey @"704444102907-pnrke9u3ok6t22254ihdor8hkf6cmlgu.apps.googleusercontent.com"
//#define GoogleRedirectUri @"com.googleusercontent.apps.704444102907-pnrke9u3ok6t22254ihdor8hkf6cmlgu:/oauthredirect"
//#define GoogleHostApp @"localhost"
//#define GoogleSecretKey @"5sirYqDUJWybm5XbOjUfWW7u"
//#define GoogleWebServerKey @"704444102907-3na29ol606pdrrhku3fmjs2i78kpeg5e.apps.googleusercontent.com"

//Super Key:
//#define GoogleCustomKey @"704444102907-3na29ol606pdrrhku3fmjs2i78kpeg5e.apps.googleusercontent.com"
//#define GoogleRedirectUri @"com.huddlefly.app:/oauth2redirect"
//#define GoogleHostApp @"http://localhost/urn:ietf:wg:oauth:2.0:oob"


//#define kClientID @"200751746113-qp0480u048qa6itasv4r5bht8p3ts4pd.apps.googleusercontent.com"

/*! @brief The OAuth redirect URI for the client @c kClientID.
 @discussion With Google, the scheme of the redirect URI is the reverse DNS notation of the
 client ID. This scheme must be registered as a scheme in the project's Info
 property list ("CFBundleURLTypes" plist key). Any path component will work, we use
 'oauthredirect' here to help disambiguate from any other use of this scheme.
 */
//#define kRedirectURI @"com.googleusercontent.apps.200751746113-qp0480u048qa6itasv4r5bht8p3ts4pd:/oauthredirect"




@protocol GoogleLoginClassDelegate <NSObject>
@optional
- (void)startProcessingGoogle;
- (void)stopProcessingGoogle;
- (void)finishGoogleFetchingWithResponse:(NSDictionary *)dict error:(NSError *)err;

@end

@interface GoogleLoginClass : UIView<UIWebViewDelegate>

@property (nonatomic , retain) NSString *strGoogleSecretKey;
@property (nonatomic , retain) NSString *strGoogleAppID;
@property (nonatomic , retain) NSString *strGoogleRedirectURI;
@property (nonatomic , retain) NSString *strGoogleHostApp;
@property (nonatomic , retain) NSString *strFields;

@property (nonatomic , weak)id<GoogleLoginClassDelegate> delegate;
@property(nonatomic, strong, nullable) OIDAuthState *authState;


+ (void)clearCookie;
+ (NSString *)getGoogleServerAuthCode;
+ (NSString *)getGoogleRefreshToken;
+ (NSString *)getGoogleToken;
+ (BOOL)isTokenExpire;
+ (NSString *)getGoogleCode;

- (void)closeBtnPressed;
- (void)setExpirySecondsForToken:(NSString *)sec;
- (void)fetchUserLoginDetail;
- (void)authenticationWithGoogle:(UIViewController*) fromController;
- (void)authenticationWithGoogle;

@end
