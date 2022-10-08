//
//  BaseVC.h
//  Employee
//
//  Created by Elluminati - macbook on 19/05/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UtilityClass.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "AFNHelper.h"
#import "User.h"
#import "ActionSheetStringPicker.h"

@interface BaseVC : UIViewController<UITextFieldDelegate>
{
    BOOL animPop;
    
    NSMutableArray *transitionStrings;
    NSMutableArray *transitionValues;
}
-(void)setBackBarItem;
-(void) setHelpBarButton:(NSInteger) featureId;
- (void)setHelpButtonWithTag:(NSInteger)tag;
- (void)setHelpButtonWithTarget:(id)target selector:(SEL)selector frame:(CGRect)rect InView:(UIView *)view color:(UIColor *)color tag:(NSInteger)tag;
-(void)setBackBarItem:(BOOL)animated;
-(void)setNavBarTitle:(NSString *)title;
-(void)setNavBarTitle:(NSString *)title color:(UIColor *)color;
- (void)onTouchHideKeyboard;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickMenu:(id)sender;
-(void) showHelp: (UIButton*) sender;
-(void)setMultimedia:(NSString *) multimediaValue;
- (NSString *)helpPath;


@property (weak, nonatomic) IBOutlet UITextField *txtTransitions;
@property (nonatomic) int pid;
@property (nonatomic) NSString *deviceID;
@property (nonatomic) NSString *heading;
@property (nonatomic) NSString *multimedia;

@end
