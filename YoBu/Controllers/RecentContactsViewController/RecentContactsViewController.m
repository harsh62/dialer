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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
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

- (IBAction)editBUttonPressed:(id)sender {
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
    NSMutableDictionary *filteredContactForTableView = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
    NSString *phoneNumberToCallOn = [filteredContactForTableView valueForKey:@"phoneNumber"];
    [DataAccessLayer saveDialedNumber:[filteredContactForTableView valueForKey:@"phoneNumber"] forContactName:[filteredContactForTableView valueForKey:@"name"]];
    [self callOnNumber:phoneNumberToCallOn];
}

#pragma mark Call Phone
- (void) callOnNumber:(NSString *)phoneNumber{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    
}
@end
