//
//  MotionVC.h
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "LocalEvents.h"
#import "MotionCollectionCell.h"

@interface MotionVC : BaseVC<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UITextField *txtPIRFlag;
    //IBOutlet UITextField *txtPIRType;
    IBOutlet UITextField *txtPIRDelay;
    IBOutlet UICollectionView *colMotion;
    IBOutlet UIView *viewTitle;
    NSMutableArray *arrMotion;
    
}
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end
