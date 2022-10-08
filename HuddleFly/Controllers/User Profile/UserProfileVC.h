//
//  UserProfileVC.h
//  HuddleFly
//
//  Created by BMAC on 26/10/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface UserProfileVC : BaseVC
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
-(IBAction) showPrivacyPolicy: (UIButton*) sender;
-(IBAction) showTerms: (UIButton*) sender;

@end
