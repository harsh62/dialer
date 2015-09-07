//
//  ContactsInstance.h
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"


@protocol ContactsInstanceDelegate <NSObject>


@optional

- (void) transactionCompleted;
- (void) transactionFailed;
- (void) didRecieveProductData;


- (void) restoreCompleted;
- (void) restoreFailed;



@end

@interface ContactsInstance : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    // Delegate to respond back
    id <ContactsInstanceDelegate> _delegateOfThisClass;
}

+ (id)sharedInstance;
@property (strong,nonatomic) id delegateOfThisClass; //define MyClassDelegate as delegate
-(void)setCustomDelegate:(id)delegate;

@property BOOL shouldPaymentProcessBeInititated;
@property (strong,atomic) NSString *productIdentifier;;


-(void)requestAllProducts;
-(void) startPaymentProcessForProductIdentifier:(NSString *)productIdentifier;


//InApp Dialer Methods
@property (strong,atomic) SKProduct *productInAppDialer;
@property (strong,atomic) SKProduct *productInSearchCustomize;


-(void)showNotification;
@property (strong,atomic) UIView *notificationView;

///Restore Transaction
-(void)restoreInAppPurchases;
@property BOOL IsRestoreInitiated;





@end
