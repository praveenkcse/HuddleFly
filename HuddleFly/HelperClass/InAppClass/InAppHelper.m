//
//  InAppHelper.m
//  
//
//  Created by BMAC on 15//4/2016.
//  Copyright (c) 2016 BMAC. All rights reserved.
//

#import "InAppHelper.h"
//#import "Constants.h"
//#import "UserSettings.h"

#define UD_IS_SILVER        @"SILVER"
#define UD_IS_BRONZE        @"BRONZE"
#define UD_IS_GOLD          @"GOLD"

//#define UD_IS_PRO_PACK      @"isProPack"
//#define UD_IS_AUDIO         @"isAudio"

@implementation InAppHelper

@synthesize allValidProducts;

#pragma mark - Init

-(id)init
{
    self=[super init];
    if (self) {
        allValidProducts=[[NSMutableDictionary alloc]init];
        [self fetchAvailableProducts];
    }
    return self;
}

+ (InAppHelper *)sharedObject
{
    static InAppHelper *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[InAppHelper alloc] init];
    });
    return object;
}

#pragma mark - InApp Methods For Users

- (void)setBronze:(BOOL)isNoAds {
    [[NSUserDefaults standardUserDefaults] setBool:isNoAds forKey:UD_IS_BRONZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSilver:(BOOL)isNoAds {
    [[NSUserDefaults standardUserDefaults] setBool:isNoAds forKey:UD_IS_SILVER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setGold:(BOOL)isNoAds {
    [[NSUserDefaults standardUserDefaults] setBool:isNoAds forKey:UD_IS_GOLD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)isBronze {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UD_IS_BRONZE];
}

- (BOOL)isSilver {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UD_IS_SILVER];
}

- (BOOL)isGold {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UD_IS_GOLD];
}

#pragma mark - GetAll Product

-(void)fetchAvailableProducts
{
    isFetching=TRUE;
    NSSet *productIdentifiers = nil;
    
    productIdentifiers = [NSSet setWithObjects:INAPP_PRODUCT_BRONZE,INAPP_PRODUCT_GOLD,INAPP_PRODUCT_SILVER, nil];
    
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void)fetchAvailableProductsWithBlock:(ProductResult)block
{
    dataBlockProductResult=[block copy];
    if (!isFetching) {
        [self fetchAvailableProducts];
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    int count = (int)[response.products count];
    if (count>0) {
        
        for (NSString *key in [allValidProducts allKeys]) {
            [allValidProducts removeObjectForKey:key];
        }
        
        for (int i=0; i<response.products.count; i++)
        {
            SKProduct *validProduct = [response.products objectAtIndex:i];
            [allValidProducts setObject:validProduct forKey:validProduct.productIdentifier];
        }
        if (dataBlockProductResult) {
            dataBlockProductResult(TRUE);
        }
    }
    else {
        if (dataBlockProductResult) {
            dataBlockProductResult(FALSE);
        }
       NSLog(@"No products to purchase :%@",response.invalidProductIdentifiers);
    }
    isFetching=FALSE;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request failed: %@,  %@", request, error);
    if (dataBlockProductResult) {
        dataBlockProductResult(FALSE);
    }
    isFetching=FALSE;
}

#pragma mark -
#pragma mark - Restore Product

-(void)restoreProductwithBlock:(PurchaseResult)block
{
    dataBlock=[block copy];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -
#pragma mark - PurcheseProduct

-(void)purchaseProduct:(NSString *)productName withBlock:(PurchaseResult)block
{
    dataBlock=[block copy];
    if ([allValidProducts objectForKey:productName]!=nil) {
        [self purchaseMyProduct:[allValidProducts objectForKey:productName]];
    }
    else{
        if (dataBlock) {
            dataBlock(TransactionNoProduct, nil);
        }
    }
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product
{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  NSLocalizedString(@"DISABLED", nil) message:NSLocalizedString(@"PURCHASES ARE DISABLED IN YOUR DEVICE", nil) delegate:
                                  self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark - StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                if (dataBlock) {
                    dataBlock(TransactionPurchasing, nil);
                }
                break;
            case SKPaymentTransactionStatePurchased: {
                NSString *productID = transaction.payment.productIdentifier;

                if ([productID isEqualToString:INAPP_PRODUCT_BRONZE]) {
                    [self setBronze:YES];
                }else if ([productID isEqualToString:INAPP_PRODUCT_SILVER]){
                    [self setSilver:YES];
                }else if ([productID isEqualToString:INAPP_PRODUCT_GOLD]){
                    [self setGold:YES];
                }
                
                if (dataBlock) {
                    dataBlock(TransactionPurchased, nil);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored: {
                NSLog(@"Restored ");
                NSString *productID = transaction.payment.productIdentifier;
                if ([productID isEqualToString:INAPP_PRODUCT_BRONZE]) {
                    [self setBronze:YES];
                }else if ([productID isEqualToString:INAPP_PRODUCT_SILVER]){
                    [self setSilver:YES];
                }else if ([productID isEqualToString:INAPP_PRODUCT_GOLD]){
                    [self setGold:YES];
                }
                
                if (dataBlock) {
                    dataBlock(TransactionRestored, nil);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                if (dataBlock) {
                    dataBlock(TransactionFailed, transaction.error);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"restoreCompletedTransactionsFailedWithError = %@",error);
    if (dataBlock) {
        dataBlock(TransactionFailed, error);
    }
}

@end
