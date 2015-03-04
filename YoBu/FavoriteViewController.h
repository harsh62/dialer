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

@property (weak, nonatomic) IBOutlet UITableView *tableViewForFavorites;
@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *favoritesNavigationItem;

@end

