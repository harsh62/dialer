//
//  DataManager.h
//  YoBu
//
//  Created by Harsh on 23/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

//Properties
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DataManager*)sharedInstance;
- (void) saveContext;

@end
