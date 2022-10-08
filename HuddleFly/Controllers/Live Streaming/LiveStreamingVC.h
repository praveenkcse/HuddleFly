//
//  LiveStreamingVC.h
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface LiveStreamingVC : BaseVC<UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITextField *txtStreamUrl;
    IBOutlet UITextField *txtStreamKey;
    IBOutlet UITextView *txtYoutubeUrl;
    
    //keyboard
    IBOutlet UIScrollView *scrView;
    CGRect txtActive;
    CGRect oldRect;
}
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@end
