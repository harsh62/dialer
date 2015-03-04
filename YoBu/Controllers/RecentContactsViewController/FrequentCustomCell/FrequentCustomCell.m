//
//  FrequentCustomCell.m
//  YoBu
//
//  Created by Harshdeep  Singh on 22/02/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "FrequentCustomCell.h"

@implementation FrequentCustomCell

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
