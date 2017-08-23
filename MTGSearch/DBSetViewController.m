//
//  DBFirstViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSetViewController.h"
#import <sqlite3.h>
#import "MBProgressHUD.h"
#import "MTGCard.h"
#import "DBAppDelegate.h"
#import "CardsDatabase.h"
#import "DBSetPickerViewController.h"
#import "DBCardsViewController.h"
#import "DBFilterViewController.h"
#import "DBCardViewController.h"
#import "UIViewController+FilterCards.h"
#import "UIViewController+NavBar.h"
#import "DBSettingsViewController.h"
#import "DBCardCell.h"

@interface DBSetViewController ()

@end

@implementation DBSetViewController

@synthesize cards, set, filteredCards, cardsTable;
@synthesize setName, setPicker;

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [cardsTable setDelegate:self];
    [cardsTable setDataSource:self];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_filter"]  style:UIBarButtonItemStylePlain target:self action:@selector(openFilter:)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_lucky"]  style:UIBarButtonItemStylePlain target:self action:@selector(lucky:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    setLoaded = false;
    
    //self.navigationController.tabBarController.tabBar.barTintColor = [UIColor blackColor];
    self.navigationController.tabBarController.tabBar.tintColor = [DBAppDelegate mainColor];
    self.navigationItem.title = @"MTG Cards Info";
    
    [self styleNavBar];
    
    UITabBar *tabBar = self.navigationController.tabBarController.tabBar;
    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:0];
    [[[tabBar items] objectAtIndex:1] setTitle:NSLocalizedString(@"Search", @"search")];
    [[[tabBar items] objectAtIndex:2] setTitle:NSLocalizedString(@"saved.title", nil)];
    [[[tabBar items] objectAtIndex:3] setTitle:NSLocalizedString(@"Settings", @"settings")];
    [targetTabBarItem setTitle:NSLocalizedString(@"Cards", @"cards")];
    NSString *tabBarImage = @"tab_bar_cards_full";

    UIImage *selectedIcon = [UIImage imageNamed:tabBarImage];
    [targetTabBarItem setSelectedImage:[selectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITapGestureRecognizer *singleTapOnDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSetPicker)];
    singleTapOnDetail.numberOfTapsRequired = 1;
    [setPicker setUserInteractionEnabled:YES];
    [setPicker addGestureRecognizer:singleTapOnDetail];
    
    [self loadSets];
}

- (void)tapOnSetPicker{
    [self pickSet:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    showImage = [userDefaults boolForKey:kUserImage];
    if (setLoaded){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger indexSet = [userDefaults integerForKey:kSetId];
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

- (IBAction)pickSet:(id)sender{
    DBSetPickerViewController *setPickerController = (DBSetPickerViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SetPicker"];
    
    [self.navigationController pushViewController:setPickerController animated:YES];
}

- (void)lucky:(id)sender{
    DBCardViewController *cardLuckyController = (DBCardViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
    [cardLuckyController setLuckyModeOn];
    cardLuckyController.hidesBottomBarWhenPushed = YES;
    [cardLuckyController setShowImage:showImage];
    [self.navigationController pushViewController:cardLuckyController animated:YES];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBCardCell *cell = (DBCardCell *)[tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    
    MTGCard *card = [filteredCards objectAtIndex:indexPath.row];
    [cell updateWithCard:card];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBCardsViewController *cardsViewController = (DBCardsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"Cards"];
    [cardsViewController setCards:filteredCards];
    [cardsViewController setCurrentPosition:indexPath.row];
    cardsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardsViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [app_delegate trackEventWithCategory:kUACategoryCard andAction:kUAActionSelect andLabel:[NSString stringWithFormat:@"%@ pos:%ld", set.name, (long)indexPath.row]];
}

- (void)loadSets{
    app_delegate.sets = [CardsDatabase database].gameSets;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentIndexSet = [userDefaults integerForKey:kSetId];
    if (kDebug){
        NSLog(@"number of set loaded: %lu", (unsigned long)app_delegate.sets.count);
    }
    
    setLoaded = true;
    
    [self loadSet];
}

- (void) loadSet{
    set = [app_delegate.sets objectAtIndex: currentIndexSet];
    [app_delegate trackPage:[NSString stringWithFormat:@"/set/%@", set.code]];
    [setName setText:set.name];
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
            [cardsTable reloadData];
            [cardsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    });
}
- (IBAction)changeOrder:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults boolForKey:kSortAlphabet]){
            [userDefaults setBool:NO forKey:kSortAlphabet];
        } else {
            [userDefaults setBool:YES forKey:kSortAlphabet];
        }
        [userDefaults synchronize];
        filteredCards = [self realFilterCards:cards];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [cardsTable reloadData];
            [cardsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    });
}

@end
