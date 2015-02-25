//
//  ContactsInstance.h
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsInstance : NSObject

+ (id)sharedInstance;

@property (strong,nonatomic) NSMutableArray *listOfAllContacts;
- (void)requestContacts;


@end
