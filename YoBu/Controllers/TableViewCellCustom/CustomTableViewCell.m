//
//  CustomTableViewCell.m
//  YoBu
//
//  Created by Harshdeep  Singh on 16/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *color = self.labelImageTitle.backgroundColor;
    
    [super setSelected:selected animated:animated];
    
    self.labelImageTitle.backgroundColor = color;
    
    // Configure the view for the selected state
}

@end
