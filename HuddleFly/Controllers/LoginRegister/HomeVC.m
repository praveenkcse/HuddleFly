//
//  HomeVC.m
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "HomeVC.h"
#import "Global.h"
@implementation HomeVC
-(void)viewDidLoad{
    [super viewDidLoad];
    _loginBtn.tag = 1;
    _createAcountBtn.tag = 1;
    _configureBtn.tag = 1;
    [Global roundBorderSet:_loginBtn];
    [Global roundBorderSet:_createAcountBtn];
    [Global roundBorderSet:_configureBtn];
    
    NSString* isLaunchedFirstTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISFIRSTTIMELAUNCHED"];
    
    if (isLaunchedFirstTime == nil) {
        //show alert
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ISFIRSTTIMELAUNCHED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[[UIAlertView alloc] initWithTitle:@"Please note that this app is used to configure and control content on the HuddleFly device. HuddleFly is a Wi-Fi enabled smart digital signage device. To purchase or for more info about the device please visit huddlefly.co" message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    } }

- (IBAction)configureClicked:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"HuddleFly"
                                          message:@"Have you created a HuddleFly account yet?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *yesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"Ok action")
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action)
                                {
                                    [self performSegueWithIdentifier:@"configure" sender:action];
                                }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"Cancel action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UtilityClass *utility = [[UtilityClass alloc] init];
                                   [utility showAlertWithTitle:@"Please note" andMessage:@"\nYou must create an account before configuration"];
                               }];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}





@end
