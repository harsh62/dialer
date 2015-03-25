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



- (void)requestInAppDialer{
    LogTrace(@"");

    //    SKProduct
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers:[NSSet setWithObject: @"Hachi.YoBu.InAppDialerPurchase"]];
    request.delegate = self;
    [request start];
}

#pragma mark In App Purchase Delegates
///////////IN APP PURCHASE DELEGATES
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    LogTrace(@"");

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSArray *myProduct = response.products;
    self.productInAppDialer = [myProduct objectAtIndex:0];
    if(self.shouldPaymentProcessBeInititated){
        [self startPaymentProcessForInAppDialer];
        self.shouldPaymentProcessBeInititated = NO;
    }
}


-(void) startPaymentProcessForInAppDialer{
    LogTrace(@"");

    if(self.productInAppDialer){
        SKPayment *newPayment = [SKPayment paymentWithProduct:self.productInAppDialer];
        [[SKPaymentQueue defaultQueue] addPayment:newPayment];
    }
    else{
        self.shouldPaymentProcessBeInititated = YES;
        [self requestInAppDialer];
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
