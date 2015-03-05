//
//  HomeViewController.m
//  YoBu
//
//  Created by Harshdeep  Singh on 14/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTableViewCell.h"
#import <NotificationCenter/NotificationCenter.h>
#import "UIColor+HexColor.h"
@import AddressBook;
#import "DataAccessLayer.h"

UINavigationController *navigationController;

@implementation HomeViewController

-(void)viewDidLoad{
    [self.navigationController.navigationBar setHidden:YES];
    
    self.dialerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dialerView.layer.shadowRadius = 6.f;
    self.dialerView.layer.shadowOffset = CGSizeMake(0.f, -10.f);
    self.dialerView.layer.shadowOpacity = 0.4f;
    self.dialerView.clipsToBounds = NO;
    
    self.imageViewForCircle.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageViewForCircle.layer.shadowRadius = 3.f;
    self.imageViewForCircle.layer.shadowOffset = CGSizeMake(2.f, 3.f);
    self.imageViewForCircle.layer.shadowOpacity = 1.f;
    self.imageViewForCircle.clipsToBounds = NO;
    
    
    self.listOfAllContactsInWidget = [[NSMutableArray alloc] init];
    self.filteredContacts = [[NSMutableArray alloc] init];
    self.arrayOfSearchCombinationsFormed = [[NSMutableArray alloc] init];
    
    //set delegates
    self.searchBarOnTableForContacts.delegate = self;
    
    
    [DataAccessLayer checkAndUpdateTabelWithDefaultAlphabets];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestContacts];
    });
    
//    [self makeRandomContacts];
    
//    [self setAttributedTextWithString:@"1\n " onButton:self.buttonOne];
//    [self setAttributedTextWithString:@"2\nABC" onButton:self.buttonTwo];
//    [self setAttributedTextWithString:@"3\nDEF" onButton:self.buttonThree];
//    [self setAttributedTextWithString:@"4\nGHI" onButton:self.buttonFour];
//    [self setAttributedTextWithString:@"5\nJKL" onButton:self.buttonFive];
//    [self setAttributedTextWithString:@"6\nMNO" onButton:self.buttonSix];
//    [self setAttributedTextWithString:@"7\nPQRS" onButton:self.buttonSeven];
//    [self setAttributedTextWithString:@"8\nTUV" onButton:self.buttonEight];
//    [self setAttributedTextWithString:@"9\nWXYZ" onButton:self.buttonNine];
//    [self setAttributedTextWithString:@"0\n+" onButton:self.buttonZero];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MaterialDesignColors" ofType:@"plist"];
    self.materialDesignPalletArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    
    //Add LongPress Gesture on backspace
    [self addGestureToBackSpaceForLongPress];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeOnDialerView)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.dialerView addGestureRecognizer:recognizer];
    
    
//    self.tableViewForContactsSearched 
    
}

-(void) makeRandomContacts{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    
    // create 200 random contacts
    for (int i = 0; i < 8000; i++)
    {
        // create an ABRecordRef
        ABRecordRef record = ABPersonCreate();
        
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABStringPropertyType);
        
        NSString *email = [NSString stringWithFormat:@"%i@%ifoo.com", i, i];
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(email), kABHomeLabel, NULL);
        
        NSString *fname = [NSString stringWithFormat:@"Name %i", i];
        NSString *lname = [NSString stringWithFormat:@"Last %i", i];
        
        // add the first name
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)(fname), NULL);
        
        // add the last name
        ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)(lname), NULL);
        
        // add the home email
        ABRecordSetValue(record, kABPersonEmailProperty, multi, NULL);
        
        ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        
        NSString *petPhoneNumber = [NSString stringWithFormat:@"000000%i", i];

        ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)petPhoneNumber, kABPersonPhoneMainLabel, NULL);
        
        ABRecordSetValue(record, kABPersonPhoneProperty, phoneNumbers, nil);
        
        // add the record
        ABAddressBookAddRecord(addressBookRef, record, NULL);
    }
    
    // save the address book
    ABAddressBookSave(addressBookRef, NULL);
    
    // release
    CFRelease(addressBookRef);
}

