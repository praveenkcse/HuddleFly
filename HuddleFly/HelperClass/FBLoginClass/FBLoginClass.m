//
//  FBLoginClass.m
//  FBVideoSharing
//
//  Created by BMAC on 11/07/16.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import "FBLoginClass.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@implementation FBLoginClass

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
    _strFields = @"id,name,first_name,last_name,email,albums,link,picture.type(large)";
}

- (void)defaultParameter
{
    NSString *strFBAppId = @"428719957301782";
    NSString *strFBHostApp= @"app.logiqfish.com";// @"app.huddlefly.net";//@"huddlefly.co";
    NSString *strFBRedirectURI = @"https://app.logiqfish.com/"; //@"https://app.huddlefly.net/";//@"http://huddlefly.co/";
    NSString *strFBSecret = @"aad78a7285dec5be6ff4df87ba4c9e24";
    
    _strFacebookAppID       = strFBAppId;
    _strFacebookHostApp     = strFBHostApp;
    _strFacebookRedirectURI = strFBRedirectURI;
    _strFacebookSecretKey   = strFBSecret;
}

+ (void)clearCookie
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"FacebookTokenExpiry"];
    [defaults setValue:@"" forKey:@"FacebookToken"];
    [defaults synchronize];
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)authenticationWithFBInBrowser
{
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        
    }
        [FBSession openActiveSessionWithReadPermissions:@[@"email,publish_actions, public_profile,user_photos"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             NSLog(@"Permission :%@",session.permissions);
             
             if (!error && state == FBSessionStateOpen){

//                 if (!error && state == FBSessionStateOpen){
                     NSLog(@"Session opened In Login VC");
                     [self setFBToken:[[[FBSession activeSession] accessTokenData] accessToken]];
                     [self setExpiryDateForToken:[[[FBSession activeSession] accessTokenData] expirationDate]];

                     [self fetchUserLoginDetails];
//                 }
             } else if (state == FBSessionStateClosedLoginFailed) {
                 [[AppDelegate sharedAppDelegate] showToastMessage:@"Login Canceled"];
             } else {
                 [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
             }

             /*
                 NSDictionary *json = nil;
                 NSError *error = nil;
                 if (data) {
                     
                     if([_delegate respondsToSelector:@selector(stopProcessing)])
                         [_delegate stopProcessing];
                     
                     json = [self parametersDictionaryFromQueryString:strData];
                     if (json)
                     {
                         // NSLog(@"Json :%@",json);
                         [self setFBToken:json[@"access_token"]];
                         [self setExpirySecondsForToken:json[@"expires"]];
                         [self fetchUserLoginDetails];
                     }
                     else{
                         NSLog(@"error: %@", error);
                         if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
                             [_delegate finishFetchingWithResponse:nil error:error];
                     }
                 }

             */
             
             
         }];
        
    
    /*[[AppDelegate sharedAppDelegate] gotoMainScreen];*/
}

