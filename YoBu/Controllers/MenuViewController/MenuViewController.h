//
//  ViewController.h
//  Dialer
//
//  Created by Harshdeep  Singh on 30/11/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AddressBookUI/AddressBookUI.h>


@interface MenuViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,ABNewPersonViewControllerDelegate, UITableViewDataSource,UITableViewDelegate>{

    SLComposeViewController *mySLComposerSheet;
    MPMoviePlayerViewController * theMoviPlayer;

}

@property (nonatomic, assign) BOOL isCallFromWidget;
@property (nonatomic, assign) BOOL isApplicationAlreadyOpen;
@property (nonatomic, retain) NSString* phoneNumber;


- (void) openAddContactController;



@end