-(void)viewDidAppear:(BOOL)animated{
    
    rectImageViewBlueCircle = self.imageViewForCircle.frame;
    rectImageViewCall = self.imageViewCall.frame;
    rectOfDialerView = self.dialerView.frame;
    rectImageViewRedCircle =self.imageViewRedCircle.frame;
    rectImageViewDialPad = self.imageViewDialPad.frame;
    

    [self.dialerView setHidden:YES];
    [self.imageViewRedCircle setHidden:NO];
    [self.imageViewDialPad setHidden:NO];
    [self.dialPadMenuButton setHidden:NO];


    
    if(self.isCallFromWidget){
        [self openAddContactController];
    }
    
    self.isApplicationAlreadyOpen = YES;
    
    
    self.tableViewForContactsSearched.contentOffset = CGPointMake(0, 44);
}


- (void) setAttributedTextWithString:(NSString *)string onButton:(UIButton *)button{
    NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:string];
    //Bold the first four characters.
    [stringText addAttribute: NSFontAttributeName value: [UIFont fontWithName:@"CourierNewPS-BoldMT"  size:13.0] range: NSMakeRange(1, stringText.string.length-1)];
    // Sets the font color of last four characters to green.
    [stringText addAttribute: NSForegroundColorAttributeName value: [UIColor darkGrayColor] range: NSMakeRange(1, stringText.string.length-1)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0.0f];
    [paragraphStyle setMaximumLineHeight:7.0f];
    [stringText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];

    
    [button setAttributedTitle:stringText forState:UIControlStateNormal];
    [button.titleLabel setNumberOfLines:0];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

#pragma mark Actions
- (IBAction)callButtonPressed:(id)sender {
    if(self.labelTypedNumber.text.length>0){
        [self callOnNumber:self.labelTypedNumber.text];
    }
}

- (IBAction)numberPadPressed:(id)sender {
    
    
    UIButton *buttonPressed = (UIButton *)sender;
    
    if(buttonPressed.tag<10){
        self.labelTypedNumber.text = [self.labelTypedNumber.text stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)buttonPressed.tag]];
    }
    
    if(self.labelTypedNumber.text.length >0){
        [self makeCombinationsWithNumberPressed:buttonPressed.tag];
    }
    else{
        [self.arrayOfSearchCombinationsFormed removeAllObjects];
    }
    
    [self searchContact];
    
}


#pragma mark Search Logic
- (void) searchContact{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber CONTAINS[cd] %@", self.labelTypedNumber.text];
    self.filteredContacts = [[NSMutableArray alloc] initWithArray:[self.listOfAllContactsInWidget filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *notPredicate = [NSPredicate predicateWithFormat:@"NOT (phoneNumber CONTAINS[cd] %@)", self.labelTypedNumber.text];
    NSArray *notArray = [self.listOfAllContactsInWidget filteredArrayUsingPredicate:notPredicate];
    
    
    NSArray *arrayToTraversed = [[NSArray alloc] initWithArray:self.arrayOfSearchCombinationsFormed];
    for(NSString *combination in arrayToTraversed){
        NSPredicate *predicateInsideLoop = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", combination];
        NSArray *filteredContactByName = [notArray filteredArrayUsingPredicate:predicateInsideLoop];
        if([filteredContactByName count]>0){
            [self.filteredContacts addObjectsFromArray:filteredContactByName];
        }
        else{
            [self.arrayOfSearchCombinationsFormed removeObject:combination];
        }
    }
    
    //filling the dictionary for further reference when the user clicks on the backspace
    if(self.labelTypedNumber.text.length>0){
        [self.dictionaryOfCombination setObject:self.arrayOfSearchCombinationsFormed forKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.labelTypedNumber.text.length]];
    }
    
    //Populate the table when there is nothing to search
    if(self.labelTypedNumber.text.length ==0)
        self.filteredContacts = self.listOfAllContactsInWidget;
  
    [self.tableViewForContactsSearched reloadData];
}

-(void) makeCombinationsWithNumberPressed:(NSInteger)numberPressed{
    NSArray *arrayOfLetters = nil;
    NSString *alphabetData = [DataAccessLayer fetchCustomAlphabetsForDigit:[NSString stringWithFormat:@"%ld",(long)numberPressed]];
    if(alphabetData.length >0){
        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[alphabetData length]];
        [alphabetData enumerateSubstringsInRange:NSMakeRange(0, alphabetData.length)
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                          [characters addObject:substring];
                                      }];
        arrayOfLetters = [NSArray arrayWithArray:characters];
    }
    else if(numberPressed==0){
        arrayOfLetters = @[@" "];
    }
    
    if(!arrayOfLetters)
        arrayOfLetters = [[NSArray alloc] initWithObjects:@"***", nil];
    
    [self traverseToMakeCombinationsWithArray:arrayOfLetters];
}

