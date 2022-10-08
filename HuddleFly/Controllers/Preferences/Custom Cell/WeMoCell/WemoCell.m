//
//  WemoCell.m
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "WemoCell.h"
#import "LocalEvents.h"

@implementation WemoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data index:(NSInteger)index{
    if([data isKindOfClass:[WeMo class]]){
        WeMo *w = (WeMo *)data;
        _lblSwitchName.text = w.strSwitch;
        _lblDate.text = [NSString stringWithFormat:@"Last Contact :%@",w.strLastContactDate];
        int no = [w.strStatus intValue];
        if(no == 1)
        {
            [_swt setOn:YES];
        }
        if(_swt.isOn)
            [_swt setOn:YES];
        else
            [_swt setOn:NO];
        _swt.tag=index;
    }
}

- (void)swtTapped:(id)sender
{
    if(_swt.isOn)
    {
        [_swt setOn:YES];
        //[_delegate selectedSwitch:_swt.tag];
    }
    else{
        [_swt setOn:NO];
    }
    [_delegate selectedSwitch:_swt.tag status:_swt.isOn];
}



@end
