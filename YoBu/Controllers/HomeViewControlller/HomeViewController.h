//
//  HomeViewController.h
//  YoBu
//
//  Created by Harshdeep  Singh on 14/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <StoreKit/StoreKit.h>
#import "ContactsInstance.h"



@interface HomeViewController : UIViewController<ABNewPersonViewControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate,ContactsInstanceDelegate>{
    CGRect rectImageViewCall;
    CGRect rectImageViewBlueCircle;
    CGRect rectOfDialerView;
    CGRect rectImageViewRedCircle;
    CGRect rectImageViewDialPad;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
@property (weak, nonatomic) IBOutlet UIButton *buttonEight;
@property (weak, nonatomic) IBOutlet UIButton *buttonNine;
@property (weak, nonatomic) IBOutlet UIButton *buttonZero;
@property (weak, nonatomic) IBOutlet UIButton *buttonAsterik;
@property (weak, nonatomic) IBOutlet UIButton *buttonPound;
@property (weak, nonatomic) IBOutlet UIButton *buttonCall;
@property (weak, nonatomic) IBOutlet UIButton *buttonBackSppace;
@property (weak, nonatomic) IBOutlet UILabel *labelTypedNumber;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForContactsSearched;
- (IBAction)numberPadPressed:(id)sender;
- (IBAction)callButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForCircle;
@property (weak, nonatomic) IBOutlet UIView *containerForPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *dialerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCall;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBlueCircle;
@property (weak, nonatomic) IBOutlet UIButton *dialPadMenuButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRedCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDialPad;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewContacts;
@property (weak, nonatomic) IBOutlet UIView *cursorView;



//Arrays
@property (strong,atomic) NSMutableArray *listOfAllContactsInWidget;
@property (strong,nonatomic) NSMutableArray *filteredContacts;
@property (strong,nonatomic) NSMutableArray *arrayOfSearchCombinationsFormed;
@property (strong,nonatomic) NSArray *materialDesignPalletArray;
@property (strong,nonatomic) NSMutableDictionary *dictionaryOfCombination;


//Add New Contact
@property (nonatomic, assign) BOOL isCallFromWidget;
@property (nonatomic, assign) BOOL isApplicationAlreadyOpen;
@property (nonatomic, retain) NSString* phoneNumber;


- (void) openAddContactController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOnTableForContacts;



//custom alphabets
@property (weak, nonatomic) IBOutlet UILabel *labelOneAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelTwoAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelThreeAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelFourAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelFiveAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelSixAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelSevenAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelEightAlphabets;
@property (weak, nonatomic) IBOutlet UILabel *labelNineAlphabets;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *viewInAppDialerPurchase;



@end
