//
//  TodayViewController.m
//  DialerWidget
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "TodayViewController.h"
#import "CustomCell.h"
#import <NotificationCenter/NotificationCenter.h>
@import AddressBook;
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "DataAccessLayer.h"

#define FONT_SIZE 24


@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *labelLandscapeSupport;
@property (weak, nonatomic) IBOutlet UILabel *callLabel;
@end

@implementation TodayViewController

-(void)viewDidLayoutSubviews{

}
-(void)viewWillAppear:(BOOL)animated{
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"height"] == nil)
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",self.containerView.frame.size.height] forKey:@"height"];
    
    if([self orientation] == InterfaceOrientationTypePortrait){
        [self.labelLandscapeSupport setHidden:YES];
        [self.containerView setHidden:NO];
        NSString *height =  [[NSUserDefaults standardUserDefaults] valueForKey:@"height"];
        if(height)
            self.preferredContentSize = CGSizeMake(0, height.floatValue);
    }
    else{
        [self.labelLandscapeSupport setHidden:NO];
        [self.containerView setHidden:YES];
        self.preferredContentSize = CGSizeMake(0, 50);
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self designLabel];
    self.listOfAllContactsInWidget = [[NSMutableArray alloc] init];
    self.arrayOfSearchCombinationsFormed = [[NSMutableArray alloc] init];
    self.dictionaryOfCombination = [[NSMutableDictionary alloc] init];
    self.filteredContacts = [DataAccessLayer fetchFrequentContacts];
    [self.tableViewContacts reloadData];
    [DataAccessLayer checkAndUpdateTabelWithDefaultAlphabets];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestContacts];
    });

    [UIColor colorWithHexString:@""];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MaterialDesignColors" ofType:@"plist"];
    self.materialDesignPalletArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    [self setCustomAlphabetsToUserInterfaceToAllTheLabels];
    
    //Add LongPress Gesture on backspace
    [self addGestureToBackSpaceForLongPress];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    animateAlongsideTransition:completion:
//    NSLog(@"%f",size.height);

//        self.preferredContentSize = CGSizeMake(320, self.containerView.frame.size.height+2);
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}
#pragma mark Actions
- (IBAction)callNumber:(id)sender {
    if(self.callLabel.text.length>0){
        [self callOnNumber:self.callLabel.text];
    }
}

- (IBAction)numberPadButtonPressed:(id)sender {
    
    UIButton *buttonPressed = (UIButton *)sender;
    
    if(buttonPressed.tag<10){
        self.callLabel.text = [self.callLabel.text stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)buttonPressed.tag]];
    }

    if(self.callLabel.text.length >0){
        [self makeCombinationsWithNumberPressed:buttonPressed.tag];
    }
    else{
        [self.arrayOfSearchCombinationsFormed removeAllObjects];
    }
    
    [self searchContact];
}

