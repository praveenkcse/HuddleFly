//
//  BaseVC.m
//  Employee
//
//  Created by Elluminati - macbook on 19/05/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "BaseVC.h"
#import "LocalEvents.h"

@interface BaseVC (){
   __strong NSMutableArray  *arrNumber;
}

@end

@implementation BaseVC


#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrNumber = [[NSMutableArray alloc] init];
    [self setMultimedia:@"0"];
    self.view.backgroundColor = COLOR_HOME_BG;
    //self.navigationController.navigationBar.barTintColor = COLOR_NAV_BG;
    self.navigationController.navigationBar.alpha = 1.0f;
    self.navigationController.navigationBar.translucent = NO;
    animPop=YES;

    
    if (ISIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    if ([AppDelegate sharedAppDelegate].isLogin) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
//    [self setTransitions];
}

-(void)setMultimedia:(NSString *) multimediaValue{
    _multimedia = multimediaValue;
    [self getTransitionGlobal:multimediaValue];
}


- (void) getTransitionGlobal:(NSString *) multimedia
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
       
    [dictParam setObject: multimedia forKey:kAPI_PARAM_MULTIMEDIA];
    [afn getDataFromPath:@"GetTransitionList2" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrNumber removeAllObjects];
                for (NSDictionary *dict in response) {
                    Transition *d = [[Transition alloc] init];
                    [d setData:dict];
                    [arrNumber addObject:d];
                }
                [self setTransitions];
            }
        }
    }];
}


-(void)setTransitions{
    transitionStrings = [[NSMutableArray alloc] init];
   transitionValues = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < arrNumber.count; i++) {
        Transition * obj = [arrNumber objectAtIndex:i];
        [transitionStrings addObject: obj.name];
        [transitionValues addObject: obj.value];
    }
//    transitionStrings = @[@"15 Seconds", @"30 Seconds", @"45 Seconds", @"1 Minute", @"2 Minutes", @"3 Minutes", @"4 Minutes", @"5 Minutes", @"6 Minutes", @"7 Minutes", @"8 Minutes", @"9 Minutes", @"10 Minutes", @"11 Minutes", @"12 Minutes", @"13 Minutes", @"14 Minutes", @"15 Minutes", @"16 Minutes", @"17 Minutes", @"18 Minutes", @"19 Minutes", @"20 Minutes"];
//
//    transitionValues = @[@"15",@"30",@"45",@"60",@"120",
//                         @"180",@"240",@"300",
//                         @"360",@"420",@"480",
//                         @"540",@"600",@"660",
//                         @"720",@"780",@"840",
//                         @"900",@"960",@"1020",
//                         @"1080",@"1140",@"1200"];
    
    NSInteger selectedIndex = 3;
    
    if (_pid != nil) {
        NSDictionary *d = UtilityClass.sharedObject.transitions;
        NSString *def = UtilityClass.sharedObject.defaultTransition;
        NSString *v = UtilityClass.sharedObject.transitions[@(_pid)];
        if (v != nil) {
            selectedIndex = [transitionValues indexOfObject:v];
            if (selectedIndex > [transitionValues count]){
                selectedIndex = 0;
            }
        } else {
            if ([transitionValues containsObject:def]) {
                selectedIndex = [transitionValues indexOfObject:def];
                if (selectedIndex > [transitionValues count]){
                    selectedIndex = 0;
                }
            }
        }
        
        NSString *string = [transitionStrings objectAtIndex:selectedIndex];
        NSString *value = [transitionValues objectAtIndex:selectedIndex];
        self.txtTransitions.text = string;
        self.txtTransitions.accessibilityValue = value;
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    if ([AppDelegate sharedAppDelegate].isLogin) {
        return UIStatusBarStyleLightContent;
    } else{
        return UIStatusBarStyleDefault;
    }
}

- (void)onTouchHideKeyboard
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Hide Keyboard

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Utility Methods

-(void)setNavBarTitle:(NSString *)title
{
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor=[UIColor clearColor];
//    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    lbl.textColor=COLOR_TITLE_FONT;
    lbl.text=title;
    self.navigationItem.titleView=lbl;
}

-(void)setNavBarTitle:(NSString *)title color:(UIColor *)color
{
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    lbl.textColor=color;
    lbl.text=title;
    self.navigationItem.titleView=lbl;
}

-(void)setBackBarItem
{
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 40, 40);
    //btnLeft.frame=CGRectMake(0, 0, 18, 16);
    [btnLeft setImage:[UIImage imageNamed:@"btnBackMain"] forState:UIControlStateNormal];
    //[btnLeft setTitle:@"Back" forState:UIControlStateNormal];
    //[btnLeft setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
}

