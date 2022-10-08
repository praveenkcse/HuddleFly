//
//  FullScreenVC.m
//  HuddleFly
//
//  Created by BMAC on 28/09/16.
//  Copyright (c) 2016 Jignesh. All rights reserved.
//

#import "FullScreenVC.h"

@interface FullScreenVC ()
@property (nonatomic , weak)IBOutlet UIImageView *imgViewFull;
@end

@implementation FullScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:@""];
    [super setBackBarItem:YES];
    
    [self imageData:_strImageUrl];
}

- (void)imageData :(NSString *)strUrl{
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:strUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if(data){
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImage *img = [UIImage imageWithData:data];
                                       if(img){
                                           
                                           self.imgViewFull.image = img;
                                       }
                                       [self.imgViewFull setNeedsDisplay];
                                       [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                                   });
                               }
                               else
                                   [[AppDelegate sharedAppDelegate] showToastMessage:connectionError.localizedDescription];
                           }];
    
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
