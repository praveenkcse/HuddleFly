//
//  AFNHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "AFNHelper.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation AFNHelper

@synthesize strReqMethod;

#pragma mark -
#pragma mark - Init

-(id)initWithRequestMethod:(NSString *)method
{
    if ((self = [super init])) {
        self.strReqMethod=method;
    }
	return self;
}

#pragma mark -
#pragma mark - Methods

-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    //[raw urlEncodeUsingEncoding:NSUTF8Encoding]
    NSString *basePath = kAPI_URL;
    
    NSString *url=[[NSString stringWithFormat:@"%@%@",basePath,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url :%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    if ([self.strReqMethod isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }

        }];
    }
    else{
        [manager GET:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }

        }];
    }
}

-(void)getDataForSSID:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    
    NSString *url=[[NSString stringWithFormat:@"%@",path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if ([self.strReqMethod isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
    else{
        [manager GET:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
}
#pragma mark -
#pragma mark - Post methods(multipart image)

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSMutableDictionary *)dictParam andImage:(UIImage *)image withParamName:(NSString *)imageParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        NSString *basePath = kAPI_URL;
        
        NSString *url=[[NSString stringWithFormat:@"%@%@",basePath,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer.timeoutInterval=600;
        //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        [manager POST:url parameters:dictParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
            //[formData appendPartWithFormData:imageToUpload name:imageParam];
            //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
             [formData appendPartWithFileData:imageToUpload name:imageParam fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"Success: %@", responseObject);
                  if (dataBlock) {
                      dataBlock(responseObject,nil);
                  }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
                  if (dataBlock) {
                      dataBlock(nil,error);
                  }
        }];
    }
}

#pragma mark - Fetch String Value From API

-(void)getStringFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    NSString *basePath = kAPI_URL;
    
    NSString *url=[[NSString stringWithFormat:@"%@%@",basePath,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url :%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
    else{
        [manager GET:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                dataBlock(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
}


@end

/*
 [formData appendPartWithFileData:data1
 name:@"image1"
 fileName:@"image1.jpg"
 mimeType:@"image/jpeg"];
 [formData appendPartWithFileData:data2
 name:@"image2"
 fileName:@"image2.jpg"
 mimeType:@"image/jpeg"];
 */
