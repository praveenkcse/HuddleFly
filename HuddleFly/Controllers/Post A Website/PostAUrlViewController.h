//
//  PostAUrlViewController.h
//  HuddleFly
//
//  Created by Anton Boyarkin on 23/02/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface PostAUrlViewController : BaseVC <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtYouTubeURL;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

- (IBAction)onClickSubmit:(id)sender;

@end
