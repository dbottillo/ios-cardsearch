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

@synthesize savedCards, savedTable, localDataProvider, emptyLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [emptyLabel setText:NSLocalizedString(@"no saved", @"no saved")];
    [emptyLabel setText:@"You don\'t have any favourite cards yet, use the star button on the card page to add it as a favourite."];
    [emptyLabel sizeToFit];
    
    self.navigationItem.title = NSLocalizedString(@"Saved", @"saved");
    
    [self styleNavBar];
    
    [savedTable setDataSource:self];
    [savedTable setDelegate:self];
    [emptyLabel setHidden:YES];
    
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
            if (savedCards.count == 0){
                [savedTable setHidden:YES];
                [emptyLabel setHidden:NO];
            } else {
                [savedTable setHidden:NO];
                [emptyLabel setHidden:YES];
            }
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
