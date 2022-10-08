//
//  ForgotPasswordVC.h
//  HuddleFly
//
//  Created by BMAC on 01/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface ForgotPasswordVC : BaseVC

@property (nonatomic , assign) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
