//
//  Utility.m
//  YoBu
//
//  Created by Harsh on 25/03/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "Utility.h"

#define TAG_BGVIEW 182


@implementation Utility



/*
 *********************************************************
 Show alert view with required message and button titles
 *********************************************************
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              button1Title:(NSString *)button1Title
              button2Title:(NSString *)button2Title
                  alertTag:(NSInteger)tag onContext:(id)context{
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:context cancelButtonTitle:button1Title otherButtonTitles:button2Title, nil];
    alertView.tag = tag;
    [alertView show];
    
    
}



/*
 *********************************************************
 This method creates the activity alert on the view and
 sets its center to the center of the specified view
 *********************************************************
 */
+ (void)showActivityIndicatorOnView:(UIView*)view withCenter:(CGRect)frame withText:(NSString*)text {
    
    [view setUserInteractionEnabled:NO];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, frame.size.height / 2 -70, 300, 170)];
    backgroundView.tag = TAG_BGVIEW;
    [backgroundView.layer setCornerRadius:5.0f];
    [backgroundView.layer setBorderWidth:2.0f];
    [backgroundView.layer setBorderColor:[UIColor blackColor].CGColor];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.8f];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [spinner startAnimating];
    spinner.center = CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2);
    
    
    UILabel *indicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width / 2, frame.size.height / 2 + spinner.frame.size.height + 15, 300, 40)];
    [indicatorLabel setText:text];
    [indicatorLabel setTextAlignment:NSTextAlignmentCenter];
    [indicatorLabel setNumberOfLines:0];
    [indicatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0f]];
    [indicatorLabel setTextColor:[UIColor whiteColor]];
    indicatorLabel.center  = CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2 + spinner.frame.size.height + 10);
    
    [view addSubview:backgroundView];
    [backgroundView addSubview:spinner];
    [backgroundView addSubview:indicatorLabel];
}


/*
 *********************************************************
 This method stops the activity indicator visible on
 the screen
 *********************************************************
 */
+ (void)stopActivityIndicatorOnView:(UIView*)view {
    
    for (UIView *currentView in view.subviews) {
        
        
        if ([currentView isKindOfClass:[UIView class]]) {
            
            UIView *view = (UIView*)currentView;
            
            if (view.tag == TAG_BGVIEW) {
                [view removeFromSuperview];
            }
            
        }
    }
    [view setUserInteractionEnabled:YES];
}

@end
