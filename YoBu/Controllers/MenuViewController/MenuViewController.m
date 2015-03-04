//
//  ViewController.m
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import "MenuViewController.h"
@import AddressBook;
#import "ContactsInstance.h"
#import "DataAccessLayer.h"
#import "ConsoleLogs.h"

#define Application_ID 947452765
#define Social_Sharing_Message @"I #UseYoBu for quickest calling on iOS. Download it:https://itunes.apple.com/in/app/yobu/id947452765?ls=1&mt=8"

//NUMBER OF SECTIONS
#define NUMBER_OF_SECTIONS  3

//SECTION POSITIONS
#define SECTION_SHARING     0
#define SECTION_TUTORIALS   1
#define SECTION_VERSION     2


@interface MenuViewController ()



@end
UINavigationController *navigationController;

@implementation MenuViewController

@synthesize phoneNumber,isCallFromWidget;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[ContactsInstance sharedInstance] requestContacts];
    [DataAccessLayer checkAndUpdateTabelWithDefaultAlphabets];


}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isCallFromWidget){
        [self openAddContactController];
    }
    
    self.isApplicationAlreadyOpen = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareOnFacebook {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:Social_Sharing_Message]; //the message you want to post
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-76@2x.png"]]; //an image you could post
        [mySLComposerSheet addImage:[UIImage imageNamed:@"testShareImage.png"]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No account available." message:@"Please add a Facebook account in the iPhone settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
    }];
}
- (void)rateUs {
    NSString* url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%d",Application_ID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
- (void)tweetLove {
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:Social_Sharing_Message];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-76@2x.png"]]; //an image you could post
        [mySLComposerSheet addImage:[UIImage imageNamed:@"testShareImage.png"]];

        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No account available." message:@"Please add a Twitter account in the iPhone settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
    }];

}
- (void)sendFeedback {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"YoBu Feedback"];
        [mailViewController setToRecipients:@[@"yobu.feedback@gmail.com"]];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        NSData *dataLogsForApp = [NSData dataWithContentsOfFile:[[ConsoleLogs sharedInstance] returnLogFileForApp:YES]];
        NSData *dataLogsForWidget = [NSData dataWithContentsOfFile:[[ConsoleLogs sharedInstance] returnLogFileForApp:NO]];

        [mailViewController addAttachmentData:dataLogsForApp mimeType:@"text/log" fileName:@"YoBuAppLogs.log"];
        [mailViewController addAttachmentData:dataLogsForWidget mimeType:@"text/log" fileName:@"YoBuWidgetLogs.log"];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)tutorials:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Tutorials:" delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:
                            @"How to add Widget?",
                            @"How to use YoBu?",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
}

- (void)tutorialGroupClickedOnRow:(NSInteger)buttonIndex {

    NSString *videoName = @"";
    if(buttonIndex == 0){
        videoName = @"tutorial";
    }
    else if(buttonIndex ==1){
        videoName = @"tutorial2";
    }

    if(videoName.length>0){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:videoName ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath] ;
        
        theMoviPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        
        [[theMoviPlayer moviePlayer] prepareToPlay];
        [[theMoviPlayer moviePlayer] setShouldAutoplay:YES];
        [[theMoviPlayer moviePlayer] setControlStyle:2];
        [[theMoviPlayer moviePlayer] setRepeatMode:MPMovieRepeatModeNone];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [self presentMoviePlayerViewControllerAnimated:theMoviPlayer];
    }

}

-(void)videoPlayBackDidFinish:(NSNotification*)notification  {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [theMoviPlayer.moviePlayer stop];
    theMoviPlayer = nil;
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) openAddContactController{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    ABRecordRef record = ABPersonCreate();
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABStringPropertyType);
    
    // add the home email
    ABRecordSetValue(record, kABPersonEmailProperty, multi, NULL);
    
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    
    NSString *petPhoneNumber = self.phoneNumber;
    
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)petPhoneNumber, kABPersonPhoneMainLabel, NULL);
    
    ABRecordSetValue(record, kABPersonPhoneProperty, phoneNumbers, nil);
    
    // add the record
    picker.displayedPerson = record;
    //    picker.navigationItem.title=@"edit contact";
    [picker.navigationController.navigationBar setHidden:NO];
    
    picker.displayedPerson = record;
    //    picker.navigationItem.title=@"edit contact";
    [picker.navigationController.navigationBar setHidden:NO];
    
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navigationController animated:YES completion:nil];
    self.isCallFromWidget = NO;
    //    [self.navigationController pushViewController:picker animated:YES];
}


#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_SHARING:
            return 5;
            break;
        case SECTION_TUTORIALS:
            return 2;
            break;
        case SECTION_VERSION:
            return 1;
            break;
        default:
            return 2;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        switch (indexPath.section) {
            case SECTION_VERSION:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                break;
                
            default:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                break;
        }

    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    switch (indexPath.section) {
        case SECTION_SHARING:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Share to Facebook";
                    break;
                case 1:
                    cell.textLabel.text = @"Tweet your LOVE";
                    break;
                case 2:
                    cell.textLabel.text = @"Rate Us";
                    break;
                case 3:
                    cell.textLabel.text = @"Send Feedback";
                    break;
                case 4:
                    cell.textLabel.text = @"Follow Developer on Twiiter";
                    break;
            }
            break;
            
        case SECTION_TUTORIALS:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"How to add Widget?";
                    break;
                case 1:
                    cell.textLabel.text = @"How to use YoBu?";
                    break;
            }
            break;
            
        case SECTION_VERSION:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = @"1.4";

            break;
        default:
            cell.textLabel.text = @"Testing the table view grouped cell";
            break;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case SECTION_SHARING:
            return @"Sharing";
            break;
        case SECTION_TUTORIALS:
            return @"Tutorials";
            break;
        case SECTION_VERSION:
            return @"";
            break;

        default:
            return @"Default";
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    switch (section) {
        case SECTION_VERSION:
            return @"Built & Designed in India";
            break;
        default:
            return @"";
            break;
    }
}



#pragma mark UITableView Delgates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case SECTION_SHARING:
            switch (indexPath.row) {
                case 0:
                    [self shareOnFacebook];
                    break;
                case 1:
                    [self tweetLove];
                    break;
                case 2:
                    [self rateUs];
                    break;
                case 3:
                    [self sendFeedback];
                    break;
                case 4:
                    
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:///user?screen_name=___harsh"]]){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter:///user?screen_name=___harsh"]];
                    }
                    else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"thttps://twitter.com/___harsh"]];
                    }
                    break;
            }
            break;
        case SECTION_TUTORIALS:
            [self tutorialGroupClickedOnRow:indexPath.row];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0 ;
    label.textColor = self.view.tintColor;
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    switch (section) {
        case SECTION_VERSION:
            label.text = @"Built & Designed in India\nHarshdeep Singh";
            [view addSubview:label];
            return view;
            break;
        default:
            return nil;
            break;
    }
}




@end
