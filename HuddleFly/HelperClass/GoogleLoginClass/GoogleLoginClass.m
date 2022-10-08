//
//  GoogleLoginClass.m
//  GoogleCalendar
//
//  Created by BMAC on 11/07/16.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import "GoogleLoginClass.h"
#import "AppDelegate.h"

#import "Constants.h"

//#import <Google/SignIn.h>

#import <GoogleSignIn/GoogleSignIn.h>

@interface GoogleLoginClass() <GIDSignInDelegate, GIDSignInUIDelegate> {
    UIViewController* _fromController;
}

@end

@implementation GoogleLoginClass

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self defaultParameter];
        [self setField];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self defaultParameter];
        [self setField];
    }
    return self;
}

- (void)setField
{
    _strFields = @"id,name,firstname,lastname,email";
}

- (void)defaultParameter
{
    _strGoogleAppID = GoogleCustomKey;
    _strGoogleHostApp = GoogleHostApp;
    _strGoogleRedirectURI = GoogleRedirectUri;
    _strGoogleSecretKey = GoogleSecretKey;
}

+ (void)clearCookie
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"GoogleTokenStart"];
    [defaults setObject:@"" forKey:@"GoogleTokenExpiry"];
    [defaults setValue:@"" forKey:@"GoogleToken"];
    [defaults synchronize];
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
- (void)authenticationWithGoogle:(UIViewController*) fromController {
    
    NSURL *authorizationEndpoint = [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/v2/auth"];
    
    
    // NSString *strUrl =[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?client_id=%@&redirect_uri=%@&scope=https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks https://www.googleapis.com/auth/tasks.readonly https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline",_strGoogleAppID,_strGoogleRedirectURI];
    
    
    //authorizationEndpoint = [NSURL URLWithString:strUrl];
    
    NSURL *tokenEndpoint = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"];
    
//    OIDServiceConfiguration *configuration = [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint tokenEndpoint:tokenEndpoint];
//    
//    // builds authentication request
//    /*
//    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
//                                                                                     clientId:GoogleCustomKey
//                                                                                       scopes:@[OIDScopeOpenID,
//                                                                                                OIDScopeProfile, OIDScopeEmail, @"https://www.googleapis.com/auth/calendar",@"https://www.googleapis.com/auth/calendar.readonly",@"https://www.googleapis.com/auth/tasks",@"https://www.googleapis.com/auth/tasks.readonly",@"https://www.googleapis.com/auth/userinfo.email",@"https://www.googleapis.com/auth/userinfo.profile"]
//                                                                                  redirectURL:[NSURL URLWithString:GoogleRedirectUri]
//                                                                                 responseType:OIDResponseTypeCode
//                                                                         additionalParameters:nil];
//    */
//    ////#define GoogleCustomKey @"704444102907-3na29ol606pdrrhku3fmjs2i78kpeg5e.apps.googleusercontent.com"
//    
//    
//    // builds authentication request
//    /*
//    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
//                                                                                     clientId:GoogleCustomKey
//                                                                                       scopes:@[OIDScopeOpenID,
//                                                                                                OIDScopeProfile, OIDScopeEmail, @"https://www.googleapis.com/auth/calendar",
//                                                                                                @"https://www.googleapis.com/auth/calendar.readonly",
//                                                                                                @"https://www.googleapis.com/auth/tasks",
//                                                                                                @"https://www.googleapis.com/auth/tasks.readonly"]
//                                        
//                                                                                  redirectURL:[NSURL URLWithString:GoogleRedirectUri]
//                                                                                 responseType:OIDResponseTypeCode
//                                                                         additionalParameters:nil];
//    */
//    
//    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
//                                                                                     clientId:GoogleCustomKey
//                                                                                       scopes:@[OIDScopeOpenID,
//                                                                                    OIDScopeProfile,
//                                                                                    OIDScopeEmail,
//                           /* @"audience:server:client_id:704444102907-3na29ol606pdrrhku3fmjs2i78kpeg5e.apps.googleusercontent.com", */
//                            @"https://www.googleapis.com/auth/calendar",@"https://www.googleapis.com/auth/calendar.readonly",@"https://www.googleapis.com/auth/tasks",@"https://www.googleapis.com/auth/tasks.readonly",@"https://www.googleapis.com/auth/userinfo.email",@"https://www.googleapis.com/auth/userinfo.profile", @"https://www.googleapis.com/auth/plus.login"]
//                                                                                  redirectURL:[NSURL URLWithString:GoogleRedirectUri]
//                                                                                 responseType:OIDResponseTypeCode
//                                                                         additionalParameters:@{@"audience":GoogleWebServerKey}];
//    
//    
//    // performs authentication request
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.currentAuthorizationFlow =
//    [OIDAuthState authStateByPresentingAuthorizationRequest:request
//                                   presentingViewController:fromController
//                                                   callback:^(OIDAuthState *_Nullable authState,
//                                                              NSError *_Nullable error) {
//                                                       if (authState) {
//                                                           NSLog(@"Got authorization tokens. Access token: %@",
//                                                                 authState.lastTokenResponse.accessToken);
//                                                           
//                                                           [self setGoogleToken:authState.lastTokenResponse.accessToken];
//                                                           
//                                                           [self setTokenExpirationDate:authState.lastTokenResponse.accessTokenExpirationDate];
//                                                           [self setGoogleRefreshToken:authState.lastTokenResponse.refreshToken];
//                                                           [self fetchUserLoginDetail];
//                                                           
//                                                           [self setAuthState:authState];
//                                                       } else {
//                                                           NSLog(@"Authorization error: %@", [error localizedDescription]);
//                                                           [self setAuthState:nil];
//                                                       }
//                                                   }];
//    
//    
//    
//    
    
    ///////////////////////////////// NEW CODE
    
//    OIDServiceConfiguration *configuration = [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint tokenEndpoint:tokenEndpoint];
//    
//    // builds authentication request
//    OIDAuthorizationRequest *authorizationRequest =
//    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
//                                                  clientId:GoogleCustomKey
//                                                    scopes:@[OIDScopeOpenID,
//                                                             OIDScopeEmail,
//                                                             @"https://www.googleapis.com/auth/calendar",
//                                                             @"https://www.googleapis.com/auth/calendar.readonly",
//                                                             @"https://www.googleapis.com/auth/tasks",
//                                                             @"https://www.googleapis.com/auth/tasks.readonly",
//                                                             @"https://www.googleapis.com/auth/userinfo.email",
//                                                             @"https://www.googleapis.com/auth/userinfo.profile",
//                                                             @"https://www.googleapis.com/auth/plus.login"]
//                                               redirectURL:[NSURL URLWithString:GoogleRedirectUri]
//                                              responseType:OIDResponseTypeCode
//                                      additionalParameters:nil];
//    
//    // performs authentication request
//    OIDAuthorizationUICoordinatorIOS *coordinator = [[OIDAuthorizationUICoordinatorIOS alloc]
//                                                     initWithPresentingViewController: fromController];
//    id<OIDAuthorizationFlowSession> authFlowSession = [OIDAuthorizationService
//                                                       presentAuthorizationRequest:authorizationRequest
//                                                       UICoordinator:coordinator
//                                                       callback:^(OIDAuthorizationResponse *_Nullable authorizationResponse,
//                                                                  NSError *_Nullable authorizationError) {
//                                                           // inspects response and processes further if needed (e.g. authorization
//                                                           // code exchange)
//                                                           if (authorizationResponse) {
//                                                               if ([authorizationRequest.responseType
//                                                                    isEqualToString:OIDResponseTypeCode]) {
//                                                                   // if the request is for the code flow (NB. not hybrid), assumes the
//                                                                   // code is intended for this client, and performs the authorization
//                                                                   // code exchange
//                                                                   
//                                                                   OIDTokenRequest *tokenExchangeRequest =
//                                                                   [[OIDTokenRequest alloc] initWithConfiguration:authorizationRequest.configuration
//                                                                                                        grantType:OIDGrantTypeAuthorizationCode
//                                                                                                authorizationCode:authorizationResponse.authorizationCode
//                                                                                                      redirectURL:authorizationRequest.redirectURL
//                                                                                                         clientID:authorizationRequest.clientID
//                                                                                                     clientSecret:authorizationRequest.clientSecret
//                                                                    
//                                                                                                            scope:authorizationRequest.scope
//                                                                                                     refreshToken:nil
//                                                                                                     codeVerifier:authorizationRequest.codeVerifier
//                                                                                             additionalParameters:@{@"audience":GoogleWebServerKey}];
//                                                                   //tokenExchangeRequest.scope = kAudienceServerClientId;
//                                                                   
//                                                                   [OIDAuthorizationService
//                                                                    performTokenRequest:tokenExchangeRequest
//                                                                    callback:^(OIDTokenResponse *_Nullable tokenResponse,
//                                                                               NSError *_Nullable tokenError) {
//                                                                        OIDAuthState *authState;
//                                                                        if (tokenResponse) {
//                                                                            authState = [[OIDAuthState alloc]
//                                                                                         initWithAuthorizationResponse:
//                                                                                         authorizationResponse
//                                                                                         tokenResponse:tokenResponse];
//                                                                        }
//                                                                        
//                                                                        [self onSignInResponse:authState error:tokenError];
//                                                                    }];
//                                                               } else {
//                                                                   // implicit or hybrid flow (hybrid flow assumes code is not for this
//                                                                   // client)
//                                                                   OIDAuthState *authState = [[OIDAuthState alloc]
//                                                                                              initWithAuthorizationResponse:authorizationResponse];
//                                                                   
//                                                                   [self onSignInResponse:authState error:authorizationError];
//                                                               }
//                                                           } else {
//                                                               [self onSignInResponse:nil error:authorizationError];
//                                                           }
//                                                       }];
//    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.currentAuthorizationFlow = authFlowSession;
    
    //// GIDSignIn code
    
    _fromController = fromController;
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;

    [[GIDSignIn sharedInstance] signIn];
    [[GIDSignIn sharedInstance] signInSilently];
    
}

- (void)onSignInResponse:(OIDAuthState *)authState error: (NSError *)error {
    NSLog(@"STATE: %@ - %@", authState, error);
    
    if (authState) {
        NSLog(@"Got authorization tokens. Access token: %@",
              authState.lastTokenResponse.accessToken);
        
        [self setGoogleToken:authState.lastTokenResponse.accessToken];
        
        [self setTokenExpirationDate:authState.lastTokenResponse.accessTokenExpirationDate];
        [self setGoogleRefreshToken:authState.lastTokenResponse.refreshToken];
        [self fetchUserLoginDetail];
        
        [self setAuthState:authState];
    } else {
        NSLog(@"Authorization error: %@", [error localizedDescription]);
        [self setAuthState:nil];
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    // user.serverAuthCode now has a server authorization code!
    
    if (error) {
        NSLog(@"Authorization error: %@", [error localizedDescription]);
    } else {
        NSLog(@"Got authorization tokens. Access token: %@", user.authentication.accessToken);
        NSLog(@"Got server auth code: %@", user.serverAuthCode);

        [self setGoogleServerAuthCode:user.serverAuthCode];
        [self setGoogleToken:user.authentication.accessToken];
        
        [self setTokenExpirationDate:user.authentication.accessTokenExpirationDate];
        
        //[self setGoogleRefreshToken:user.authentication.refreshToken];
        [self setGoogleRefreshToken:@""];
        
        [self fetchUserLoginDetail];
        
        [signIn signOut];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [_fromController presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [_fromController dismissViewControllerAnimated:YES completion:nil];
}

/*
 - (void)authenticationWithGoogle
 {
 NSString *strUrl =[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?client_id=%@&redirect_uri=%@&scope=https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks https://www.googleapis.com/auth/tasks.readonly https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline",_strGoogleAppID,_strGoogleRedirectURI];
 
 strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 NSURL *url = [[NSURL alloc] initWithString:strUrl];
 
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
 [view setBackgroundColor:[UIColor lightGrayColor]];
 [self addSubview:view];
 
 UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 20,70, 25)];
 btnBack.titleLabel.font = [UIFont systemFontOfSize:14.0];
 [btnBack setTitle:@"Close"forState:UIControlStateNormal];
 [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 [btnBack addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
 btnBack.backgroundColor = [UIColor whiteColor];
 btnBack.layer.cornerRadius = 6.0;
 btnBack.layer.shadowColor = [UIColor blackColor].CGColor;
 btnBack.layer.shadowOffset = CGSizeMake(5.0, 5.0);
 btnBack.clipsToBounds = YES;
 [view addSubview:btnBack];
 
 UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, view.frame.size.height,self.frame.size.width, self.frame.size.height-view.frame.size.height)];
 web.delegate = self;
 web.tag = 1000;
 [self addSubview:web];
 
 if([_delegate respondsToSelector:@selector(startProcessingGoogle)])
 [_delegate startProcessingGoogle];
 
 [web loadRequest:[NSURLRequest requestWithURL:url]];
 }
 */
- (void)closeBtnPressed
{
    [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:0 animations:^{
        
        self.frame = CGRectMake(0, self.frame.size.height+50, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 #pragma mark - WebView Delegate.
 
 -(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
 {
 NSURL *url = request.URL;
 
 if ([url.host isEqualToString:_strGoogleHostApp])
 {
 NSDictionary *dict = [self parametersDictionaryFromQueryString:[url query]];
 //NSLog(@"dictionary :%@",dict);
 NSString *strCode = dict[@"code"];
 NSString *post = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code",strCode,_strGoogleAppID,_strGoogleSecretKey,_strGoogleRedirectURI];
 
 [self setGoogleCode:strCode];
 
 NSData *postdata = [post dataUsingEncoding:NSASCIIStringEncoding];
 NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
 [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"]]];
 [request setHTTPMethod:@"POST"];
 [request setValue:@"accounts.google.com" forHTTPHeaderField:@"Host"];
 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 [request setHTTPBody:postdata];
 
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSDictionary *json = nil;
 NSError *error = nil;
 
 if (data) {
 
 if([_delegate respondsToSelector:@selector(stopProcessingGoogle)])
 [_delegate stopProcessingGoogle];
 
 json = [NSJSONSerialization JSONObjectWithData:data
 options:NSJSONReadingAllowFragments
 error:&error];
 if (json)
 {
 //NSLog(@"json Data :%@",json);
 
 [self setGoogleToken:json[@"access_token"]];
 [self setExpirySecondsForToken:json[@"expires_in"]];
 [self setGoogleRefreshToken:json[@"refresh_token"]];
 [self fetchUserLoginDetail];
 }
 else{
 NSLog(@"error: %@", error);
 if([_delegate respondsToSelector:@selector(finishGoogleFetchingWithResponse:error:)])
 [_delegate finishGoogleFetchingWithResponse:nil error:error];
 }
 }else{
 
 if([_delegate respondsToSelector:@selector(stopProcessingGoogle)])
 [_delegate stopProcessingGoogle];
 
 if([_delegate respondsToSelector:@selector(finishGoogleFetchingWithResponse:error:)])
 [_delegate finishGoogleFetchingWithResponse:nil error:nil];
 }
 }
 else if (!url.host){
 if([_delegate respondsToSelector:@selector(stopProcessingGoogle)])
 [_delegate stopProcessingGoogle];
 }
 return YES;
 }
 */

-(void)fetchUserLoginDetail
{
    if([_delegate respondsToSelector:@selector(startProcessingGoogle)])
        [_delegate startProcessingGoogle];
    
    NSString *strApi = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me?&key=%@&access_token=%@",_strGoogleAppID,[GoogleLoginClass getGoogleToken]];//fields=name,id
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strApi]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *json = nil;
            NSError *error = nil;
            if (data) {
                json = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:&error];
                if(json){
                    NSLog(@"User Login Detail:%@",json);
                    if([_delegate respondsToSelector:@selector(finishGoogleFetchingWithResponse:error:)])
                        [_delegate finishGoogleFetchingWithResponse:json error:error];
                }else{
                    if([_delegate respondsToSelector:@selector(finishGoogleFetchingWithResponse:error:)])
                        [_delegate finishGoogleFetchingWithResponse:nil error:error];
                }
                
                if([_delegate respondsToSelector:@selector(stopProcessingGoogle)])
                    [_delegate stopProcessingGoogle];
                
                [self closeBtnPressed];
            }else{
                
                NSLog(@"Request Failed");
                
                if([_delegate respondsToSelector:@selector(stopProcessingGoogle)])
                    [_delegate stopProcessingGoogle];
                
                if([_delegate respondsToSelector:@selector(finishGoogleFetchingWithResponse:error:)])
                    [_delegate finishGoogleFetchingWithResponse:nil error:nil];
                
                [self closeBtnPressed];
            }
        });
        
    });
}


- (void)setGoogleToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"GoogleToken"];
    [defaults synchronize];
}

+ (NSString *)getGoogleToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"GoogleToken"];
}

