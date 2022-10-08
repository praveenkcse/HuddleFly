//
//  SettingVC.m
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "SettingVC.h"
#import "Global.h"
@interface SettingVC ()

@end

@implementation Select1VC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setNavBarTitle:@"Configure HuddleFly"];
    [Global roundBorderSet:_configuBtn];
    [Global roundBorderSet:_changewifiBtn];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 40, 40);
    [btnLeft setImage:[UIImage imageNamed:@"btnBackMain"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changewiBtn:(id)sender {
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSString *apiPath = [NSString stringWithFormat:@"%@?UserID=%@&%@=%@",kAPI_PATH_GETDEVICEIP,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    [afn getDataFromPath:apiPath withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            [Global sharedInstance].configureURL =  response[@"IPAddr"];
            [self performSegueWithIdentifier:@"segueToScreenSetting2" sender:self];
        } else{
            [User setUserProfile:nil];
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            //[[UtilityClass sharedObject] showAlertWithTitle:@"Error!" andMessage:error.localizedDescription];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end


@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[super onTouchHideKeyboard];
   // oldRect = scrView.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.1"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [_webView loadRequest:request];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    ///[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:animated];
}

-(IBAction)onClickBacktoRoot:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Keyboard.
/*
-(void)keyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"Key size :%@",NSStringFromCGRect(keyboardFrameBeginRect));
    [self moveKeyboard:keyboardFrameBeginRect.size.height];
}

-(void)keyboardHide:(NSNotification *)notification
{
    scrView.frame = oldRect;
    scrView.contentSize = CGSizeMake(scrView.frame.size.width, scrView.frame.size.height);
    scrView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)moveKeyboard:(CGFloat)keyheight
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyheight, 0.0);
        scrView.contentInset = contentInsets;
        scrView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyheight;
        NSLog(@"Active Textfield :%@",txtActive);
        if (!CGRectContainsPoint(aRect, txtActive.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, -70);//txtActive.frame.origin.y-keyheight
            [scrView setContentOffset:scrollPoint animated:YES];
        }
    }];
    
}

- (IBAction)onClickSubmit:(UIButton *)sender
{
    if (self.txtEmail.text.length == 0 || self.txtPassword.text.length == 0 || self.txtSsid.text.length == 0) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter all information."];
        return;
    }
    if (![[UtilityClass sharedObject] isValidEmailAddress:self.txtEmail.text]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter valid email id."];
        return;
    }
    [self OnSubmit];
}

- (void)OnSubmit
{
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtSsid.text forKey:@"ssid"];
    [dictParam setObject:self.txtPassword.text forKey:@"password"];
    [dictParam setObject:self.txtEmail.text forKey:@"email"];
    
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataForSSID:@"http://192.168.1.1/cgi/cgi_script.py" withParamData:dictParam
              withBlock:^(id response, NSError *error) {
                  [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                  if(response){
                      [[AppDelegate sharedAppDelegate] showToastMessage:@"Successfully submitted to HuddleFly"];
                      [self onClickBacktoRoot:self];
                  }else{
                      //Change By DHAWAL 29-Jun-2016
                      //[[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                      [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"HuddleFly is not in a configuration mode. Or You have not connected to HuddleFly hotspot"];
                  }
              }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtActive = textField;
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation ScreenSetting1

-(void)viewDidLoad
{
    [super viewDidLoad];
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextScreen)];
    tap.numberOfTapsRequired = 1;
    [self.img addGestureRecognizer:tap];*/
    [Global roundBorderSet:_nextBtn];
    [super setNavBarTitle:@""];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 20, 20);
    [btnLeft setTitle:@"<" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
//    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnRight.frame=CGRectMake(0, 0, 20, 20);
//    [btnRight setTitle:@">" forState:UIControlStateNormal];
//    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(onClickNextScreen) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
}

-(IBAction)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickHelp:(id) sender {

    [super showHelp:sender];
}

- (IBAction)onClickNextScreen
{
    [self nextScreen];
}

- (void)nextScreen
{
    [self performSegueWithIdentifier:@"segueToScreenSetting1" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end


@implementation ScreenSetting2

-(void)viewDidLoad
{
    [super viewDidLoad];
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextScreen)];
    tap.numberOfTapsRequired = 1;
    [self.img addGestureRecognizer:tap];*/
    [super setNavBarTitle:@""];
    
    
    [Global roundBorderSet:_nextBtn];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 20, 20);
    [btnLeft setTitle:@"<" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    /*UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 20, 20);
    [btnRight setTitle:@">" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(onClickNextScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];*/
}

-(IBAction)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickNextScreen
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have you connected your phone to HuddleFly WiFi Hotspot yet??" message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self nextScreen];
    } else {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {   //Pre iOS 10
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {   //iOS 10
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}


- (void)nextScreen
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.1.1"]];

   // [self performSegueWithIdentifier:@"segueToScreenSetting2" sender:self];//Removed By DHAWAL 5-Aug-2016
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end


