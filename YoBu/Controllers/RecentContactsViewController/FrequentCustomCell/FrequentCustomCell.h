//
//  FrequentCustomCell.h
//  YoBu
//
//  Created by Harshdeep  Singh on 22/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequentCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelCallCount;
@property (weak, nonatomic) IBOutlet UILabel *labelImageTitle;
@end
