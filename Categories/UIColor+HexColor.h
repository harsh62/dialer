//
//  UIColor+HexColor.h
//  YoBu
//
//  Created by Harshdeep  Singh on 21/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
