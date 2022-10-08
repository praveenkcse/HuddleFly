//
//  MotionCollectionCell.m
//  HuddleFly
//
//  Created by BMAC on 03/11/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "MotionCollectionCell.h"
#import "LocalEvents.h"

@implementation MotionCollectionCell

@synthesize lblAlertMsg,lblAlertType,lblMediaType,tvMediaUrl,lblTimeStamp;
- (void)setCellData:(id)data
{
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if([data isKindOfClass:[AlertList class]])
    {
//        lblAlertMsg.layer.borderWidth = 1.0;
//        lblAlertMsg.layer.borderColor = [UIColor blackColor].CGColor;
//        lblMediaType.layer.borderWidth = 1.0;
//        lblMediaType.layer.borderColor = [UIColor blackColor].CGColor;
//        lblTimeStamp.layer.borderWidth = 1.0;
//        lblTimeStamp.layer.borderColor = [UIColor blackColor].CGColor;
//        tvMediaUrl.layer.borderWidth = 1.0;
//        tvMediaUrl.layer.borderColor = [UIColor blackColor].CGColor;
        
        AlertList *alert = (AlertList *)data;
        lblAlertMsg.text = alert.strAlertMsg;
        lblAlertType.text = alert.strAlertType;
        lblMediaType.text = [alert.strMediaType isEqualToString:@"1"]?@"Picture":@"Video";//alert.strMediaType;
        lblTimeStamp.text = [self scannerTimeStamp:alert.strTimestamp];//alert.strTimestamp;
        tvMediaUrl.text = alert.strMediaUrl;
        
        
    }
}

- (NSString *)scannerTimeStamp:(NSString *)str
{
    NSString *strv = str;
    NSRange rang =NSMakeRange(6, 13);
    NSLog(@"Date :%@",[strv substringWithRange:rang]);
    strv = [strv substringWithRange:rang];
    double time = [strv doubleValue]/1000;
    NSTimeInterval _interval= (NSTimeInterval)time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"Current date :%@",date);
    
    [_formatter setDateFormat:@"MM/dd/yy hh:mm a"];
    //[_formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [_formatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSLog(@"Time Stamp :%@",[_formatter stringFromDate:date]);
    return [_formatter stringFromDate:date];
}

#pragma mark - Textview Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
@end
