//
//  ConfigureHuddleFly.m
//  HuddleFly
//
//  Created by BMAC on 03/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "ConfigureHuddleFly.h"
#import "Global.h"
#import "AFNHelper.h"
#import "AFNetworking.h"
#import "Constants.h"



@interface ConfigureHuddleFly ()

@end

@implementation ConfigureHuddleFly

- (void)viewDidLoad {
    [super viewDidLoad];
    //oldRect = scrView.frame;
    
    [super setNavBarTitle:@"Configure HuddleFly"];
    [super setBackBarItem];
    
    //[super onTouchHideKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[Global sharedInstance].configureURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [_webView loadRequest:request];
    
//    @"http://192.168.1.1"
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:animated];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtActive = textField;
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
    NSString *strPasswordEncripted = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)self.txtPassword.text,
                                                                                         NULL, 
                                                                                         (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", 
                                                                                         kCFStringEncodingUTF8));;
    NSLog(@"Password :%@",strPasswordEncripted);
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.txtSsid.text forKey:@"ssid"];
    [dictParam setObject:strPasswordEncripted forKey:@"password"];
    [dictParam setObject:self.txtEmail.text forKey:@"email"];
    
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataForSSID:@"http://192.168.1.1/cgi/cgi_script.py" withParamData:dictParam
              withBlock:^(id response, NSError *error) {
                  [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                  if(response)
                  {
                      [[AppDelegate sharedAppDelegate] showToastMessage:@"Successfully submitted to HuddleFly"];
                      [self onClickBacktoRoot:self];
                  }else{
                      //Change By DHAWAL 29-Jun-2016
                      //[[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
                      [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"HuddleFly is not in a configuration mode. Or You have not connected to HuddleFly hotspot"];
                  }
              }];
}

-(IBAction)onClickBacktoRoot:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}*/

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


@implementation SelectVC

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
-(void)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end

@implementation Screen1

-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setNavBarTitle:@"Configure HuddleFly"];
    [Global roundBorderSet:_nextBtn];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 40, 40);
    [btnLeft setImage:[UIImage imageNamed:@"btnBackMain"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
//    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnRight.frame=CGRectMake(0, 0, 40, 40);
//    [btnRight setImage:[UIImage imageNamed:@"btnNextScreen"] forState:UIControlStateNormal];
//    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(onClickNextScreen) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];

    [super setHelpBarButton:2];
    
    

    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextScreen)];
    tap.numberOfTapsRequired = 1;
    [self.img addGestureRecognizer:tap];*/
}

-(void)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickNextScreen
{
    [self nextScreen];
}

- (void)nextScreen
{
    [self performSegueWithIdentifier:@"segueToScreen1" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end


@implementation Screen2

-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setNavBarTitle:@"Configure HuddleFly"];
    [Global roundBorderSet:_nextBtn];
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 40, 40);
    [btnLeft setImage:[UIImage imageNamed:@"btnBackMain"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    [super setHelpBarButton:2];
    
    /*UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 20, 20);
    btnRight.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [btnRight setTitle:@">" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(onClickNextScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    */
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextScreen)];
    tap.numberOfTapsRequired = 1;
    [self.img addGestureRecognizer:tap];*/
}

-(void)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickNextScreen
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have you connected your phone to HuddleFly WiFi Hotspot yet??" message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

      //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)nextScreen
{
/*    if([NSURL URLWithString:[Global sharedInstance].configureURL] == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please configure Url." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    } else
 */
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.1.1"]];

//    [self performSegueWithIdentifier:@"segueToScreen2" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end

