//
//  LoginVC.m
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "LoginVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Global.h"

@implementation LoginVC

#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _facebookBtn.tag = 1;
    _emailBtn.tag = 1;
    _googleBtn.tag = 1;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [Global roundBorderSet:_facebookBtn];
    [Global roundBorderSet:_emailBtn];
    [Global roundBorderSet:_googleBtn];
    

}

#pragma mark - Action

- (void)getUserIdForFbAndGoogleUser
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[FBSession activeSession] accessTokenData] forKey:kAPI_PARAM_ACCESSTOKEN];
    [dictParam setObject:[[FBSession activeSession] accessTokenData] forKey:kAPI_PARAM_ACCESSTOKEN];
    
    [afn getDataFromPath:kAPI_PATH_SAVEGOOGLEORFBUSER withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)onClickFB:(id)sender {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        

        [FBSession.activeSession closeAndClearTokenInformation];
        
        
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile,email,user_photos"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             NSLog(@"Permission :%@",session.permissions);
             
             if (!error && state == FBSessionStateOpen){
                 NSLog(@"Session opened In Login VC");
                 [[User currentUser] setFACEBOOKLOGOUT:@"1"];
                 [[User currentUser] setLOGINTYPE:@"FB"];
                 [self getUserNameFacebook];
             }
             
             //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             //[appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
    
    /*[[AppDelegate sharedAppDelegate] gotoMainScreen];*/
}

- (void)getUserNameFacebook
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    FBRequest *req = [FBRequest requestWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,first_name,last_name"} HTTPMethod:@"GET"];
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:req
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
             if (!error) {
                 NSLog(@"Facebook Result :%@",result);
                 NSDictionary *dict = result;
                 NSString *strEmail = [dict valueForKey:@"email"];
                 if (strEmail==nil || [strEmail isEqualToString:@""])
                 {
                     strEmail = [dict valueForKey:@"id"];
                 }
                 [[User currentUser] setTokenForFBORGOOGLEPLUS:[[[FBSession activeSession] accessTokenData] accessToken]];
                 [self getUserIdFromHuddlyFlyFirstname:[dict valueForKey:@"first_name"] lastName:[dict valueForKey:@"last_name"] email:strEmail token:[[[FBSession activeSession] accessTokenData] accessToken] loginType:@"FB"];
             }
             else {
                 NSLog(@"Error: %@",error.userInfo);
                 [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
             }
         }];
    [connection start];
}

- (void)getUserIdFromHuddlyFlyFirstname:(NSString *)first lastName:(NSString *)last email:(NSString *)email token:(NSString *)token loginType:(NSString *)type
{
    NSLog(@"Get user :%@",token);
    NSString *strToken = token;
    if(!strToken){
        strToken = @"";
    }
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:first forKey:kAPI_PARAM_FIRSTNAME];
    [dictParam setObject:last forKey:kAPI_PARAM_LASTNAME];
    [dictParam setObject:email forKey:kAPI_PARAM_EMAILID];
    [dictParam setObject:strToken forKey:kAPI_PARAM_ACCESSTOKEN];
    [dictParam setObject:type forKey:kAPI_PARAM_LOGINTYPE];
    NSLog(@"Get user dicrt :%@",dictParam);
    [afn getDataFromPath:kAPI_PATH_SAVEGOOGLEORFBUSER withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error == nil) {
            
            NSDictionary *dict = response;
            [[User currentUser] setUserID:[dict objectForKey:@"result"]];
            
            [[AppDelegate sharedAppDelegate] gotoMainScreen];
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];

}


- (IBAction)onClickGP:(id)sender {
    
    //[self gmailLogin];
    [self gmailLoginBrowser];
    /*[[AppDelegate sharedAppDelegate] gotoMainScreen];*/
}

- (IBAction)onClickEmail:(id)sender {
    //[[AppDelegate sharedAppDelegate] gotoMainScreen];
}

#pragma mark - Gmail 

