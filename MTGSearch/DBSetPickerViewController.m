//
//  DBSetPickerViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSetPickerViewController.h"
#import "DBAppDelegate.h"
#import "MTGSet.h"

@interface DBSetPickerViewController ()

@end

@implementation DBSetPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Pick a set", @"pick set");
}

- (void) viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentSetId = (int)[userDefaults integerForKey:@"setId"];
    
    int target = currentSetId;
    if (currentSetId > 1){
        target = currentSetId - 1;
    }
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:target inSection:0];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    [app_delegate trackPage:@"/sets"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return app_delegate.sets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    
    MTGSet *set = [app_delegate.sets objectAtIndex:indexPath.row];
    cell.textLabel.text = set.name;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == currentSetId){
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    [cell.textLabel setTextColor:[DBAppDelegate mainColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MTGSet *set = [app_delegate.sets objectAtIndex:indexPath.row];
    
    if (indexPath.row != currentSetId){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:indexPath.row forKey:kSetId];
        [userDefaults synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [app_delegate trackEventWithCategory:kUACategorySet andAction:kUAActionSelect andLabel:set.code];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
