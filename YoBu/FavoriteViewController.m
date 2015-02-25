//
//  ViewController.m
//  YoBu
//
//  Created by Harshdeep  Singh on 27/01/15.
//  Copyright (c) 2015 Harshdeep  Singh. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteContactCustomCell.h"
#import "DataAccessLayer.h"
#import "FavoriteContacts.h"
#import "UIColor+HexColor.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MaterialDesignColors" ofType:@"plist"];
    self.materialDesignPalletArray = [[NSArray alloc] initWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self fetchAndReloadTable];
}
-(void) fetchAndReloadTable{
    self.arrayToPopulateTableView = [[NSMutableArray alloc] initWithArray:[DataAccessLayer fetchAllFavoriteContacts]];
    [self.tableViewForFavorites reloadData];
}

- (IBAction)editButtonClicked:(id)sender {
    [self.editButton setTitle:@"Done"];
    self.tableViewForFavorites.isEditing?   [self.tableViewForFavorites setEditing:NO animated:YES] :[self.tableViewForFavorites setEditing:YES animated:YES];
}

- (IBAction)addButtonClicked:(id)sender {
    
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}


#pragma mark UITableView Delegates and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayToPopulateTableView.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        FavoriteContactCustomCell *cell = nil;
        static NSString *cellIdentifier = @"FavoriteContactCustomCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [[FavoriteContactCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        FavoriteContacts *favoriteContact = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
        cell.name.text = favoriteContact.name;
        cell.phoneNumber.text = favoriteContact.phoneNumber;
    
    if(favoriteContact.image == nil){
    
        NSInteger randomNumber = arc4random()%[self.materialDesignPalletArray count];
        cell.labelImageTitle.backgroundColor = [UIColor colorWithHexString:[self.materialDesignPalletArray objectAtIndex:randomNumber]];
        cell.labelImageTitle.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.labelImageTitle setText:[cell.name.text substringToIndex:1].uppercaseString];
        [cell.labelImageTitle.layer setMasksToBounds:YES];
    
        [cell.imageView setHidden:YES];
        [cell.labelImageTitle setHidden:NO];

    }
    else{
        [cell.labelImageTitle setHidden:YES];
        [cell.imageView setHidden:NO];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = cell.labelImageTitle.bounds.size.width/2.0;
        [cell.imageView.layer setMasksToBounds:YES];
        cell.imageView.frame = CGRectMake(15, 5, 40, 40);
        NSLog(@"%f %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height );
        cell.imageView.image = [self imageWithImage:[UIImage imageWithData:favoriteContact.image] scaledToSize:cell.imageView.frame.size];



        
    }
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *filteredContactForTableView = [self.arrayToPopulateTableView objectAtIndex:indexPath.row];
    NSString *phoneNumberToCallOn = [filteredContactForTableView valueForKey:@"phoneNumber"];
    [DataAccessLayer saveDialedNumber:[filteredContactForTableView valueForKey:@"phoneNumber"] forContactName:[filteredContactForTableView valueForKey:@"name"]];
    [self callOnNumber:phoneNumberToCallOn];
}

#pragma mark Call Phone
- (void) callOnNumber:(NSString *)phoneNumber{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    
}

#pragma mark Contacts Importer
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString *firstNameAndLastName;
    if(firstName != nil && ![firstName isEqualToString:@""] && ![firstName isEqualToString:@"(null)"]){
        firstNameAndLastName = firstName;
    }
    if(lastName != nil && ![lastName isEqualToString:@""] && ![lastName isEqualToString:@"(null)"]){
        firstNameAndLastName = [firstNameAndLastName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];;
    }
   
    NSData *imageData = nil;
    if (person != nil && ABPersonHasImageData(person)) {
        if ( &ABPersonCopyImageDataWithFormat != nil ) {
            // iOS >= 4.1
            imageData= (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        }
    } else {
        imageData= nil;
    }
    // Get the multivalue number property.
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    
    // Get the index of the selected number. Remember that the number multi-value property is being returned as an array.
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    
    // Copy the number value into a string.
    NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    NSArray *arrayOfSpecialCharacters = @[@"(",@")",@"-",@" "];
    for(NSString *character in arrayOfSpecialCharacters)
        number = [number stringByReplacingOccurrencesOfString:character withString:@""];
    
    [DataAccessLayer saveFavoriteContactsWithName:firstNameAndLastName andWithPhoneNumber:number andWithImageData:imageData];
    
    [self fetchAndReloadTable];
    
}




// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
//    [addressBookController dismissViewControllerAnimated:YES completion:nil];
}


@end
