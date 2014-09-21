//
//  DBFilterViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBFilterViewController.h"
#import "DBAppDelegate.h"
#import "CardFilter.h"

@interface DBFilterViewController ()

@end

@implementation DBFilterViewController

@synthesize filters;



- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CardFilter *whiteFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show white cards", "white filter") andKey:kFilterWhite andState:[userDefaults boolForKey:kFilterWhite]];
    CardFilter *blueFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show blue cards cards", "blue filter") andKey:kFilterBlue andState:[userDefaults boolForKey:kFilterBlue]];
    CardFilter *blackFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show black cards", "black filter") andKey:kFilterBlack andState:[userDefaults boolForKey:kFilterBlack]];
    CardFilter *redFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show red cards", "red filter") andKey:kFilterRed andState:[userDefaults boolForKey:kFilterRed]];
    CardFilter *greenFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show green cards", "green filter") andKey:kFilterGreen andState:[userDefaults boolForKey:kFilterGreen]];
    
    CardFilter *artifactFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show artifact cards", "artifact filter") andKey:kFilterArtifact andState:[userDefaults boolForKey:kFilterArtifact]];
    CardFilter *landFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show land cards", "land filter") andKey:kFilterLand andState:[userDefaults boolForKey:kFilterLand]];
    
    CardFilter *commonFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show common cards", "common filter") andKey:kFilterCommon andState:[userDefaults boolForKey:kFilterCommon]];
    CardFilter *uncommonFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show uncommon cards", "uncommon filter") andKey:kFilterUncommon andState:[userDefaults boolForKey:kFilterUncommon]];
    CardFilter *rareFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show rare cards", "rare filter") andKey:kFilterRare andState:[userDefaults boolForKey:kFilterRare]];
    CardFilter *mythicFilter = [[CardFilter alloc] initWithName:NSLocalizedString(@"Show rare mythic cards", "rare mythic filter") andKey:kFilterMyhtic andState:[userDefaults boolForKey:kFilterMyhtic]];
    
    filters = [[NSArray alloc] initWithObjects:whiteFilter, blueFilter, blackFilter, redFilter, greenFilter,
               artifactFilter, landFilter, commonFilter, uncommonFilter, rareFilter, mythicFilter, nil];
    
    self.navigationItem.title = NSLocalizedString(@"Filter", @"filter");

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", @"cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"apply", @"apply") style:UIBarButtonItemStylePlain target:self action:@selector(apply:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(UIBarButtonItem *)barButtonItem{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)apply:(UIBarButtonItem *)barButtonItem{
    [app_delegate setFilterChanged:YES];
    [app_delegate setFilterChangedSearch:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (CardFilter *filter in filters){
        [userDefaults setBool:filter.isActive forKey:filter.filterKey];
    }
    [userDefaults synchronize];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return filters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    
    CardFilter *filter = [filters objectAtIndex:indexPath.row];
    
    cell.textLabel.text = filter.displayName;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (filter.isActive){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardFilter *filter = [filters objectAtIndex:indexPath.row];
    
    if (filter.isActive){
        [filter setInactive];
    } else {
        [filter setActive];
    }
    [self.tableView reloadData];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
