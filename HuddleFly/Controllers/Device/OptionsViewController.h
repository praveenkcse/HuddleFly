//
//  OptionsViewController.h
//  HuddleFly
//
//  Created by Anton Boyarkin on 22/02/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface OptionsCell : UITableViewCell {
    Preferences* cellData;
    id cellParent;
}

@property (nonatomic , assign)IBOutlet UILabel *lblTitle;
@property (nonatomic , weak) IBOutlet UIButton *btnCheckMark;
@property (weak, nonatomic) IBOutlet UIImageView *premiumImg;

- (IBAction)onClickCheckMark:(id)sender;

- (void)setCellData:(Preferences*)data withParent:(id)parent;

@end

@interface OptionsViewController : BaseVC<UITableViewDataSource , UITableViewDelegate> {
    NSMutableArray *arrOptionData;
    NSMutableDictionary *optionsData;
    NSMutableArray *categories;
}

@property (nonatomic, weak) IBOutlet UITableView *tblPreference;
@property (weak, nonatomic) IBOutlet UIButton *submitPrefernceBtn;

@property (nonatomic , strong) NSString *strTitle;

- (IBAction)onClickSavePreferences:(id)sender;
- (void) getOptionData;

@end
