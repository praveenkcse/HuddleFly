//
//  PlayYouTubeVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface PlayYouTubeVC : BaseVC <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtYouTubeURL;
//@property (weak, nonatomic) IBOutlet UIButton *btnHDMI;
//@property (weak, nonatomic) IBOutlet UIButton *btnAudioJack;
//@property (weak, nonatomic) IBOutlet UITextField *txtPlayStatus;
//@property (weak, nonatomic) IBOutlet UIButton *btnPlayLoop;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

- (IBAction)onClickSubmit:(id)sender;
//- (IBAction)onClickHDMI:(id)sender;
//- (IBAction)onClickAudioJack:(id)sender;

@end
