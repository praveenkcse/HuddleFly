//
//  InAppHelper.h
//  
//
//  Created by BMAC on 15/4/2016.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


/*
#define INAPP_PRODUCT_FCREE_NOADS       @"com.mobilesoftwaredesign.freecaddie.noads"
#define INAPP_PRODUCT_FCREE_PROPACK     @"com.mobilesoftwaredesign.freecaddie.pro"
#define INAPP_PRODUCT_FCREE_AUDIO       @"com.mobilesoftwaredesign.freecaddie.audio"

#define INAPP_PRODUCT_FCPRO_AUDIO       @"com.freecaddiepro.audio"

#define INAPP_PRODUCT_FCAUDIO_NOADS     @"com.freecaddieaudio.noads"
#define INAPP_PRODUCT_FCAUDIO_PROPACK   @"com.freecaddieaudio.pro"
*/

#define INAPP_PRODUCT_FREE    @"HUDDLEFLY00"//@"com.bmac.test.bronze"//
#define INAPP_PRODUCT_BRONZE    @"HUDDLEFLY01"//@"com.bmac.test.bronze"//
#define INAPP_PRODUCT_SILVER    @"HUDDLEFLY02"//@"com.bmac.test.silver"//
#define INAPP_PRODUCT_GOLD      @"HUDDLEFLY03"//@"com.bmac.test.gold"//


typedef enum {
    TransactionPurchasing=0,
    TransactionPurchased,
    TransactionRestored,
    TransactionFailed,
    TransactionNoProduct
} Transaction;

typedef void (^PurchaseResult)(Transaction result, NSError *error);
typedef void (^ProductResult)(BOOL result);

@interface InAppHelper : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSMutableDictionary *allValidProducts;
    BOOL isFetching;
    //blocks
    PurchaseResult dataBlock;
    ProductResult dataBlockProductResult;
}
@property (nonatomic, strong) NSMutableDictionary *allValidProducts;

+ (InAppHelper *)sharedObject;

- (void)fetchAvailableProducts;
- (void)fetchAvailableProductsWithBlock:(ProductResult)block;
- (void)purchaseProduct:(NSString *)productName withBlock:(PurchaseResult)block;
- (void)restoreProductwithBlock:(PurchaseResult)block;

//InApp Methods

- (void)setBronze:(BOOL)isNoAds;
- (void)setSilver:(BOOL)isNoAds;
- (void)setGold:(BOOL)isNoAds;
- (BOOL)isBronze;
- (BOOL)isSilver;
- (BOOL)isGold;
/*
- (void)setAudio:(BOOL)isAudio;
- (BOOL)isAudio;

- (void)setProPack:(BOOL)isProPack;
- (BOOL)isProPack;
*/
@end
