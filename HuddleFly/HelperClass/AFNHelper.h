//
//  AFNHelper.h
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"

typedef void (^RequestCompletionBlock)(id response, NSError *error);

@interface AFNHelper : NSObject
{
    //blocks
    RequestCompletionBlock dataBlock;
}
@property(nonatomic,copy)NSString *strReqMethod;

-(id)initWithRequestMethod:(NSString *)method;
-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSMutableDictionary *)dictParam andImage:(UIImage *)image withParamName:(NSString *)imageParam withBlock:(RequestCompletionBlock)block;
-(void)getDataForSSID:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

// Get String value from API
-(void)getStringFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
@end