- (void)gmailLoginBrowser {
    
    NSURL *authorizationEndpoint = [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/v2/auth"];
    
    NSURL *tokenEndpoint = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"];
    
    OIDServiceConfiguration *configuration = [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint tokenEndpoint:tokenEndpoint];
    
    // builds authentication request
    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                                                     clientId:GoogleCustomKey
                                                                                       scopes:@[OIDScopeOpenID,
                                                                                                OIDScopeProfile, OIDScopeEmail, @"https://www.googleapis.com/auth/calendar"]
                                                                                  redirectURL:[NSURL URLWithString:GoogleRedirectUri]
                                                                                 responseType:OIDResponseTypeCode
                                                                         additionalParameters:nil];
    
    // performs authentication request
    AppDelegate *appDelegate =
    (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentAuthorizationFlow =
    [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                   presentingViewController:self
                                                   callback:^(OIDAuthState *_Nullable authState,
                                                              NSError *_Nullable error) {
                                                       if (authState) {
                                                           NSLog(@"Got authorization tokens. Access token: %@",
                                                                 authState.lastTokenResponse.accessToken);
                                                           
                                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                           [defaults setValue:authState.lastTokenResponse.accessToken forKey:@"Token"];
                                                           [defaults setValue:authState.lastTokenResponse.tokenType forKey:@"TokenType"];
                                                           [defaults setValue:authState.lastTokenResponse.refreshToken forKey:@"Refresh_Token"];
                                                           [defaults setValue:authState.lastTokenResponse.idToken forKey:@"Token_Code"];
                                                           [defaults synchronize];
                                                           [[User currentUser] setGOOGLELOGOUT:@"1"];
                                                           [[User currentUser] setLOGINTYPE:@"Google"];
                                                           [self LoginDetail];
                                                           
                                                       } else {
                                                           NSLog(@"error: %@", error);
                                                           
                                                           if ([error.domain isEqualToString:@"org.openid.appauth.general"] && error.code == -4) {
                                                               [[AppDelegate sharedAppDelegate] showToastMessage:@"Canceled"];
                                                           } else {
                                                           [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                                                           }
                                                       }
                                                   }];
    
}

-(void)gmailLogin
{
    //Google Authentication
    NSString *strUrl =[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?client_id=%@&redirect_uri=%@&scope=https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks https://www.googleapis.com/auth/tasks.readonly https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline",GoogleCustomKey,GoogleRedirectUri];
    
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"string :%@ ",strUrl);
    
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSLog(@"Url :%@ ",url);
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@"Loading"];
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, self.view.frame.size.height-40)];
    web.delegate = self;
    web.tag = 1000;
    [self.view addSubview:web];
    
    web.layer.borderWidth = 5.0;
    web.layer.borderColor = [UIColor brownColor].CGColor;
    web.clipsToBounds = YES;
    
    UIButton *btnRemoveWeb = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRemoveWeb.frame = CGRectMake(2, 10, 25, 25);
    btnRemoveWeb.tag = 1001;
    btnRemoveWeb.layer.cornerRadius = btnRemoveWeb.frame.size.width/2;
    btnRemoveWeb.clipsToBounds = YES;
    [btnRemoveWeb setBackgroundColor:[UIColor blackColor]];
    [btnRemoveWeb setTitle:@"X" forState:UIControlStateNormal];
    [btnRemoveWeb addTarget:self action:@selector(removeWeb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRemoveWeb];
    
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - Remover WebView.

-(void)removeWeb:(id)sender
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    [[self.view viewWithTag:1001] removeFromSuperview];
}

#pragma mark - WebView Delegate.

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Resquest :%@",request.URL);
    NSLog(@"Host :%@",request.URL.host);
    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
    NSURL *url = request.URL;
    if ([url.host isEqualToString:GoogleHostApp])
    {
        [[self.view viewWithTag:1000] removeFromSuperview];
        [[self.view viewWithTag:1001] removeFromSuperview];
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@"Loading"];
        NSDictionary *dict = [self parametersDictionaryFromQueryString:[url query]];
        NSLog(@"dictionary :%@",dict);
        NSString *strCode = dict[@"code"];
        NSString *post = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code",strCode,GoogleCustomKey,GoogleSecretKey,GoogleRedirectUri];
        NSData *postdata = [post dataUsingEncoding:NSASCIIStringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"accounts.google.com" forHTTPHeaderField:@"Host"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postdata];
        
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *json = nil;
        
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:&error];
            if (json)
            {
                NSLog(@"json Data :%@",json);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:json[@"access_token"] forKey:@"Token"];
                [defaults setValue:json[@"token_type"] forKey:@"TokenType"];
                [defaults setValue:json[@"refresh_token"] forKey:@"Refresh_Token"];
                [defaults setValue:strCode forKey:@"Token_Code"];
                [defaults synchronize];
                [[User currentUser] setGOOGLELOGOUT:@"1"];
                [[User currentUser] setLOGINTYPE:@"Google"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self LoginDetail];
                                       /*[[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                                       [[AppDelegate sharedAppDelegate] gotoMainScreen];*/
                                   });
                               });
            }
            else{
                NSLog(@"error: %@", error);
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }
    return YES;
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

- (void)LoginDetail
{
    //[[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    NSError *error;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *strToken = [def stringForKey:@"Token"];
    NSString *strCode = [def stringForKey:@"Refresh_Token"];
    
    NSString *strApi = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me?key=%@&access_token=%@",GoogleCustomKey,strToken];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strApi]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Dict :%@ api: %@",dict,strApi);
    
    [[User currentUser] setTokenForFBORGOOGLEPLUS:strToken];
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *strEmail ;
        NSString *strFirstName ;
        NSString *strLastName ;
        NSDictionary *dictEmail = [dict objectForKey:@"emails"];
        strEmail = [[dictEmail valueForKey:@"value"] objectAtIndex:0];
        dictEmail = [dict objectForKey:@"name"];
        strFirstName = [dictEmail valueForKey:@"givenName"];
        strLastName = [dictEmail valueForKey:@"familyName"];
        NSLog(@"firstName :%@ lastName :%@ Email :%@ Dict :%@",strFirstName,strLastName,strEmail,dictEmail);
        [self getUserIdFromHuddlyFlyFirstname:strFirstName lastName:strLastName email:strEmail token:strCode loginType:@"Google"];
        
    }
    else{
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
    }
}


#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error != nil){
        NSLog(@"%@", error.localizedDescription);
    }else{
        NSString *strEmail  = [[user profile] email];
        NSString *strName  = [[user profile] name];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *strCode = [def stringForKey:@"Refresh_Token"];
        NSArray *items = [strName componentsSeparatedByString:@" "];   //take one array for splitting the string
        NSString *strFirstName = [items objectAtIndex:0];
        NSString *strLastName = [items objectAtIndex:1];
        [[User currentUser] setGOOGLELOGOUT:@"1"];
        [[User currentUser] setLOGINTYPE:@"Google"];
        NSLog(@"firstName :%@ lastName :%@ Email :%@",strFirstName,strLastName,strEmail);
        [self getUserIdFromHuddlyFlyFirstname:strFirstName lastName:strLastName email:strEmail token:strCode loginType:@"Google"];
    }
}




- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error{
    //Stop activity indicator
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
