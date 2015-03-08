//
//  TodayViewController.h
//  DialerWidget
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

typedef NS_ENUM(NSInteger, InterfaceOrientationType) {
    InterfaceOrientationTypePortrait,
    InterfaceOrientationTypeLandscape
};


@property (strong,atomic)       NSArray *listOfAllContactsInWidget;
@property (strong,nonatomic)    NSMutableArray *filteredContacts;
@property (strong,nonatomic)    NSMutableArray *arrayOfSearchCombinationsFormed;
@property (strong,nonatomic)    NSMutableDictionary *dictionaryOfCombination;

@property (weak, nonatomic)     IBOutlet UITableView *contactsTableView;


@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;
@property (weak, nonatomic) IBOutlet UIButton *eight;
@property (weak, nonatomic) IBOutlet UIButton *nine;
@property (weak, nonatomic) IBOutlet UIButton *zero;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *backspace;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *dialerPadView;
@property (weak, nonatomic) IBOutlet UIView *tableViewAndInputLabelView;
@property (strong, nonatomic) IBOutlet UIView *controllerView;

@property (weak, nonatomic) IBOutlet UITableView *tableViewContacts;

@property (strong,nonatomic) NSArray *materialDesignPalletArray;


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

@end
