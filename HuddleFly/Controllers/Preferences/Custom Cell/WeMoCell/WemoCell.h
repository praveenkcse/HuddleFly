//
//  WemoCell.h
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeMoSelectedSwitch <NSObject>

- (void)selectedSwitch:(NSInteger)index status:(int)status;

@end

@interface WemoCell : UITableViewCell
@property (nonatomic , assign)id<WeMoSelectedSwitch> delegate;
@property (nonatomic , retain)IBOutlet UILabel *lblSwitchName;
@property (nonatomic , retain)IBOutlet UILabel *lblDate;
@property (nonatomic , retain)IBOutlet UISwitch *swt;
- (void)setCellData:(id)data index:(NSInteger)index;
- (IBAction)swtTapped:(id)sender;
@end
