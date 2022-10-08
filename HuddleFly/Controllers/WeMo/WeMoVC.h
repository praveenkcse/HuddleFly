//
//  WeMoVC.h
//  HuddleFly
//
//  Created by BMAC on 30/10/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import "WemoCell.h"

@interface WeMoVC : BaseVC<UITableViewDelegate,UITableViewDataSource,WeMoSelectedSwitch>
{
    NSMutableArray *arrWemo;
    
    IBOutlet UITableView *tblWeMo;
}
@end
