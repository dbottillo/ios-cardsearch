//
//  DBSettingsViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 20/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSettingsViewController.h"

@interface DBSettingsViewController ()

@end

@implementation DBSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"Settings", @"settings");
}

- (void) viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    showImage = [userDefaults boolForKey:kUserImage];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return @"MTG Cards Info";
    return NSLocalizedString(@"Cards", @"cards");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting"];
    
    UISwitch *switchImage = (UISwitch *)[cell viewWithTag:2];
    [switchImage setHidden:YES];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"About", @"about");
        }else{
            cell.textLabel.text = NSLocalizedString(@"Feedback", @"feedback");
        }
    } else {
        cell.textLabel.text = NSLocalizedString(@"Show image", @"show image");
        [switchImage setHidden:NO];

        [switchImage setOn:showImage animated:YES];
        [switchImage addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return cell;
}

- (void)changeSwitch:(UISwitch *)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:[sender isOn] forKey:kUserImage];
    [userDefaults synchronize];
    showImage = [sender isOn];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"About", @"about")
                                        message: NSLocalizedString(@"The information presented on this site about Magic: The Gathering, both literal and graphical, is copyrighted by Wizards of the Coast. This application is not produced, endorsed, supported, or affiliated with Wizards of the Coast.", @"about message")
                                     delegate: nil
                            cancelButtonTitle: NSLocalizedString(@"Ok", @"ok")
                            otherButtonTitles:nil];
            [alert show];
        } else {
            NSBundle *bundle = [NSBundle mainBundle];
            NSDictionary *info = [bundle infoDictionary];
            NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"Feedback", @"send feedback"), prodName]];
            NSArray *toRecipients = [NSArray arrayWithObjects:@"mtg@danielebottillo.com",
                                     nil];
            [picker setToRecipients:toRecipients];
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        showImage = !showImage;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:showImage forKey:kUserImage];
        [userDefaults synchronize];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
