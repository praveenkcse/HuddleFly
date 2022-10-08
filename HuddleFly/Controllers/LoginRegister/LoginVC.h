//
//  LoginVC.h
//  HuddleFly
//
//  Created by Jignesh on 28/08/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginVC : BaseVC<UIWebViewDelegate, GIDSignInUIDelegate, GIDSignInDelegate>
- (IBAction)onClickFB:(id)sender;
- (IBAction)onClickGP:(id)sender;
- (IBAction)onClickEmail:(id)sender;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleLoginView;

@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@end
