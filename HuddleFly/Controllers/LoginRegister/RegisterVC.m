//
//  RegisterVC.m
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "RegisterVC.h"
#import "UIView+Utils.h"
#import "Global.h"
@implementation RegisterVC
@synthesize scrView;
@synthesize registerSwitch;


#pragma mark - ViewLife Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setHelpButtonWithTag:1];
    [self.viewCont applySmallCornerWithColor:[UIColor lightGrayColor]];
    
    oldRect = scrView.frame;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.backView addGestureRecognizer:tap];
    
    //[scrView setContentSize:CGSizeMake(scrView.frame.size.width, _btnGoogle.frame.size.height+_btnGoogle.frame.origin.y)];
    
    //Added By DHAWAL 17-JUL-2017
    [scrView setContentSize:CGSizeMake(scrView.frame.size.width, _registerBtn.frame.size.height+_registerBtn.frame.origin.y)];
    
    _facebookBtn.tag = 1;
    _btnGoogle.tag = 1;
    _registerBtn.tag = 1;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [Global roundBorderSet:_facebookBtn];
    [Global roundBorderSet:_registerBtn];
     _btnGoogle.enabled=false;
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self animateTextField2:nil up:NO value:(keyboardSize.height)];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self animateTextField2:nil up:YES value:(keyboardSize.height)];
}

- (void) animateTextField2: (UITextView*) textField up: (BOOL) up value:(int)val
{
    //    const int movementDistance = val; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    //    int movement = (up ? -movementDistance : movementDistance);
    
    CGRect frame = self.view.frame;
    
    if (up) {
        frame.origin.y = -val;
    } else {
        frame.origin.y = 0;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    //    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:animated];
}


#pragma mark - Hide Keyboard

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

-(void)keyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [self moveKeyboard:keyboardFrameBeginRect.size.height];
}

-(void)keyboardHide:(NSNotification *)notification
{
    scrView.frame = oldRect;
    scrView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[scrView setContentSize:CGSizeMake(scrView.frame.size.width, _btnGoogle.frame.size.height+_btnGoogle.frame.origin.y)];
    
    //Added By DHAWAL 17-JUL-2017
    [scrView setContentSize:CGSizeMake(scrView.frame.size.width, _registerBtn.frame.size.height+_registerBtn.frame.origin.y)];
}

-(void)moveKeyboard:(CGFloat)keyheight
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyheight, 0.0);
        scrView.contentInset = contentInsets;
        scrView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyheight;
       
        if (!CGRectContainsPoint(aRect, txtActive.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, -70);//txtActive.frame.origin.y-keyheight
            [scrView setContentOffset:scrollPoint animated:YES];
        }
    }];
}

#pragma mark - Actions

/* 2-Aug-2016 Reponse
 
 ResponseCode = 0;
 message = "<null>";
 success = 1;
 
 */

/* 10-Aug-2016
 {
 error = "";
 result = 0;
 }
 */
- (IBAction)onSwitchRegister:(id)sender {
    if (registerSwitch.on)
    {
        _registerBtn.enabled=true;
        _btnGoogle.enabled=true;
        _facebookBtn.enabled=true;
    }
    else
    {
        _registerBtn.enabled=false;
        _btnGoogle.enabled=false;
        _facebookBtn.enabled=false;
    }
}

