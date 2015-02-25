//
//  CustomTableViewCell.h
//  YoBu
//
//  Created by Harshdeep  Singh on 16/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelImageTitle;

@end