-(void) traverseToMakeCombinationsWithArray:(NSArray *)arrayOfLetters{
    if([self.arrayOfSearchCombinationsFormed count]==0 && self.labelTypedNumber.text.length==1){
        [self.arrayOfSearchCombinationsFormed addObjectsFromArray:arrayOfLetters];
    }
    else{
        NSArray *copiedArrayForEnumeration = [NSArray arrayWithArray:self.arrayOfSearchCombinationsFormed];
        [self.arrayOfSearchCombinationsFormed removeAllObjects];
        for(NSString *combination in copiedArrayForEnumeration){
            for(NSString *combinationWithLetter in arrayOfLetters){
                [self.arrayOfSearchCombinationsFormed addObject:[combination stringByAppendingString:combinationWithLetter]];
            }
        }
    }
}

#pragma mark Call Phone
- (void) callOnNumber:(NSString *)phoneNumber{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }

}

#pragma mark Add Contact
- (IBAction)addContact:(id)sender {
    //TODO
    self.phoneNumber = self.labelTypedNumber.text;
    [self openAddContactController];
}


#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredContacts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = nil;
    NSMutableDictionary *filteredContactForTableView = [self.filteredContacts objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *name = [filteredContactForTableView valueForKey:@"name"];
    NSString *number = [filteredContactForTableView valueForKey:@"phoneNumber"];
    
    if(name.length > 0)
        cell.name.text = name;
    else
        cell.name.text = @"Unknown name";
    
    if(number.length > 0)
        cell.phoneNumber.text = number;
    else
        cell.phoneNumber.text = @"No Phone Number";
    
    BOOL retVal = 0;
    NSArray *allKeys = [filteredContactForTableView allKeys];
    retVal = [allKeys containsObject:@"hasProfilePicture"];
    
    if(retVal){
        if([[filteredContactForTableView valueForKey:@"hasProfilePicture"] isEqualToString:@"YES"]){
//            UIImage *profilePicture = [filteredContactForTableView objectForKey:@"profilePicture"];
//            cell.imageViewProfilePicture.image = profilePicture;
            [cell.labelImageTitle setHidden:YES];
        }else{
            [cell.labelImageTitle setHidden:NO];
//            [cell.imageViewProfilePicture setHidden:YES];
            
            NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
            
            cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
            cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
            [cell.labelImageTitle setText:[cell.name.text substringToIndex:1].uppercaseString];
        }
    }
    else{
        [cell.labelImageTitle setHidden:NO];
//        [cell.imageViewProfilePicture setHidden:YES];
        
        NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
        
        cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
        cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelImageTitle setText:[name substringToIndex:1].uppercaseString];
    }
    
//    cell.labelImageTitle.layer.cornerRadius = cell.imageViewProfilePicture.layer.bounds.size.width/2.0;
    [cell.labelImageTitle.layer setMasksToBounds:YES];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *filteredContactForTableView = [self.filteredContacts objectAtIndex:indexPath.row];
    NSString *phoneNumberToCallOn = [filteredContactForTableView valueForKey:@"phoneNumber"];
    [DataAccessLayer saveDialedNumber:[filteredContactForTableView valueForKey:@"phoneNumber"] forContactName:[filteredContactForTableView valueForKey:@"name"]];
    [self callOnNumber:phoneNumberToCallOn];
}