- (IBAction)onClickRegister:(id)sender {
    
    if (self.txtEmailAddress.text.length == 0 || self.txtPassword.text.length == 0 || self.txtFirstName.text.length == 0 || self.txtLastName.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    if (![[UtilityClass sharedObject] isValidEmailAddress:self.txtEmailAddress.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid email id."];
        return;
    }
    if (![self.txtPassword.text isEqualToString:self.txtConfirmPsw.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Password and confirm password are diffrent."];
        return;
    }
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtEmailAddress.text forKey:kAPI_PARAM_EMAILID];
    [dictParam setObject:self.txtPassword.text forKey:kAPI_PARAM_PASSWORD];
    [dictParam setObject:self.txtFirstName.text forKey:kAPI_PARAM_FIRSTNAME];
    [dictParam setObject:self.txtLastName.text forKey:kAPI_PARAM_LASTNAME];
    //[dictParam setObject:self.txtZipCode.text forKey:kAPI_PARAM_ZIPCODE];
    //[dictParam setObject:self.txtDeviceID.text forKey:kAPI_PARAM_DEVICEID];
    
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    [afn getDataFromPath:kAPI_PATH_SAVEUSER withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response && error==nil) {
            if ([[response objectForKey:@"user_id"] isKindOfClass:[NSString class]]) {
                [[User currentUser] setUserID:[response objectForKey:@"user_id"]];
                [[AppDelegate sharedAppDelegate] gotoMainScreen];
            }
            else {
                if ([[response objectForKey:@"result"] isKindOfClass:[NSString class]]) {//"result" Replace with "success" at 2-Aug-2016
                    int result = [[response objectForKey:@"result"] intValue];
                    if (result == 0){//"result" Replace with "success" and "0" Replace with "1"
                        //[[response objectForKey:@"success"] isEqualToString:@"1"] at 2-Aug-2016
                        
                        [super onClickBack:self];
                     //   [[AppDelegate sharedAppDelegate] showToastMessage:@" Your account is successfully created. We have sent out an verification email to your registered email address. Please look at the email and verify your account to start using HuddleFly."];
                        [[UtilityClass sharedObject] showAlertWithTitle:@"Your account has been successfully created." andMessage:@"We have sent out an verification email to your registered email address. Please check your email (including your SPAM folder!) and verify your account to start using HuddleFly"];

                    }else if (result  > 0){
                        [[AppDelegate sharedAppDelegate] showToastMessage:@"User already exists."];
                    }
                    else{
                        [[UtilityClass sharedObject] showAlertWithTitle:@"Oops, user registration failed" andMessage:@""];
                    }
                }
            }
        } else{
            [[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - FaceBook

- (IBAction)FbClicked:(id)sender{
    
    LoginVC *login = [[LoginVC alloc] init];
    [login onClickFB:self];
}

#pragma mark - Google

- (IBAction)googleClicked:(id)sender{
   // [self gmailLogin];
    [self gmailLoginBrowser];
}


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
//                                                           [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
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
//                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                if ([error.domain isEqualToString:@"org.openid.appauth.general"] && error.code == -4) {
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"Canceled"];
                } else {
                    [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                }
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
        [self getUserIdFromHuddlyFlyFirstname:strFirstName lastName:strLastName email:strEmail token:strToken loginType:@"Google"];
        
    }
    else{
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
    }
}


#pragma mark- Goodle sign in delegates

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error != nil){
        NSLog(@"%@", error.localizedDescription);
    }else{
        NSString *strEmail  = [[user profile] email];
        NSString *strName  = [[user profile] name];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
       
        NSString *strCode = user.authentication.refreshToken ;//[def stringForKey:@"Refresh_Token"];
        [def setObject:strCode forKey:@"Refresh_Token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:user.authentication.accessToken forKey:@"Token"];
        [defaults setValue:user.authentication.description forKey:@"TokenType"];
        [defaults setValue:strCode forKey:@"Refresh_Token"];
        [defaults setValue:user.authentication.idToken forKey:@"Token_Code"];
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



- (void)getUserIdFromHuddlyFlyFirstname:(NSString *)first lastName:(NSString *)last email:(NSString *)email token:(NSString *)token loginType:(NSString *)type
{
    NSLog(@"Get user :%@",token);
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:first forKey:kAPI_PARAM_FIRSTNAME];
    [dictParam setObject:last forKey:kAPI_PARAM_LASTNAME];
    [dictParam setObject:email forKey:kAPI_PARAM_EMAILID];
    [dictParam setObject:token forKey:kAPI_PARAM_ACCESSTOKEN];
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
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


-(IBAction) showTerms: (UIButton*) sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.huddlefly.co/terms"]];
}

-(IBAction) showPrivacyPolicy: (UIButton*) sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.huddlefly.co/privacy"]];
}


#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
