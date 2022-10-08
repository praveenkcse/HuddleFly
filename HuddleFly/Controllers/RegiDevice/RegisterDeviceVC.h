//
//  RegisterDeviceVC.h
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface RegisterDeviceVC : BaseVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtDeviceID;
- (IBAction)onClickSubmit:(id)sender;


@end
