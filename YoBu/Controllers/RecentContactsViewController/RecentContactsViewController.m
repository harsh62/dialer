//
//  RecentContactsViewController.m
//  YoBu
//
//  Created by Harshdeep  Singh on 21/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "RecentContactsViewController.h"
#import "FrequentCustomCell.h"
#import "RecentContactsCustomCell.h"
#import "DataAccessLayer.h"
#import "DialedNumbers.h"
#import "FrequentContacts.h"
#import "UIColor+HexColor.h"
#import <QuartzCore/QuartzCore.h>



@interface RecentContactsViewController ()

@end

@implementation RecentContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MaterialDesignColors" ofType:@"plist"];
    self.materialDesignPalletArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    [self.segmentControl addTarget:self
                         action:@selector(segmentControlIndexChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self addEditAndClearButtonsToNavigationItem];
}


-(void)addEditAndClearButtonsToNavigationItem{
    //Set UIBarButtonsOnInitialLoad
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(editButtonClicked:)];
    self.recentNavigationItem.leftBarButtonItem = self.editButton;
    self.clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(clearButtonClicked:)];
    self.recentNavigationItem.rightBarButtonItem = self.clearButton;
}

-(void)addDeleteAllAndDoneButtonToNavigationItem{
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(doneButtonClicked:)];
    self.recentNavigationItem.leftBarButtonItem = self.editButton;
    
    self.clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(deleteSelectedButtonClicked:)];
    self.recentNavigationItem.rightBarButtonItem = self.clearButton;
}

#pragma mark Bar Button Items Clicked

- (void)editButtonClicked:(id)sender {
    [self addDeleteAllAndDoneButtonToNavigationItem];
    self.tableViewForRecentController.isEditing ? [self.tableViewForRecentController setEditing:NO animated:YES] :[self.tableViewForRecentController setEditing:YES animated:YES];
    
//    self.tableViewForRecentController 
}

- (void)doneButtonClicked:(id)sender {
    [self addEditAndClearButtonsToNavigationItem];
    self.tableViewForRecentController.isEditing ? [self.tableViewForRecentController setEditing:NO animated:YES] :[self.tableViewForRecentController setEditing:YES animated:YES];

}

- (void)clearButtonClicked:(id)sender {
    
    while(self.arrayToPopulateTableView.count != 0){
        [DataAccessLayer deleteModel:[self.arrayToPopulateTableView objectAtIndex:0]];
        [self.arrayToPopulateTableView removeObjectAtIndex:0];
        [self.tableViewForRecentController deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:self.arrayToPopulateTableView.count%2==0?UITableViewRowAnimationLeft:UITableViewRowAnimationRight];
    }
}

- (void)deleteSelectedButtonClicked:(id)sender {
    [self addEditAndClearButtonsToNavigationItem];
    while([self.tableViewForRecentController indexPathsForSelectedRows].count != 0){
        NSIndexPath *indexPath = [[self.tableViewForRecentController indexPathsForSelectedRows] objectAtIndex:0];
        [DataAccessLayer deleteModel:[self.arrayToPopulateTableView objectAtIndex:indexPath.row]];
        [self.arrayToPopulateTableView removeObjectAtIndex:indexPath.row];
        [self.tableViewForRecentController deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:[self.tableViewForRecentController indexPathsForSelectedRows].count%2==0?UITableViewRowAnimationLeft:UITableViewRowAnimationRight];
    }
    
    
    self.tableViewForRecentController.isEditing ? [self.tableViewForRecentController setEditing:NO animated:YES] :[self.tableViewForRecentController setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchAndReloadTable];
    
}

#pragma mark Fetching Data
-(void) fetchAndReloadTable{
    if(self.segmentControl.selectedSegmentIndex == 0){
        self.arrayToPopulateTableView = [[NSMutableArray alloc] initWithArray:[DataAccessLayer fetchRecentlyDialedContacts]];
    }
    else if(self.segmentControl.selectedSegmentIndex == 1){
        self.arrayToPopulateTableView = [[NSMutableArray alloc] initWithArray:[DataAccessLayer fetchAllFrequentContacts]];
    }
    [self.tableViewForRecentController reloadData];
}

#pragma mark Segment Control Value Changed
- (void)segmentControlIndexChanged:(id)sender{
    [self fetchAndReloadTable];
    
}

#pragma mark UITableView Delegates and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayToPopulateTableView.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.segmentControl.selectedSegmentIndex == 0){
        RecentContactsCustomCell *cell = nil;
        static NSString *cellIdentifier = @"RecentContactsCustomCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [[RecentContactsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        DialedNumbers *dialedNumber = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
        cell.name.text = dialedNumber.name;
        cell.phoneNumber.text = dialedNumber.phoneNumber;
        
        NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
        
        cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
        cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelImageTitle setText:[cell.name.text substringToIndex:1].uppercaseString];
        [cell.labelImageTitle.layer setMasksToBounds:YES];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stringOfCallTimeAndDate = dialedNumber.callDateAndTime;
        NSDate *calledFullDate = [formatter dateFromString:stringOfCallTimeAndDate];
        
        NSDateFormatter *formatterForDateDisplay = [[NSDateFormatter alloc] init];
        //For Date
        [formatterForDateDisplay setDateStyle:NSDateFormatterFullStyle];
        cell.labelDate.text = [formatterForDateDisplay stringFromDate:calledFullDate];
        
        //For Time
        [formatterForDateDisplay setDateFormat:@"hh:mm a"];
        cell.labelTime.text = [formatterForDateDisplay stringFromDate:calledFullDate];
        
        return cell;

    }
    else{
        FrequentCustomCell *cell = nil;
        static NSString *cellIdentifier = @"FrequentCustomCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [[FrequentCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        FrequentContacts *dialedNumber = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
        cell.name.text = dialedNumber.name;
        cell.phoneNumber.text = dialedNumber.phoneNumber;
        
        NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
        cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
        cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelImageTitle setText:[cell.name.text substringToIndex:1].uppercaseString];
        [cell.labelImageTitle.layer setMasksToBounds:YES];
        
//        randomNumber = arc4random()%[self.materialDesignPalletArray count];
//        cell.labelCallCount.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
//        cell.labelCallCount.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelCallCount setText:dialedNumber.counter];
//        [cell.labelCallCount.layer setMasksToBounds:YES];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViewForRecentController isEditing]){
        
    }
    else{
        NSMutableDictionary *filteredContactForTableView = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
        NSString *phoneNumberToCallOn = [filteredContactForTableView valueForKey:@"phoneNumber"];
        [DataAccessLayer saveDialedNumber:[filteredContactForTableView valueForKey:@"phoneNumber"] forContactName:[filteredContactForTableView valueForKey:@"name"]];
        [self callOnNumber:phoneNumberToCallOn];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [DataAccessLayer deleteModel:[self.arrayToPopulateTableView objectAtIndex:indexPath.row]];
    [self.arrayToPopulateTableView removeObjectAtIndex:indexPath.row];
    [self.tableViewForRecentController deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Delete";
}

#pragma mark Call Phone
- (void) callOnNumber:(NSString *)phoneNumber{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    
}
@end
