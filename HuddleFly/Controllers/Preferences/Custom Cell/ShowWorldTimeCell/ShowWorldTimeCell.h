//
//  ShowWorldTimeCell.h
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowWorldTimeCell : UITableViewCell
{
    id cellData;
    
}
@property (nonatomic , retain)IBOutlet UILabel *lblCountryName;
@property (nonatomic , retain)IBOutlet UIButton *btnCheckmark;

- (IBAction)onClickCheckmark:(id)sender;
- (void)setCellData:(id)data;
@end
