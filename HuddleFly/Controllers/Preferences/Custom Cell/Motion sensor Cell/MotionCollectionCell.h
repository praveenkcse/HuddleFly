//
//  MotionCollectionCell.h
//  HuddleFly
//
//  Created by BMAC on 03/11/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotionCollectionCell : UICollectionViewCell<UITextViewDelegate>

@property (nonatomic , retain)IBOutlet UILabel *lblAlertType;
@property (nonatomic , retain)IBOutlet UILabel *lblAlertMsg;
@property (nonatomic , retain)IBOutlet UILabel *lblMediaType;
@property (nonatomic , retain)IBOutlet UILabel *lblTimeStamp;
@property (nonatomic , retain)IBOutlet UITextView *tvMediaUrl;

- (void)setCellData:(id)data;

@end
