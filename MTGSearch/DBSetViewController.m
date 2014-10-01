//
//  DBFirstViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSetViewController.h"
#import <sqlite3.h>
#import <MBProgressHUD.h>
#import "MTGCard.h"
#import "DBAppDelegate.h"
#import "CardsDatabase.h"
#import "DBSetPickerViewController.h"
#import "DBCardsViewController.h"
#import "DBFilterViewController.h"
#import "UIViewController+FilterCards.h"

@interface DBSetViewController ()

@end

@implementation DBSetViewController

@synthesize cards, set, filteredCards;

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Cards";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(openFilter:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(pickSet:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    setLoaded = false;
    
    //self.navigationController.tabBarController.tabBar.barTintColor = [UIColor blackColor];
    self.navigationController.tabBarController.tabBar.tintColor = [DBAppDelegate blueColor];
    
    UITabBar *tabBar = self.navigationController.tabBarController.tabBar;
    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:0];
    [targetTabBarItem setTitle:NSLocalizedString(@"Cards", "@cards")];
    UIImage *selectedIcon = [UIImage imageNamed:@"tab_bar_cards_full"];
    [targetTabBarItem setSelectedImage:[selectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    [self loadSets];
}

- (void) viewWillAppear:(BOOL)animated{
    if (setLoaded){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        int indexSet = [userDefaults integerForKey:kSetId];
        if (currentIndexSet != indexSet){
            currentIndexSet = indexSet;
            [self loadSet];
        } else {
            if ([app_delegate filterHasChanged]){
                [self filterCards];
                [app_delegate setFilterChanged:NO];
            }
        }
    }
    [app_delegate trackPage:@"/main"];
}

- (void)pickSet:(UIBarButtonItem *)barButtonItem{
    DBSetPickerViewController *setPicker = (DBSetPickerViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SetPicker"];
    
    [self.navigationController pushViewController:setPicker animated:YES];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    
    MTGCard *card = [filteredCards objectAtIndex:indexPath.row];
    cell.textLabel.text = card.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"subtitle %d", indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBCardsViewController *cardsViewController = (DBCardsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"Cards"];
    [cardsViewController setCards:filteredCards];
    [cardsViewController setCurrentPosition:indexPath.row];
    [cardsViewController setNameSet:set.name];
    cardsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardsViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionClick andLabel:[NSString stringWithFormat:@"card_at_pos:%d", indexPath.row]];
}

- (void)loadSets{
    app_delegate.sets = [CardsDatabase database].gameSets;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentIndexSet = [userDefaults integerForKey:kSetId];
    //    NSLog(@"number of set loaded: %d", [sets count]);
    
    setLoaded = true;
    
    [self loadSet];
}

- (void) loadSet{
    set = [app_delegate.sets objectAtIndex: currentIndexSet];
    [app_delegate trackPage:[NSString stringWithFormat:@"/set/%@", set.code]];
    self.navigationItem.title = set.name;
    [self loadCardsOfSet];
}

- (void)loadCardsOfSet{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        cards = [[[CardsDatabase database] cardsOfSet:[set getId]] sortedArrayUsingSelector:@selector(compare:)];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self filterCards];
        });
    });
}

- (void)filterCards{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        filteredCards = [self realFilterCards:cards];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

@end