//MARK: - UI Methods
-(void) setHelpBarButton:(NSInteger) featureId  {

    UIBarButtonItem *hBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help_icn"] style:UIBarButtonItemStylePlain target:self action:@selector(openHelpURL:)];
    self.navigationItem.rightBarButtonItem = hBtn;
    
    
//    UIButton *helpButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    helpButton.frame=CGRectMake(0, 0, 30, 30);
//    helpButton.tag = featureId;
//    [helpButton setImage:[UIImage imageNamed:@"help_icn.png"] forState:UIControlStateNormal];
//    [helpButton addTarget:self action:@selector(openHelpURL:) forControlEvents:UIControlEventTouchUpInside];//@selector(showHelp:)
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:helpButton];
}

-(void) showHelp: (UIButton*) sender {
    //http://huddlefly.co/support/%ld Change 18-Jul-2017
    NSString* url = [NSString stringWithFormat:@"http://huddlefly.co/ufaqs/%@", self.helpPath];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (NSString *)helpPath {
    return @"quick-start-guide";
}

- (void)setHelpButtonWithTag:(NSInteger)tag{
    [self setHelpButtonWithTarget:self selector:nil frame:CGRectMake(self.view.bounds.size.width-53, 25, 30, 30) InView:self.view color:nil tag:tag];
}

- (void)setHelpButtonWithTarget:(id)target selector:(SEL)selector frame:(CGRect)rect InView:(UIView *)view color:(UIColor *)color tag:(NSInteger)tag{
    UIButton *helpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame=rect;
    helpButton.tag = tag;
    [helpButton setImage:[[UIImage imageNamed:@"help"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [helpButton setTintColor:color?color:[UIColor blackColor]];
    [helpButton addTarget:target action:selector?selector:@selector(openHelpURL:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:helpButton];
}

- (IBAction)openHelpURL:(UIButton *)sender{
    NSString* url = [NSString stringWithFormat:@"http://huddlefly.co/ufaqs/%@", self.helpPath];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    if (sender.tag == 10){
//        //http://huddlefly.co/support/0-10 Change 18-Jul-2017
//        NSString* url = [NSString stringWithFormat:@"http://huddlefly.co/ufaqs/0-10"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }else{
//        //http://huddlefly.co/support/%ld-%ld Change 18-Jul-2017
//        NSString* url = [NSString stringWithFormat:@"http://huddlefly.co/ufaqs/%ld-%ld", (sender.tag / 10),(sender.tag % 10)];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
}

-(void)setBackBarItem:(BOOL)animated
{
    animPop=animated;
    [self setBackBarItem];
}

-(void)onClickBackBarItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:animPop];
}

- (IBAction)onClickSupport:(id)sender
{
    NSString* url = @"http://www.huddlefly.co/support";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Action for Navigation

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickMenu:(id)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController revealToggle:sender];
}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
    
    - (IBAction)onClickTransitionsTextfield:(UITextField *)sender
    {
        [sender becomeFirstResponder];
        [sender resignFirstResponder];
        
        [ActionSheetStringPicker showPickerWithTitle:@"Transitions" rows:transitionStrings initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            NSString *string = [self->transitionStrings objectAtIndex:selectedIndex];
            NSString *value = [self->transitionValues objectAtIndex:selectedIndex];
            self.txtTransitions.text = string;
            self.txtTransitions.accessibilityValue = value;
            
            UtilityClass.sharedObject.transitions[@(self->_pid)] = self.txtTransitions.accessibilityValue;
            NSMutableDictionary *trans = [[NSMutableDictionary alloc]init];
            trans = UtilityClass.sharedObject.transitions;
            
            NSData *transitionEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:trans];
            [[NSUserDefaults standardUserDefaults] setObject:transitionEncodedObject forKey:kUSERDEFAULT_TRANSITIONS];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:sender];
    }

@end


/*

 #pragma mark -
 #pragma mark - KeyBord Methods
 
 -(void) keyboardWillShow:(NSNotification *)note{
 // get keyboard size and loctaion
 CGRect keyboardBounds;
 [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
 NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
 NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
 
 // Need to translate the bounds to account for rotation.
 keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
 //for get keybord height
 //CGFloat kbHeight = [[note objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
 
 CGRect containerFrame = self.bottomView.frame;
 containerFrame.origin.y=self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
 [self.view bringSubviewToFront:self.bottomView];
 
 // animations settings
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:[duration doubleValue]];
 [UIView setAnimationCurve:[curve intValue]];
 // set views with new info
 self.bottomView.frame=containerFrame;
 // commit animations
 [UIView commitAnimations];
 }
 
 -(void) keyboardWillHide:(NSNotification *)note{
 NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
 NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
 
 CGRect containerFrame = self.bottomView.frame;
 containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:[duration doubleValue]];
 [UIView setAnimationCurve:[curve intValue]];
 
 // set views with new info
 self.bottomView.frame = containerFrame;
 // commit animations
 [UIView commitAnimations];
 }
 */

