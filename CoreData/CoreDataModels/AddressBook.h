//
//  AddressBook.h
//  YoBu
//
//  Created by Harshdeep  Singh on 07/03/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AddressBook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * recordId;

@end