- (void)authenticationWithFB
{
    
    [self authenticationWithFBInBrowser];
    return;
    
    NSString *strApi = [NSString stringWithFormat:@"https://m.facebook.com/v2.5/dialog/oauth?client_id=%@&client_secret=%@&redirect_uri=%@&scope=%@&response_type=code&display=touch",_strFacebookAppID,_strFacebookSecretKey,_strFacebookRedirectURI,@"email,publish_actions,public_profile,user_photos"];
    strApi = [strApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"string :%@ ",strApi);
    NSURL *url = [[NSURL alloc] initWithString:strApi];
    
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
    web.layer.borderColor = [UIColor colorWithRed:189.0/255.0 green:156.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
    web.layer.borderWidth = 3.0;
    web.clipsToBounds = YES;
    [self addSubview:web];
    
    if([_delegate respondsToSelector:@selector(startProcessing)])
        [_delegate startProcessing];
    
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)closeBtnPressed
{
    [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:0 animations:^{
        
        self.frame = CGRectMake(0, self.frame.size.height+50, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - WebView Delegate

//https://graph.facebook.com/oauth/access_token?client_id=&client_secret=&redirect_uri=&access_token

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Url :%@ host :%@",request.URL, request.URL.host);
    NSURL *url = request.URL;
    if ([url.host isEqualToString:_strFacebookHostApp])
    {
    
        NSDictionary *dict = [self parametersDictionaryFromQueryString:[url query]];
        
        NSString *strCode = dict[@"code"];
        //NSString *strRefresh = @"";
        
        NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&redirect_uri=%@&code=%@&grant_type=authorization_code",_strFacebookAppID,_strFacebookSecretKey,_strFacebookRedirectURI,strCode];
        NSLog(@"Post :%@",post);
        
        NSData *postdata = [post dataUsingEncoding:NSASCIIStringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"graph.facebook.com" forHTTPHeaderField:@"Host"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postdata];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        NSDictionary *json = nil;
        NSError *error = nil;
        if (data) {
            
            if([_delegate respondsToSelector:@selector(stopProcessing)])
                [_delegate stopProcessing];
            
            json = [self parametersDictionaryFromQueryString:strData];
            if (json)
            {
               // NSLog(@"Json :%@",json);
                [self setFBToken:json[@"access_token"]];
                [self setExpirySecondsForToken:json[@"expires"]];
                [self fetchUserLoginDetails];
            }
            else{
                NSLog(@"error: %@", error);
                if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
                    [_delegate finishFetchingWithResponse:nil error:error];
            }
        }
    }else{
        
        if([_delegate respondsToSelector:@selector(stopProcessing)])
            [_delegate stopProcessing];
        
        if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
            [_delegate finishFetchingWithResponse:nil error:nil];
    }
    return YES;
}

- (void)fetchUserLoginDetails
{
    if([_delegate respondsToSelector:@selector(startProcessing)])
        [_delegate startProcessing];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me?fields=%@&access_token=%@",_strFields,[FBLoginClass getFBToken]];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //NSLog(@"Facebook API :%@",strUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *json = nil;
            NSError *error = nil;
            if (data) {
                json = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:&error];
                if(json){
                    NSLog(@"User Login Detail:%@",json);
                    if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
                        [_delegate finishFetchingWithResponse:json error:error];
                }else{
                    if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
                        [_delegate finishFetchingWithResponse:nil error:error];
                }
                
                if([_delegate respondsToSelector:@selector(stopProcessing)])
                    [_delegate stopProcessing];
                
                [self closeBtnPressed];
            }else{
                
                NSLog(@"Request Failed");
                
                if([_delegate respondsToSelector:@selector(stopProcessing)])
                    [_delegate stopProcessing];
                
                if([_delegate respondsToSelector:@selector(finishFetchingWithResponse:error:)])
                    [_delegate finishFetchingWithResponse:nil error:nil];
                
                [self closeBtnPressed];
            }
        });
        
    });
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

- (void)setFBToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"FacebookToken"];
    [defaults synchronize];
}

+ (NSString *)getFBToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"FacebookToken"];
}

- (void)setExpiryDateForToken:(NSDate *)expirationDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:expirationDate forKey:@"FacebookTokenExpiry"];
    [defaults synchronize];
}

- (void)setExpirySecondsForToken:(NSString *)sec
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:sec forKey:@"FacebookTokenExpiry"];
    [defaults synchronize];
}

+ (BOOL)isTokenExpire
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSDate *expdate = [defaults objectForKey:@"FacebookTokenExpiry"];

    if (expdate.description.length == 0)
        return YES;
    
    NSDate* currentDate = [NSDate date];
    
    if (currentDate > expdate)
        return YES;
    else
        return NO;

    
//    int exp = [strEx intValue];
//    if (exp > 120) {
//        return NO;
//    }
//    return YES;
}

@end
