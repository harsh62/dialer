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
    
    
    self.textFieldOne.delegate  = self;
    self.textFieldTwo.delegate  = self;
    self.textFieldThree.delegate  = self;
    self.textFieldFour.delegate  = self;
    self.textFieldFive.delegate  = self;
    self.textFieldSix.delegate  = self;
    self.textFieldSeven.delegate  = self;
    self.textFieldEight.delegate  = self;
    self.textFieldNine.delegate  = self;
    
    [self checkInAppPurchase];
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
#pragma mark Text Field Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@""])
        return YES;
    
    
    if(textField.text.length<=3){
        return YES;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Only four characters are allowed in the field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
        [alert show];
        return NO;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    if([[sharedDefaults valueForKey:@"Hachi.YoBu.CustomizeSearch"] isEqualToString:@"YES"]){
        return YES;
    }
    else{
        NSString *productPrice = [self getPriceOfProduct];
        [Utility showAlertWithTitle:@"Buy search customization feature!" message:[NSString stringWithFormat:@"Setting custom characters to T9 search is a paid feature. Do you want to buy this feature for %@",productPrice] button1Title:@"Cancel" button2Title:@"Buy" alertTag:12 onContext:self];
        return NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self.buyButton setHidden:YES];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [[ContactsInstance sharedInstance] setCustomDelegate:self];
        [[ContactsInstance sharedInstance] startPaymentProcessForProductIdentifier:@"Hachi.YoBu.CustomizeSearch"];
    }
}

-(NSString *)getPriceOfProduct{
    SKProduct *product = [[ContactsInstance sharedInstance] productInSearchCustomize];
    if(product){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:product.priceLocale];
        return [formatter stringFromNumber:product.price];
    }
    else{
        return @"$1.99";
    }
}

- (IBAction)buyButtonClicked:(id)sender {
    [self.buyButton setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    [[ContactsInstance sharedInstance] setCustomDelegate:self];
    [[ContactsInstance sharedInstance] startPaymentProcessForProductIdentifier:@"Hachi.YoBu.CustomizeSearch"];
}

-(void)transactionCompleted{
    LogTrace(@"");
    [self.buyButton setHidden:YES];
    [self.activityIndicator setHidden:YES];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    [sharedDefaults setValue:@"YES" forKey:@"Hachi.YoBu.CustomizeSearch"];
    [sharedDefaults synchronize];
    
}

-(void)transactionFailed{
    LogTrace(@"");
    [self.buyButton setHidden:NO];
    [self.activityIndicator setHidden:YES];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    [sharedDefaults setValue:@"NO" forKey:@"Hachi.YoBu.CustomizeSearch"];
    [sharedDefaults synchronize];
}

-(void)didRecieveProductData{
    [self setTextForTheButButton];
}

-(void) checkInAppPurchase{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.YoBuDefaults"];
    
    if([[sharedDefaults valueForKey:@"Hachi.YoBu.CustomizeSearch"] isEqualToString:@"YES"]){
        [self.buyButton setHidden:YES];
        [self.activityIndicator setHidden:YES];
    }
    else{
        [self setTextForTheButButton];
        [self.buyButton setHidden:NO];
        [self.activityIndicator setHidden:YES];
        [self.buyButton setBackgroundColor:[UIColor darkGrayColor]];
        self.buyButton.layer.cornerRadius = 8.0;
        self.buyButton.titleLabel.numberOfLines = 0;
    }
}

- (void)setTextForTheButButton{
    LogTrace(@"");
    NSAttributedString *attributedString = self.buyButton.titleLabel.attributedText;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSDictionary *dictionary = [attributedString attributesAtIndex:attributedString.length-3 effectiveRange:NULL];
    NSAttributedString *stringToBereplace = [[NSAttributedString alloc] initWithString:[self getPriceOfProduct] attributes:dictionary];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(8, mutableAttributedString.length-8) withAttributedString:stringToBereplace];
    
    [self.buyButton setAttributedTitle:mutableAttributedString forState:UIControlStateNormal];
}


@end
