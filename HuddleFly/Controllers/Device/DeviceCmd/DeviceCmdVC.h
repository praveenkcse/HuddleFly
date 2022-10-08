//
//  DeviceCmdVC.h
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface DeviceCmdVC : BaseVC <UITextFieldDelegate>

{
    NSMutableArray *arrCommands;
}

@property (weak, nonatomic) IBOutlet UITextField *txtCmd;
- (IBAction)onClickSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end
