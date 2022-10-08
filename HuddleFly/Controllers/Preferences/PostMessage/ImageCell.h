//
//  ImageCell.h
//  HuddleFly
//
//  Created by Anton Boyarkin on 17/04/2018.
//  Copyright © 2018 AccountIT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell
    
    @property (weak, nonatomic) IBOutlet UIImageView *imageView;
    
    @property (nonatomic, copy) void (^removeImage)(void);
    @property (nonatomic, copy) void (^imageLoaded)(UIImage *image);
    
    
    - (IBAction)removeImage:(id)sender;
    - (void)imageData :(NSString *)strUrl;
    
@end
