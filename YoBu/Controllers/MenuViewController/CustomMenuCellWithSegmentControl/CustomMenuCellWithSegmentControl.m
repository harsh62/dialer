//
//  CustomMenuCellWithSegmentControl.m
//  YoBu
//
//  Created by Harshdeep  Singh on 24/03/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "CustomMenuCellWithSegmentControl.h"

@implementation CustomMenuCellWithSegmentControl

- (void)awakeFromNib {
    // Initialization code
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    
    
    NSString *selectedSegment = [sharedDefaults valueForKey:@"selectedSegmentControl"];
    [self.segmentControl setSelectedSegmentIndex:selectedSegment.intValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)segmentControlValueChanged:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    [sharedDefaults setValue:[NSString stringWithFormat:@"%ld",(long)segmentControl.selectedSegmentIndex] forKey:@"selectedSegmentControl"];
    [sharedDefaults synchronize];
    
    
    
}

@end
