//
//  CustomSearchAlphabets.h
//  YoBu
//
//  Created by Harshdeep  Singh on 26/01/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CustomSearchAlphabets : NSManagedObject

@property (nonatomic, retain) NSString * digit;
@property (nonatomic, retain) NSString * containingAlphabets;

@end
