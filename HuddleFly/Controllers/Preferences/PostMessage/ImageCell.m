//
//  ImageCell.m
//  HuddleFly
//
//  Created by Anton Boyarkin on 17/04/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (IBAction)removeImage:(id)sender {
    if (_removeImage) _removeImage();
}
    
    - (void)imageData :(NSString *)strUrl {
        
        self.imageView.image = [UIImage imageNamed:@"imagePlaceholder"];
        
        
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
                                           if (img) {
                                               self.imageView.image = img;
                                               if (_imageLoaded) _imageLoaded(img);
                                           }
                                       });
                                       
                                   }
                                   
                               }];
        
    }
@end
