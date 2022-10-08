//
//  CustomNav.m
//  HuddleFly
//
//  Created by Jignesh on 02/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "CustomNav.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface CustomNav ()

@end

@implementation CustomNav

- (void)viewDidLoad {
    [super viewDidLoad];
    if (ISIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    if ([AppDelegate sharedAppDelegate].isLogin) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if ([AppDelegate sharedAppDelegate].isLogin) {
        return UIStatusBarStyleLightContent;
    } else{
        return UIStatusBarStyleDefault;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
