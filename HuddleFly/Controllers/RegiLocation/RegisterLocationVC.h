//
//  RegisterLocationVC.h
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface RegisterLocationVC : BaseVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
- (IBAction)onClickSubmit:(id)sender;

@end
