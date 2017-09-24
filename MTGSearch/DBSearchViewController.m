//
//  DBSearchViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 21/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSearchViewController.h"
#import "MTGCard.h"
#import "MBProgressHUD.h"
#import "CardsDatabase.h"
#import "UIViewController+FilterCards.h"
#import "DBCardsViewController.h"
#import "DBAppDelegate.h"
#import "DBCardCell.h"
#import "UIViewController+NavBar.h"

@interface DBSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UISearchBar *cardSearchBar;

@end

@implementation DBSearchViewController

@synthesize searchTable, cardSearchBar, cards, filteredCards;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"Search", @"search");

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_filter"]  style:UIBarButtonItemStylePlain target:self action:@selector(openFilter:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    gestureRecognizer.numberOfTapsRequired = 1;
    // create a view which covers most of the tap bar to
    // manage the gestures - if we use the navigation bar
    // it interferes with the nav buttons
    CGRect frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 44);
    UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    [self.navigationController.navigationBar addSubview:navBarTapView];
    navBarTapView.backgroundColor = [UIColor clearColor];
    [navBarTapView setUserInteractionEnabled:YES];
    [navBarTapView addGestureRecognizer:gestureRecognizer];
    
    [self styleNavBar];
    
    [searchTable setDataSource:self];
    [searchTable setDelegate:self];
    
    [cardSearchBar setDelegate:self];
}


- (void) viewWillAppear:(BOOL)animated{
    if ([app_delegate filterHasChangedForSearch]){
        [self filterCards];
        [app_delegate setFilterChangedSearch:NO];
    }
    [app_delegate trackPage:@"/search"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

-(void)navSingleTap{
    [cardSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cardsViewController setTitle:[NSString stringWithFormat:@"'%@'",cardSearchBar.text]];
    cardsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cardsViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [app_delegate trackEventWithCategory:kUACategoryCard andAction:kUAActionSelect andLabel:[NSString stringWithFormat:@"search pos:%ld", (long)indexPath.row]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length < 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Search error", @"search error")
                                                        message:NSLocalizedString(@"Search need at least three letters", "@need at leat three letters")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [searchBar resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        cards = [[[CardsDatabase database] cardsOfSearch:searchBar.text] sortedArrayUsingSelector:@selector(compare:)];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self filterCards];
        });
    });
    
    [app_delegate trackEventWithCategory:kUACategorySearch andAction:@"done" andLabel:searchBar.text];
}

- (void)filterCards{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        filteredCards = [self realFilterCards:cards];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [searchTable reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@ (%lu)",NSLocalizedString(@"Search", @"search"), (unsigned long)filteredCards.count];
            if (filteredCards.count > 0){
                [searchTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    });
}


@end