#pragma mark Search Logic
- (void) searchContact{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber CONTAINS[cd] %@", self.callLabel.text];
    self.filteredContacts = [[NSMutableArray alloc] initWithArray:[self.listOfAllContactsInWidget filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *notPredicate = [NSPredicate predicateWithFormat:@"NOT (phoneNumber CONTAINS[cd] %@)", self.callLabel.text];
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
    if(self.callLabel.text.length>0){
        [self.dictionaryOfCombination setObject:self.arrayOfSearchCombinationsFormed forKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.callLabel.text.length]];
    }
    
    //Populate the table when there is nothing to search
    if(self.callLabel.text.length ==0)
        self.filteredContacts = [DataAccessLayer fetchFrequentContacts];

    [self.contactsTableView reloadData];
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
        if([self.arrayOfSearchCombinationsFormed count]==0 && self.callLabel.text.length==1){
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


#pragma mark UITableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.filteredContacts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = nil;
    NSMutableDictionary *filteredContactForTableView = [self.filteredContacts objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
            UIImage *profilePicture = [filteredContactForTableView objectForKey:@"profilePicture"];
            cell.imageViewProfilePicture.image = profilePicture;
            [cell.labelImageTitle setHidden:YES];
        }else{
            [cell.labelImageTitle setHidden:NO];
            [cell.imageViewProfilePicture setHidden:YES];
            
            NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
            
            cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
            cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
            [cell.labelImageTitle setText:[name substringToIndex:1].uppercaseString];
        }
    }
    else{
        [cell.labelImageTitle setHidden:NO];
        [cell.imageViewProfilePicture setHidden:YES];
        
        NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
        
        cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
        cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelImageTitle setText:[name substringToIndex:1].uppercaseString];
    }
    
    cell.labelImageTitle.layer.cornerRadius = cell.imageViewProfilePicture.layer.bounds.size.width/2.0;
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
        NSString *firstNameAndLastName;
        if(firstName != nil && ![firstName isEqualToString:@""] && ![firstName isEqualToString:@"(null)"]){
            firstNameAndLastName = firstName;
        }
        if(lastName != nil && ![lastName isEqualToString:@""] && ![lastName isEqualToString:@"(null)"]){
            firstNameAndLastName = [firstNameAndLastName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];;
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
                NSArray *arrayOfSpecialCharacters = @[@"(",@")",@"-",@" "];
                for(NSString *character in arrayOfSpecialCharacters)
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:character withString:@""];
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
}
#pragma mark Call Phone
- (void) callOnNumber:(NSString *)phoneNumber{
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]] completionHandler:nil];
}

#pragma mark Add Contact
- (IBAction)addContact:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"addContact://%@",self.callLabel.text]] completionHandler:nil];
}

#pragma mark Designing
- (void) designButtons{
    self.one.layer.cornerRadius = self.one.bounds.size.width/2.0;
    self.one.layer.borderWidth = 1.0;
//    self.one.layer.backgroundColor = [[UIColor clearColor] CGColor];

    self.one.layer.borderColor = self.one.titleLabel.textColor.CGColor;
    self.one.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.two.layer.cornerRadius = self.two.bounds.size.width/2.0;
    self.two.layer.borderWidth = 1.0;
    self.two.layer.borderColor = self.two.titleLabel.textColor.CGColor;
    self.two.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.three.layer.cornerRadius = self.three.bounds.size.width/2.0;
    self.three.layer.borderWidth = 1.0;
    self.three.layer.borderColor = self.three.titleLabel.textColor.CGColor;
    self.three.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.four.layer.cornerRadius = self.four.bounds.size.width/2.0;
    self.four.layer.borderWidth = 1.0;
    self.four.layer.borderColor = self.four.titleLabel.textColor.CGColor;
    self.four.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.five.layer.cornerRadius = self.five.bounds.size.width/2.0;
    self.five.layer.borderWidth = 1.0;
    self.five.layer.borderColor = self.five.titleLabel.textColor.CGColor;
    self.five.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.six.layer.cornerRadius = self.six.bounds.size.width/2.0;
    self.six.layer.borderWidth = 1.0;
    self.six.layer.borderColor = self.six.titleLabel.textColor.CGColor;
    self.six.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.seven.layer.cornerRadius = self.seven.bounds.size.width/2.0;
    self.seven.layer.borderWidth = 1.0;
    self.seven.layer.borderColor = self.seven.titleLabel.textColor.CGColor;
    self.seven.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.eight.layer.cornerRadius = self.eight.bounds.size.width/2.0;
    self.eight.layer.borderWidth = 1.0;
    self.eight.layer.borderColor = self.eight.titleLabel.textColor.CGColor;
    self.eight.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.nine.layer.cornerRadius = self.nine.bounds.size.width/2.0;
    self.nine.layer.borderWidth = 1.0;
    self.nine.layer.borderColor = self.nine.titleLabel.textColor.CGColor;
    self.nine.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.zero.layer.cornerRadius = self.zero.bounds.size.width/2.0;
    self.zero.layer.borderWidth = 1.0;
    self.zero.layer.borderColor = self.zero.titleLabel.textColor.CGColor;
    self.zero.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    self.callButton.layer.cornerRadius = 4.0;
    self.callButton.layer.borderWidth = 0.0;
    self.callButton.layer.borderColor = self.zero.titleLabel.textColor.CGColor;
    
    self.backspace.layer.cornerRadius = 3.0;
    self.backspace.layer.borderWidth = 0.0;
    self.backspace.layer.borderColor = self.zero.titleLabel.textColor.CGColor;
    
    self.callLabel.layer.cornerRadius = 3.0;
    self.callLabel.layer.borderWidth = 0.0;
    self.callLabel.layer.borderColor = self.zero.titleLabel.textColor.CGColor;
}


