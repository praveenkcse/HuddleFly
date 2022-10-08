//
//  PostMessageVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface PostMessageVC : BaseVC <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnFullScreen;
@property (weak, nonatomic) IBOutlet UIButton *btnTextAndImage;
@property (weak, nonatomic) IBOutlet UIButton *btnMarquee;
@property (weak, nonatomic) IBOutlet UIButton *btnText;

    @property (nonatomic,weak)IBOutlet UITextField *pixTransitionTextField;
    
    - (IBAction)onClickTextField:(UITextField *)sender;
    
    
- (IBAction)onClickSubmit:(id)sender;

@end
