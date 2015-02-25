//
//  CustomCell.h
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelImageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePicture;

@end
