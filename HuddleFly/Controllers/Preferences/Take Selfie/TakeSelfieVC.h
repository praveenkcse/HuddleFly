//
//  TakeSelfieVC.h
//  HuddleFly
//
//  Created by BMAC on 29/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface TakeSelfieVC : BaseVC
{
    IBOutlet UIButton *btnMediaUrl;
    IBOutlet UILabel *lblAlertTime;
    IBOutlet UILabel *lblMediaUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *snapBtn;
@end
