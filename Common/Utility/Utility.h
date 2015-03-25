//
//  Utility.h
//  YoBu
//
//  Created by Harsh on 25/03/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
/*
 *********************************************************
 Show alert view with required message and button titles
 *********************************************************
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              button1Title:(NSString *)button1Title
              button2Title:(NSString *)button2Title
                  alertTag:(NSInteger)tag onContext:(id)context;

/*
 *********************************************************
 This method creates the activity alert on the view and
 sets its center to the center of the specified view
 *********************************************************
 */
+ (void)showActivityIndicatorOnView:(UIView*)view withCenter:(CGRect)frame withText:(NSString*)text ;

/*
 *********************************************************
 This method stops the activity indicator visible on
 the screen
 *********************************************************
 */
+ (void)stopActivityIndicatorOnView:(UIView*)view;
@end
