//
//  DataAccessLayer.m
//  YoBu
//
//  Created by Harsh on 23/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "DataAccessLayer.h"
#import "DataManager.h"
#import "DialedNumbers.h"
#import "FrequentContacts.h"
#import "FavoriteContacts.h"
#import "CustomSearchAlphabets.h"

#define ENTITY_DIALED_NUMBERS       @"DialedNumbers"
#define ENTITY_FAVORITE_CONTACTS    @"FavoriteContacts"
#define ENTITY_FREQUENT_CONTACTS    @"FrequentContacts"
#define ENTITY_CUSTOM_SEARCH        @"CustomSearchAlphabets"



@implementation DataAccessLayer

/*
 *********************************************************************************************************************
 DOCUMENT SAVE - This method stores the list of Documents,returned by the backend
 *********************************************************************************************************************
 */
+ (void)saveDialedNumber:(NSString*)phoneNumber forContactName:(NSString*)contactName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        
        //Making n entry for the history of the phone call made
        DialedNumbers *dialedNumberModel = (DialedNumbers*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_DIALED_NUMBERS inManagedObjectContext:managedObjectContext];
        dialedNumberModel.name = contactName;
        dialedNumberModel.phoneNumber = phoneNumber;
        dialedNumberModel.callDateAndTime = [formatter stringFromDate:[NSDate date]];
        
        
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FREQUENT_CONTACTS
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND phoneNumber == %@",contactName,phoneNumber];
        [fetchRequest setPredicate:predicate];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([frequentContactsArray count]>0){
            FrequentContacts *frequentContactsModel = [frequentContactsArray objectAtIndex:0];
            frequentContactsModel.counter = [NSString stringWithFormat:@"%ld",frequentContactsModel.counter.integerValue +1];
        }
        else{
            FrequentContacts *frequentContactsModel = (FrequentContacts*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_FREQUENT_CONTACTS inManagedObjectContext:managedObjectContext];
            frequentContactsModel.name = contactName;
            frequentContactsModel.phoneNumber = phoneNumber;
            frequentContactsModel.counter = @"1";
        }
        [managedObjectContext save:&error];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

+ (NSMutableArray *)fetchFrequentContacts{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FREQUENT_CONTACTS
                                                  inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"counter" ascending:NO selector:@selector(localizedStandardCompare:)]; // ascending YES = start with earliest date
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchLimit:20];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *arrayOfFavoriteContacts = [[NSMutableArray alloc] init];
        for(FrequentContacts *frequentContacts in frequentContactsArray){
            NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
            [contactDictionary setValue:frequentContacts.name forKey:@"name"];
            [contactDictionary setValue:frequentContacts.phoneNumber forKey:@"phoneNumber"];
            [contactDictionary setValue:@"NO" forKey:@"hasProfilePicture"];
            [arrayOfFavoriteContacts addObject:contactDictionary];
        }
        return arrayOfFavoriteContacts;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

+ (NSArray *)fetchRecentlyDialedContacts{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_DIALED_NUMBERS
                                                  inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"callDateAndTime" ascending:NO selector:@selector(localizedStandardCompare:)]; // ascending YES = start with earliest date
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        return frequentContactsArray;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

+ (NSArray *)fetchAllFrequentContacts{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FREQUENT_CONTACTS
                                                  inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"counter" ascending:NO selector:@selector(localizedStandardCompare:)]; // ascending YES = start with earliest date
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        return frequentContactsArray;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}





+ (void)saveCustomSearchForDigit:(NSString*)digit withAlphabets:(NSString*)alphabets
{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_CUSTOM_SEARCH
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"digit == %@",digit];
        [fetchRequest setPredicate:predicate];
        NSArray * digitsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([digitsArray count]>0){
            CustomSearchAlphabets *digitModel = [digitsArray objectAtIndex:0];
            digitModel.containingAlphabets = alphabets;
        }
        else{
            CustomSearchAlphabets *digitModel = (CustomSearchAlphabets*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_CUSTOM_SEARCH inManagedObjectContext:managedObjectContext];
            digitModel.digit = digit;
            digitModel.containingAlphabets = alphabets;
        }
        [managedObjectContext save:&error];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

+ (NSString *)fetchCustomAlphabetsForDigit:(NSString*)digit
{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_CUSTOM_SEARCH
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"digit == %@",digit];
        [fetchRequest setPredicate:predicate];
        NSArray * digitsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([digitsArray count]>0){
            CustomSearchAlphabets *customSearchAlphabetsModel =  [digitsArray objectAtIndex:0];
            return customSearchAlphabetsModel.containingAlphabets;
        }
        else{
            return @"";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

+ (void)checkAndUpdateTabelWithDefaultAlphabets{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_CUSTOM_SEARCH
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray * digitsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultEnglishAlphabets" ofType:@"plist"];
        NSArray *arrayOfDefaultAlphabets = [[NSArray alloc] initWithContentsOfFile:path];
        
        if([arrayOfDefaultAlphabets count] != [digitsArray count]){
            for(NSDictionary *dictionaryInPlist in arrayOfDefaultAlphabets){
                [self saveCustomSearchForDigit:[dictionaryInPlist valueForKey:@"digit"] withAlphabets:[dictionaryInPlist valueForKey:@"containingAlphabets"]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}


+ (void)saveFavoriteContactsWithName:(NSString*)name andWithPhoneNumber:(NSString*)phoneNumber andWithImageData:(NSData *) imageData{

    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FAVORITE_CONTACTS
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND phoneNumber == %@",name,phoneNumber];
        [fetchRequest setPredicate:predicate];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([frequentContactsArray count]>0){
            FavoriteContacts *favoriteContactsModel = [frequentContactsArray objectAtIndex:0];
            favoriteContactsModel.name = name;
            favoriteContactsModel.phoneNumber = phoneNumber;
            favoriteContactsModel.image = imageData;
        }
        else{
            FavoriteContacts *favoriteContactsModel = (FavoriteContacts*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_FAVORITE_CONTACTS inManagedObjectContext:managedObjectContext];
            favoriteContactsModel.name = name;
            favoriteContactsModel.phoneNumber = phoneNumber;
            if(imageData != nil)
                favoriteContactsModel.image = imageData;
        }
        [managedObjectContext save:&error];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}


+ (NSArray *)fetchAllFavoriteContacts{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedInstance] managedObjectContext];
    NSError *error;
    @try {
        //Making an entry in order to priorotize the favorite contact
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FAVORITE_CONTACTS
                                                  inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO selector:@selector(localizedStandardCompare:)]; // ascending YES = start with earliest date
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray * frequentContactsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        return frequentContactsArray;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception Name: %@ ---> Reason of exception:%@",exception.name,exception.reason);
    }
}

@end

