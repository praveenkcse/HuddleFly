//
//  UIView+Utils.m
//  iMEME Creator
//
//  Created by Jignesh on 04/01/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "UIView+Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utils)

- (void)applySmallCorner
{
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

- (void)applySmallCornerWithColor:(UIColor *)color {
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)applyFullCornerWithColor:(UIColor *)color {
    self.layer.cornerRadius = (self.frame.size.width/2);
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

@end
