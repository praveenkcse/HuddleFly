//
//  FBLoginClass.h
//  FBVideoSharing
//
//  Created by BMAC on 11/07/16.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FacebookSecret          @"30f520ec8430980e352e0ae4d5ff3095"
#define FacebookAPPID           @"428719957301782"
#define FacebookRedirectUri     @"http://localhost/bmac"
#define HostApp                 @"localhost"

//#define FacebookBaseURL         @"https://graph.facebook.com/"
//#define FacebookClientToken     @"5f1cef038e1ebcbfe9153b5cf601f7f0"


@protocol FBLoginClassDelegate <NSObject>
@optional
- (void)startProcessing;
- (void)stopProcessing;
- (void)finishFetchingWithResponse:(NSDictionary *)dict error:(NSError *)err;

@end

@interface FBLoginClass : UIView  <UIWebViewDelegate>

@property (nonatomic , retain) NSString *strFacebookSecretKey;
@property (nonatomic , retain) NSString *strFacebookAppID;
@property (nonatomic , retain) NSString *strFacebookRedirectURI;
@property (nonatomic , retain) NSString *strFacebookHostApp;
@property (nonatomic , retain) NSString *strFields;

@property (nonatomic , weak)id<FBLoginClassDelegate> delegate;


+ (void)clearCookie;
+ (BOOL)isTokenExpire;
+ (NSString *)getFBToken;

- (id)initWithFrame:(CGRect)frame;
- (void)authenticationWithFB;
- (void)closeBtnPressed;
- (void)fetchUserLoginDetails;



@end
