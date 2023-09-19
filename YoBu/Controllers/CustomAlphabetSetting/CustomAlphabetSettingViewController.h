//
//  CustomAlphabetSettingViewController.h
//  YoBu
//
//  Created by Harshdeep  Singh on 26/01/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsInstance.h"


@interface CustomAlphabetSettingViewController : UIViewController<UITextFieldDelegate,ContactsInstanceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldThree;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFour;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFive;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSeven;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEight;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNine;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
