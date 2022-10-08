//
//  PostAWebsite.h
//  HuddleFly
//
//  Created by BMAC on 29/06/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface PostAWebsite : BaseVC<UITextFieldDelegate>

@property (nonatomic , assign)IBOutlet UILabel *lblMsg;
@property (nonatomic , assign)IBOutlet UITextView *txtViewWebUrl;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic , assign)IBOutlet UITextField *durationTextField;

- (IBAction)onClickTextField:(UITextField *)sender;

@end