#pragma mark Contact Request
- (void)requestContacts{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
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
    //    NSInteger numberOfPeopleTest = ABAddressBookGetPersonCount(addressBook);
    //
    //    NSLog(@"Number of Contacts OLD Approach----->%ld",(long)numberOfPeopleTest);
    //    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    ////////New Approach to Fetch Contacts where it was crashing in certain locations
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, kABPersonSortByLastName);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    ////////
    NSLog(@"Number of Contacts New Approach----->%ld",(long)numberOfPeople);
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *firstNameAndLastName = @"";
        if(firstName != nil && ![firstName isEqualToString:@""] && ![firstName isEqualToString:@"(null)"]){
            firstNameAndLastName = firstName;
        }
        if(lastName != nil && ![lastName isEqualToString:@""] && ![lastName isEqualToString:@"(null)"]){
            firstNameAndLastName = [firstNameAndLastName stringByAppendingString:firstName.length>0?[NSString stringWithFormat:@" %@",lastName]:lastName];;
        }
        ////        CFDataRef imageData = ABPersonCopyImageData(person);
        ////        UIImage *image = [UIImage imageWithData:(__bridge_transfer NSData *)imageData];
        //////        CFRelease(imageData);
        //
        UIImage *img = nil;
        //        if (person != nil && ABPersonHasImageData(person)) {
        //            if ( &ABPersonCopyImageDataWithFormat != nil ) {
        //                // iOS >= 4.1
        //                img= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
        //            }
        //        } else {
        //            img= nil;
        //        }
        //
        if(![firstName isEqualToString:@"Identified As Spam"]){
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
            for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
                NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
                
                //Remove Special Characters
                NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"+1234567890"] invertedSet];
                phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
                
                //Add Dictionary into the array
                NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
                [contactDictionary setValue:firstNameAndLastName forKey:@"name"];
                [contactDictionary setValue:phoneNumber forKey:@"phoneNumber"];
                [contactDictionary setValue:@"YES" forKey:@"hasProfilePicture"];
                if(img != nil){
                    [contactDictionary setObject:img forKey:@"profilePicture"];
                }
                else{
                    [contactDictionary setValue:@"NO" forKey:@"hasProfilePicture"];
                    
                }
                
                [self.listOfAllContactsInWidget addObject:contactDictionary];
            }
            CFRelease(phoneNumbers);
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.filteredContacts = self.listOfAllContactsInWidget;
        [self.tableViewForContactsSearched reloadData];
    });

}



#pragma mark Animations of the Buttons

-(void) callButtonAppearAnimation {
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageViewForCircle.frame = rectImageViewBlueCircle;
    } completion:^(BOOL finished){
    }];
    
    [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageViewCall.frame = rectImageViewCall;
    } completion:^(BOOL finished){
    }];
}

-(void) dialPadButtonAppearAnimation {
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageViewRedCircle.frame = rectImageViewRedCircle;
    } completion:^(BOOL finished){
    }];
    
    [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageViewDialPad.frame = rectImageViewDialPad;
    } completion:^(BOOL finished){
    }];
}

-(void) callButtonDisappearrAnimation {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageViewCall.frame = CGRectMake(self.imageViewCall.frame.origin.x +self.imageViewCall.frame.size.width/2, self.imageViewCall.frame.origin.y+self.imageViewCall.frame.size.height/2,0,0);
        self.imageViewForCircle.frame = CGRectMake(self.imageViewForCircle.frame.origin.x +self.imageViewForCircle.frame.size.width/2, self.imageViewForCircle.frame.origin.y+self.imageViewForCircle.frame.size.height/2,0,0);
    } completion:^(BOOL finished){
    }];
}

- (IBAction)menuButtonClicked:(id)sender {
    self.imageViewCall.frame = CGRectMake(self.imageViewCall.frame.origin.x +self.imageViewCall.frame.size.width/2, self.imageViewCall.frame.origin.y+self.imageViewCall.frame.size.height/2,0,0);
    self.imageViewForCircle.frame = CGRectMake(self.imageViewForCircle.frame.origin.x +self.imageViewForCircle.frame.size.width/2, self.imageViewForCircle.frame.origin.y+self.imageViewForCircle.frame.size.height/2,0,0);
    
    [self toggleVisibilityOfDialPad];
    
    self.dialerView.hidden = NO;
    self.dialerView.frame = CGRectMake(0, self.view.frame.size.height, self.dialerView.frame.size.width, self.dialerView.frame.size.height);
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dialerView.frame =CGRectMake(0, self.view.frame.size.height - self.dialerView.frame.size.height -49, self.dialerView.frame.size.width, self.dialerView.frame.size.height);
        ///To Hide the table view search bar
        self.tableViewForContactsSearched.contentOffset = CGPointMake(0, 44);

    } completion:^(BOOL finished){
    }];
    [self callButtonAppearAnimation];

}

-(void) toggleVisibilityOfDialPad{
    self.imageViewRedCircle.hidden ? [self.imageViewRedCircle setHidden:NO] : [self.imageViewRedCircle setHidden:YES];
    self.imageViewDialPad.hidden ? [self.imageViewDialPad setHidden:NO] : [self.imageViewDialPad setHidden:YES];
    self.dialPadMenuButton.hidden  ? [self.dialPadMenuButton setHidden:NO] : [self.dialPadMenuButton setHidden:YES];
}

