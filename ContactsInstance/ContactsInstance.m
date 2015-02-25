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

@synthesize listOfAllContacts;

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject initializeContactList];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void) initializeContactList{
    self.listOfAllContacts = [[NSMutableArray alloc] init];
}

- (void)requestContacts{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
//        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (error) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        if (addressBook) CFRelease(addressBook);
        return;
    }
    
    if (status == kABAuthorizationStatusNotDetermined) {
        
        // present the user the UI that requests permission to contacts ...
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
            }
            
            if (granted) {
                // if they gave you permission, then just carry on
                
                [self listPeopleInAddressBook:addressBook];
            } else {
                // however, if they didn't give you permission, handle it gracefully, for example...
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                    
//                    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
            
            if (addressBook) CFRelease(addressBook);
        });
        
    } else if (status == kABAuthorizationStatusAuthorized) {
        [self listPeopleInAddressBook:addressBook];
        if (addressBook) CFRelease(addressBook);
    }
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSInteger numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    NSLog(@"Number of Contacts ----->%ld",(long)numberOfPeople);
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        //        NSLog(@"Name:%@ %@", firstName, lastName);
        NSString *firstNameAndLastName;
        if(firstName != nil && ![firstName isEqualToString:@""] && ![firstName isEqualToString:@"(null)"]){
            firstNameAndLastName = firstName;
        }
        if(lastName != nil && ![lastName isEqualToString:@""] && ![lastName isEqualToString:@"(null)"]){
            firstNameAndLastName = [firstNameAndLastName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];;
        }
        
        if(![firstName isEqualToString:@"Identified As Spam"]){
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
            for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
                NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
                //            NSLog(@"  phone:%@", phoneNumber);
                
                
                NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
                [contactDictionary setValue:firstNameAndLastName forKey:@"name"];
                [contactDictionary setValue:phoneNumber forKey:@"phoneNumber"];
                
                [self.listOfAllContacts addObject:contactDictionary];
            }
            CFRelease(phoneNumbers);
        }
        //        NSLog(@"=============================================");
    }
}



@end
