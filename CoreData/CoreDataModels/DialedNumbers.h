//
//  DialedNumbers.h
//  YoBu
//
//  Created by Harsh on 23/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DialedNumbers : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * callDateAndTime;

@end
