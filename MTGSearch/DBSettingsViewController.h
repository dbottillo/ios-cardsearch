//
//  DBSettingsViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 20/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DBAppDelegate.h"

#define kUserImage  @"userImage"

@interface DBSettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>{
    BOOL showImage;
}

@end
