//
//  DBSavedViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSavedViewController.h"
#import "UIViewController+NavBar.h"
#import "DBCardCell.h"
#import "DBCardsViewController.h"

@implementation DBSavedViewController

@synthesize savedCards, savedTable, localDataProvider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"Saved", @"saved");
    
    [self styleNavBar];
    
    [savedTable setDataSource:self];
    [savedTable setDelegate:self];
    
    localDataProvider = [[LocalDataProvider alloc] init];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [app_delegate trackPage:@"/saved"];
    
    [self loadSavedCards];
}

- (void) loadSavedCards{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        savedCards = [NSArray arrayWithArray:[localDataProvider fetchSavedCards]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [savedTable reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return savedCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBCardCell *cell = (DBCardCell *)[tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    
    MTGCard *card = [savedCards objectAtIndex:indexPath.row];
    [cell updateWithCard:card];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBCardsViewController *cardsViewController = (DBCardsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"Cards"];
    [cardsViewController setCards:savedCards];
    [cardsViewController setCurrentPosition:indexPath.row];
    [cardsViewController setTitle:NSLocalizedString(@"Saved", @"saved")];
    cardsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardsViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionClick andLabel:[NSString stringWithFormat:@"card_at_pos:%ld", (long)indexPath.row]];
}


@end