- (void)setTokenExpirationDate:(NSDate *)expirationDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:expirationDate forKey:@"GoogleTokenExpiry"];
    [defaults synchronize];
}

- (void)setExpirySecondsForToken:(NSString *)sec {
    
}
+ (BOOL)isTokenExpire
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *expdate = [defaults objectForKey:@"GoogleTokenExpiry"];
    
    if (expdate.description.length == 0)
        return YES;
    
    NSDate* currentDate = [NSDate date];
    
    if (currentDate > expdate)
        return YES;
    else
        return NO;
    
    
    NSString *strEx = [defaults stringForKey:@"GoogleTokenExpiry"];
    NSString *strDate = [defaults stringForKey:@"GoogleTokenStart"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *startDate = [formatter dateFromString:strDate];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSDate *endDate = [formatter dateFromString:str];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    time += 120;
    
    int exp = [strEx intValue];
    
    if(exp > time){
        return NO;
    }
    return YES;
}

- (void)setGoogleRefreshToken:(NSString *)strRefreshToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(strRefreshToken)
        [defaults setValue:strRefreshToken forKey:@"GoogleRefreshToken"];
    else
        [defaults setValue:@"" forKey:@"GoogleRefreshToken"];
    [defaults synchronize];
}

+ (NSString *)getGoogleRefreshToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"GoogleRefreshToken"];
}


- (void)setGoogleServerAuthCode:(NSString *)authCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:authCode forKey:@"GoogleServerAuthCode"];
    [defaults synchronize];
}

+ (NSString *)getGoogleServerAuthCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"GoogleServerAuthCode"];
}

- (void)setGoogleCode:(NSString *)strCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:strCode forKey:@"Google_Code"];
    [defaults synchronize];
}

+ (NSString *)getGoogleCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"Google_Code"];
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    return md;
}


@end
