//
//  StockCurrencyVC.h
//  HuddleFly
//
//  Created by BMAC on 01/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface StockCurrencyVC : BaseVC<UITextFieldDelegate, UITextViewDelegate>


@property (nonatomic , weak)IBOutlet UITextView *txtCurrency;
@property (nonatomic , weak)IBOutlet UITextView *txtStock;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *splitBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtTransit;
@property (weak, nonatomic) IBOutlet UILabel *splitTransitLbl;
- (IBAction)onClickSplit:(UIButton*)sender;
- (IBAction)splitTxtClicked:(UITextField *)sender;

@end
