//
//  ContactsInstance.m
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "ContactsInstance.h"
@import AddressBook;

@implementation ContactsInstance
@synthesize delegateOfThisClass; //synthesise  MyClassDelegate delegate


+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void) setCustomDelegate:(id)delegate{
    self.delegateOfThisClass = delegate;
}



- (void)requestAllProducts{
    LogTrace(@"");
    //    SKProduct
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers:[NSSet setWithArray:@[@"Hachi.YoBu.InAppDialerPurchase", @"Hachi.YoBu.CustomizeSearch"]]];
    request.delegate = self;
    [request start];
}

#pragma mark In App Purchase Delegates
///////////IN APP PURCHASE DELEGATES
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    LogTrace(@"");
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSArray *allProducts = response.products;
    
    for(SKProduct *product in allProducts){
        if([product.productIdentifier isEqualToString:@"Hachi.YoBu.InAppDialerPurchase"]){
            self.productInAppDialer = product;
        }
        else if([product.productIdentifier isEqualToString:@"Hachi.YoBu.CustomizeSearch"]){
            self.productInSearchCustomize = product;
        }
    }
    
    if(self.shouldPaymentProcessBeInititated){
        [self startPaymentProcessForProductIdentifier:self.productIdentifier];
        self.shouldPaymentProcessBeInititated = NO;
        self.productIdentifier = nil;
    }
    else{
        UITabBarController *rootController=(UITabBarController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
        self.delegateOfThisClass = rootController.selectedViewController;
        [self.delegateOfThisClass didRecieveProductData];
    }

}


-(void) startPaymentProcessForProductIdentifier:(NSString *)productIdentifier{
    LogTrace(@"");
    SKPayment *newPayment;
    
    if(self.productInAppDialer || self.productInSearchCustomize){
        if([productIdentifier isEqualToString:@"Hachi.YoBu.InAppDialerPurchase"]){
            newPayment = [SKPayment paymentWithProduct:self.productInAppDialer];
        }
        else if([productIdentifier isEqualToString:@"Hachi.YoBu.CustomizeSearch"]){
            newPayment = [SKPayment paymentWithProduct:self.productInSearchCustomize];
        }
        [[SKPaymentQueue defaultQueue] addPayment:newPayment];
    }
    else{
        [self requestAllProducts];
        self.shouldPaymentProcessBeInititated = YES;
        self.productIdentifier = productIdentifier;
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    LogTrace(@"");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    LogTrace(@"");
    [self.delegateOfThisClass transactionCompleted];
    
    NSLog(@"Transaction Completed");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    LogTrace(@"");
    [self.delegateOfThisClass transactionCompleted];

    
    NSLog(@"Transaction Restored");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    LogTrace(@"");
    [self.delegateOfThisClass transactionFailed];

    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}





@end
