//
//  FavoriteContacts.h
//  YoBu
//
//  Created by Harshdeep  Singh on 22/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavoriteContacts : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * image;

@end
