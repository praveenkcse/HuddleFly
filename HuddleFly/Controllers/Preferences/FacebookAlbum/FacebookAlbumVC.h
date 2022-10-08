//
//  FacebookAlbumVC.h
//  HuddleFly
//
//  Created by BMAC on 17/08/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface FacebookAlbumVC : BaseVC
{
    NSMutableArray *arrFBAlbum;
}
//@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (nonatomic, weak) IBOutlet UIButton *btnFacebook;
@property (nonatomic, weak) IBOutlet UITableView *tblFBAlbum;
    
@property (nonatomic,weak)IBOutlet UITextField *pixTransitionTextField;
    
    - (IBAction)onClickTextField:(UITextField *)sender;
    
@end
