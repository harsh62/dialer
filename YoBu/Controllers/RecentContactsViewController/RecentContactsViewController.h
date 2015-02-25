//
//  RecentContactsViewController.h
//  YoBu
//
//  Created by Harshdeep  Singh on 21/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewForRecentController;
- (IBAction)editBUttonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

//Arrays
@property (strong,nonatomic) NSMutableArray *arrayToPopulateTableView;
@property (strong,nonatomic) NSArray *materialDesignPalletArray;

-(void) fetchAndReloadTable;



@end
