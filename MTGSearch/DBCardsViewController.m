//
//  DBCardsViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardsViewController.h"
#import "MTGCard.h"
#import "DBFullCardCell.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DBSettingsViewController.h"
#import <AFNetworking.h>
#import "DBCardViewController.h"
#import "LocalDataProvider.h"

@interface DBCardsViewController ()
@end

@implementation DBCardsViewController

@synthesize cards, pageViewController, savedCards, localDataProvider, favBtn, currentSavedCard;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    showImage = [userDefaults boolForKey:kUserImage];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    favBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_fav_off"]  style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: shareBtn, favBtn, nil]];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    DBCardViewController *startingViewController = [self viewControllerAtIndex:currentPosition];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    localDataProvider = [[LocalDataProvider alloc] init];
    
    self.navigationItem.title = @"";
}

- (void) viewWillAppear:(BOOL)animated{
    [app_delegate trackPage:@"/cards"];
    
    [self loadSavedCards];
}

- (void) loadSavedCards{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        savedCards = [NSArray arrayWithArray:[localDataProvider fetchSavedCards]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkSavedCard];
        });
    });
}

- (void)save:(UIBarButtonItem *)barButtonItem{
    if (currentSavedCard){
        [localDataProvider removeCard:currentSavedCard];
    } else {
        [localDataProvider addCard:[cards objectAtIndex:currentPosition]];
    }
    [self loadSavedCards];
}

- (void)share:(UIBarButtonItem *)barButtonItem{
    MTGCard *card = [cards objectAtIndex:currentPosition];
    NSString *text = card.name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", card.getMultiverseId]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionOpen andLabel:@"share"];
}

- (void)setCurrentPosition:(NSInteger)pos{
    currentPosition = pos;
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((DBCardViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((DBCardViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.cards count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (DBCardViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([self.cards count] == 0) || (index >= [self.cards count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    DBCardViewController *cardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
    cardViewController.pageIndex = index;
    cardViewController.totalItems = cards.count;
    
    MTGCard *card = [cards objectAtIndex:index];
    [cardViewController setCard:card];
    [cardViewController setShowImage:showImage];

    return cardViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed){
        DBCardViewController *currentView = [self.pageViewController.viewControllers objectAtIndex:0];
        currentPosition = currentView.pageIndex;
        [self checkSavedCard];
    }
}

- (void) checkSavedCard{
    currentSavedCard = nil;
    MTGCard *currentCard = [cards objectAtIndex:currentPosition];
    for (MTGCard *card in savedCards){
        NSLog(@"checking %d against %d", [card getMultiverseId], [currentCard getMultiverseId]);
        if([card getMultiverseId] == [currentCard getMultiverseId]){
            currentSavedCard = card;
            break;
        }
    }
    if (currentSavedCard){
        [favBtn setImage:[[UIImage imageNamed:@"nav_icon_fav_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    } else {
        [favBtn setImage:[UIImage imageNamed:@"nav_icon_fav_off"]];
    }
}


@end
