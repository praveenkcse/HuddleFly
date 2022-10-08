//
//  ShowWorldTimeCell.m
//  HuddleFly
//
//  Created by BMAC on 30/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "ShowWorldTimeCell.h"
#import "ShowWorldTime.h"
#import "UtilityClass.h"
#import "LocalEvents.h"

@implementation ShowWorldTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)onClickCheckmark:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(btn.selected)
    {
        if([UtilityClass countIncrement] > [UtilityClass getSelectionLimit])
        {
            btn.selected = NO;
            if ([cellData isKindOfClass:[ShowWorldTime class]])
                [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"You can't select more than 4 zip codes."];
            else if ([cellData isKindOfClass:[LocalEvents class]])
                [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"You can't select more than one category."];
            else if ([cellData isKindOfClass:[FbData class]])
            {
                btn.selected = YES;
                //Remove BY DHAWAL 1-Sep-2016 for requirment Multiple selection in fb
                /*
                FbData *f = (FbData *)[UtilityClass getFbElementObj];
                f.isSelected = NO;
                
                // added By DHAWAL 30-Aug-2016 for Select first cell button from other section prevent reuse issue
                UIButton *btnOld = (UIButton *)[UtilityClass getFbElementControl];
                if(![btn isEqual:btnOld])
                    btnOld.selected = NO;
                */
                //((UIButton *)[UtilityClass getFbElementControl]).selected = NO; // Remove BY DHAWAL 30-Aug-2016

             //   [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"You can't select more than one Album."];
            }
            else if (![cellData isKindOfClass:[GoogleDisplayData class]])
            return;
            else if ([cellData isKindOfClass:[GoogleDisplayData class]])
            {
                btn.selected = YES;
            }
            
        }
    }
    else
    {
        [UtilityClass countDecrement];
    }
    
    if ([cellData isKindOfClass:[ShowWorldTime class]])
    {
        ShowWorldTime *show = (ShowWorldTime *)cellData;
        show.isSelected = btn.selected;
    }
    else if ([cellData isKindOfClass:[LocalEvents class]])
    {
        LocalEvents *local = (LocalEvents *)cellData;
        local.isSelected = btn.selected;
    }
    else if ([cellData isKindOfClass:[FbData class]])
    {
        FbData *f = (FbData *)cellData;
        f.isSelected = btn.selected;
        
        //Remove BY DHAWAL 1-Sep-2016 for requirment Multiple selection in fb
        /*
        [UtilityClass setFbElementObj:f];
        [UtilityClass setFbElementControl:btn];
         */
    }
    else if ([cellData isKindOfClass:[GoogleDisplayData class]])
    {
        GoogleDisplayData *g = (GoogleDisplayData *)cellData;
        g.isSelected = btn.selected;
    }
}

- (void)setCellData:(id)data
{
    cellData = data;
    if([cellData isKindOfClass:[ShowWorldTime class]])
    {
        ShowWorldTime *dataTime = (ShowWorldTime *)cellData;
        self.lblCountryName.text = [NSString stringWithFormat:@"%@(%@)",dataTime.strCity,dataTime.strCountry];
        self.btnCheckmark.selected = dataTime.isSelected;
    }
    else if ([cellData isKindOfClass:[LocalEvents class]])
    {
        LocalEvents *local = (LocalEvents *)cellData;
        self.lblCountryName.text = local.strName;
        self.btnCheckmark.selected = local.isSelected;
    }
    else if ([cellData isKindOfClass:[FbData class]])
    {
        FbData *f = (FbData *)cellData;
        self.lblCountryName.text = f.strName;
        self.btnCheckmark.selected = f.isSelected;
    }
    else if ([cellData isKindOfClass:[GoogleDisplayData class]])
    {
        GoogleDisplayData *g = (GoogleDisplayData *)cellData;
        if (g.strName.length > 0 )
            self.lblCountryName.text = g.strName;
        else
            self.lblCountryName.text = g.strId;
        self.btnCheckmark.selected = g.isSelected;
    }
}
@end
