//
//  RecentContactsCustomCell.h
//  YoBu
//
//  Created by Harshdeep  Singh on 22/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentContactsCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelImageTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end