-(void)downSwipeOnDialerView{
    
    [self toggleVisibilityOfDialPad];
    
    self.imageViewRedCircle.frame = CGRectMake(self.imageViewRedCircle.frame.origin.x +self.imageViewRedCircle.frame.size.width/2, self.imageViewRedCircle.frame.origin.y+self.imageViewRedCircle.frame.size.height/2,0,0);
    self.imageViewDialPad.frame = CGRectMake(self.imageViewDialPad.frame.origin.x +self.imageViewDialPad.frame.size.width/2, self.imageViewDialPad.frame.origin.y+self.imageViewDialPad.frame.size.height/2,0,0);
    [self dialPadButtonAppearAnimation];

    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dialerView.frame =CGRectMake(0, self.view.frame.size.height, rectOfDialerView.size.width, rectOfDialerView.size.height);
    } completion:^(BOOL finished){
    }];
    
}

#pragma mark BACKSPACE LOGIC
- (IBAction)backspaceButtonPressed:(id)sender {
    [self deleteDigitFromLabelAndUpdateTable];
}

- (void) deleteDigitFromLabelAndUpdateTable{
    if(self.labelTypedNumber.text.length>0){
        self.labelTypedNumber.text = [self.labelTypedNumber.text substringToIndex:self.labelTypedNumber.text.length-1];
        if(self.labelTypedNumber.text.length>0){
            self.arrayOfSearchCombinationsFormed = [self.dictionaryOfCombination valueForKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.labelTypedNumber.text.length]];
        }
        else{
            self.arrayOfSearchCombinationsFormed = [[NSMutableArray alloc] init];
        }
        [self searchContact];
    }
    
}

-(void) addGestureToBackSpaceForLongPress{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    [self.buttonBackSppace addGestureRecognizer:longPress];
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self performSelector:@selector(removeDigitOnLongPress:)  withObject:@"0.3" afterDelay:0.3];
    }
    else if(sender.state == UIGestureRecognizerStateEnded){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

-(void)removeDigitOnLongPress:(NSString *) timeInString{
    [self deleteDigitFromLabelAndUpdateTable];
    NSString *newIntervalInString = [NSString stringWithFormat:@"%f", timeInString.doubleValue*0.70];
    [self performSelector:@selector(removeDigitOnLongPress:)  withObject:newIntervalInString afterDelay:newIntervalInString.doubleValue];
}

#pragma mark    Add New Contact model Controller

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) openAddContactController{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    ABRecordRef record = ABPersonCreate();
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABStringPropertyType);
    
    // add the home email
    ABRecordSetValue(record, kABPersonEmailProperty, multi, NULL);
    
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    
    NSString *petPhoneNumber = self.phoneNumber;
    
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)petPhoneNumber, kABPersonPhoneMainLabel, NULL);
    
    ABRecordSetValue(record, kABPersonPhoneProperty, phoneNumbers, nil);
    
    // add the record
    picker.displayedPerson = record;
    //    picker.navigationItem.title=@"edit contact";
    [picker.navigationController.navigationBar setHidden:NO];
    
    picker.displayedPerson = record;
    //    picker.navigationItem.title=@"edit contact";
    [picker.navigationController.navigationBar setHidden:NO];
    
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigationController animated:YES completion:nil];
    self.isCallFromWidget = NO;
    //    [self.navigationController pushViewController:picker animated:YES];
}

#pragma mark UISearch Bar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchBarSearchFunctionWithWord:searchText];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.dialerView setHidden:YES];
    [self.imageViewRedCircle setHidden:NO];
    [self.imageViewDialPad setHidden:NO];
    [self.dialPadMenuButton setHidden:NO];
    searchBar.showsCancelButton = YES;
    

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBarOnTableForContacts.text = @"";
    [searchBar resignFirstResponder];
    self.filteredContacts = self.listOfAllContactsInWidget;
    [self.tableViewForContactsSearched reloadData];
}

- (void)searchBarSearchFunctionWithWord:(NSString *)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber CONTAINS[cd] %@ OR name CONTAINS[cd] %@", searchText,searchText];
    self.filteredContacts = [[NSMutableArray alloc] initWithArray:[self.listOfAllContactsInWidget filteredArrayUsingPredicate:predicate]];
    
    //Populate the table when there is nothing to search
    if(searchText.length ==0)
        self.filteredContacts = self.listOfAllContactsInWidget;
    
    [self.tableViewForContactsSearched reloadData];
    
    
}

//scroll view delgates
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.imageViewRedCircle.isHidden)
        [self downSwipeOnDialerView];
}

#pragma Mark TouchesBegins 

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event {
    

} 




- (void) touchesMoved:(NSSet *)touches
            withEvent:(UIEvent *)event {
   
}



- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event {
   }



@end
