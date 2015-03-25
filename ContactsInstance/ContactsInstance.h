//
//  ContactsInstance.h
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@protocol ContactsInstanceDelegate <NSObject>
@required
- (void) transactionCompleted;
- (void) transactionFailed;

@end

@interface ContactsInstance : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    // Delegate to respond back
    id <ContactsInstanceDelegate> _delegateOfThisClass;
}

+ (id)sharedInstance;
@property (strong,nonatomic) id delegateOfThisClass; //define MyClassDelegate as delegate
-(void)setCustomDelegate:(id)delegate;

//InApp Dialer Methods
@property (strong,atomic) SKProduct *productInAppDialer;
@property BOOL shouldPaymentProcessBeInititated;

- (void)requestInAppDialer;
- (void)startPaymentProcessForInAppDialer;



@end
