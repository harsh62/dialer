//
//  CustomAlphabetSettingViewController.m
//  YoBu
//
//  Created by Harshdeep  Singh on 26/01/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "CustomAlphabetSettingViewController.h"
#import "DataAccessLayer.h"

@interface CustomAlphabetSettingViewController ()

@end

@implementation CustomAlphabetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldOne.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"1"];
    self.textFieldTwo.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"2"];
    self.textFieldThree.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"3"];
    self.textFieldFour.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"4"];
    self.textFieldFive.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"5"];
    self.textFieldSix.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"6"];
    self.textFieldSeven.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"7"];
    self.textFieldEight.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"8"];
    self.textFieldNine.text  = [DataAccessLayer fetchCustomAlphabetsForDigit:@"9"];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [DataAccessLayer saveCustomSearchForDigit:@"1" withAlphabets:self.textFieldOne.text];
    [DataAccessLayer saveCustomSearchForDigit:@"2" withAlphabets:self.textFieldTwo.text];
    [DataAccessLayer saveCustomSearchForDigit:@"3" withAlphabets:self.textFieldThree.text];
    [DataAccessLayer saveCustomSearchForDigit:@"4" withAlphabets:self.textFieldFour.text];
    [DataAccessLayer saveCustomSearchForDigit:@"5" withAlphabets:self.textFieldFive.text];
    [DataAccessLayer saveCustomSearchForDigit:@"6" withAlphabets:self.textFieldSix.text];
    [DataAccessLayer saveCustomSearchForDigit:@"7" withAlphabets:self.textFieldSeven.text];
    [DataAccessLayer saveCustomSearchForDigit:@"8" withAlphabets:self.textFieldEight.text];
    [DataAccessLayer saveCustomSearchForDigit:@"9" withAlphabets:self.textFieldNine.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
