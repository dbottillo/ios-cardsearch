//
//  DBCardsViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardsViewController.h"
#import "MTGCard.h"
#import "HSCard.h"
#import "DBFullCardCell.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DBSettingsViewController.h"
#import <AFNetworking.h>
#import "DBCardViewController.h"

@interface DBCardsViewController ()
@end

@implementation DBCardsViewController

@synthesize cards, nameSet, pageViewController;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    showImage = [userDefaults boolForKey:kUserImage];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    DBCardViewController *startingViewController = [self viewControllerAtIndex:currentPosition];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void) viewWillAppear:(BOOL)animated{
    [app_delegate trackPage:@"/cards"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    GameCard *card = [cards objectAtIndex:index];
    [cardViewController setCard:card];
    [cardViewController setShowImage:showImage];

    return cardViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    DBCardViewController *currentView = [self.pageViewController.viewControllers objectAtIndex:0];
    currentPosition = currentView.pageIndex;
}


@end
