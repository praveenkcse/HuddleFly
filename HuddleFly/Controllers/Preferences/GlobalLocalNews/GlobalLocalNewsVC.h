//
//  GlobalLocalNewsVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface GlobalLocalNewsVC : BaseVC <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UITextField *txtTransit;
@property (weak, nonatomic) IBOutlet UITextView *txtKeyword;
@property (weak, nonatomic) IBOutlet UITextField *txtItemstNumber;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *splitBtn;
@property (weak, nonatomic) IBOutlet UILabel *splitTransitLbl;

- (IBAction)splitTxtClicked:(UITextField *)sender;
- (IBAction)onClickSubmit:(id)sender;
- (IBAction)onClickSplit:(UIButton*)sender;
@end
