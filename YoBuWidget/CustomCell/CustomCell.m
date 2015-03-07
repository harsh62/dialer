//
//  CustomCell.m
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *color = self.labelImageTitle.backgroundColor;
    
    [super setSelected:selected animated:animated];
    
    self.labelImageTitle.backgroundColor = color;
    
    // Configure the view for the selected state
}

@end