- (void) designLabel{
    self.callLabel.layer.cornerRadius = 5.0;
    self.callLabel.layer.borderWidth = 0.0;
    self.callLabel.layer.borderColor = self.zero.titleLabel.textColor.CGColor;
}
- (IBAction)scrollDown:(id)sender {
    CustomCell *lastVisibleCell;
    NSArray *arrayOfVisibleCells = [self.tableViewContacts visibleCells];
    if([arrayOfVisibleCells count]>0)
        lastVisibleCell = (CustomCell *)[arrayOfVisibleCells objectAtIndex:([arrayOfVisibleCells count] - 1)];
    
    if(lastVisibleCell){
        NSIndexPath *lastVisibleCellsIndexPath = [self.tableViewContacts indexPathForCell:lastVisibleCell];
        [self.tableViewContacts scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastVisibleCellsIndexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
- (IBAction)scrollUp:(id)sender {
    CustomCell *firstVisibleCell;
    NSArray *arrayOfVisibleCells = [self.tableViewContacts visibleCells];
    if([arrayOfVisibleCells count]>0)
        firstVisibleCell = (CustomCell *)[arrayOfVisibleCells objectAtIndex:0];
    
    if(firstVisibleCell){
    NSIndexPath *firstVisibleCellsIndexPath = [self.tableViewContacts indexPathForCell:firstVisibleCell];
    [self.tableViewContacts scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstVisibleCellsIndexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (InterfaceOrientationType)orientation{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize nativeSize = [UIScreen mainScreen].currentMode.size;
    CGSize sizeInPoints = [UIScreen mainScreen].bounds.size;
    
    InterfaceOrientationType result;
    
    if(scale * sizeInPoints.width == nativeSize.width){
        result = InterfaceOrientationTypePortrait;
    }else{
        result = InterfaceOrientationTypeLandscape;
    }
    
    return result;
}

- (void) setCustomAlphabetsToUserInterfaceToAllTheLabels{
    self.labelOneAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"1"];
    self.labelTwoAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"2"];
    self.labelThreeAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"3"];
    self.labelFourAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"4"];
    self.labelFiveAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"5"];
    self.labelSixAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"6"];
    self.labelSevenAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"7"];
    self.labelEightAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"8"];
    self.labelNineAlphabets.text = [DataAccessLayer fetchCustomAlphabetsForDigit:@"9"];
}

#pragma mark BACKSPACE LOGIC
- (IBAction)backspaceButtonPressed:(id)sender {
    [self deleteDigitFromLabelAndUpdateTable];
}

- (void) deleteDigitFromLabelAndUpdateTable{
    if(self.callLabel.text.length>0){
        self.callLabel.text = [self.callLabel.text substringToIndex:self.callLabel.text.length-1];
        if(self.callLabel.text.length>0){
            self.arrayOfSearchCombinationsFormed = [self.dictionaryOfCombination valueForKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.callLabel.text.length]];
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
    [self.backspace addGestureRecognizer:longPress];
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

@end
