//
//  ViewController.h
//  YoBu
//
//  Created by Harshdeep  Singh on 27/01/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>


@interface FavoriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate>


//Arrays
@property (strong,nonatomic) NSMutableArray *arrayToPopulateTableView;
@property (strong,nonatomic) NSArray *materialDesignPalletArray;
- (IBAction)editButtonClicked:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForFavorites;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

