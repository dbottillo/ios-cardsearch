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
#import "MTGCardView.h"
#import "DBSettingsViewController.h"
#import <AFNetworking.h>

@interface DBCardsViewController ()
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@end

@implementation DBCardsViewController

@synthesize cards,carousel, nameSet;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    carousel.type = iCarouselTypeLinear;
    carousel.pagingEnabled = YES;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.title = nameSet;
}

- (void) viewWillAppear:(BOOL)animated{
    [carousel scrollToItemAtIndex:currentPosition animated:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    showImage = [userDefaults boolForKey:kUserImage];
    [carousel reloadData];
    
    [app_delegate trackPage:@"/cards"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [carousel setHidden:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share:(UIBarButtonItem *)barButtonItem{
    MTGCard *card = [cards objectAtIndex:carousel.currentItemIndex];
    NSString *text = card.name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", card.getMultiverseId]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionOpen andLabel:@"share"];
}

- (void)setCurrentPosition:(NSInteger)pos{
    currentPosition = pos;
}


#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    //return the total number of items in the carousel
    return [cards count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    //create new view if no view is available for recycling
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"MTGCardView" owner:self options:nil] lastObject];
        [((MTGCardView *)view) setup];
    }
    
    MTGCardView *cardView = (MTGCardView *)view;
    GameCard *card = [cards objectAtIndex:index];
    
    [cardView.cardImage setHidden:NO];
    if (showImage){
        cardView.cardImage.image = nil;
        NSString *url;
        if ([DBAppDelegate isMagic]){
            url = [NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", ((MTGCard *)card).getMultiverseId];
        } else {
            url = [NSString stringWithFormat:@"http://wow.zamimg.com/images/hearthstone/cards/enus/original/%@.png", ((HSCard *)card).hearthstoneId];
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            cardView.cardImage.image = responseObject;
            [cardView.cardImage setHidden:NO];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[cardView.cardImage setHidden:YES];
        }];
        [requestOperation start];
    }
    if ([DBAppDelegate isMagic]){
        [cardView updatePriceWith:NSLocalizedString(@"Loading...", @"loading")];
        NSString *url = [NSString stringWithFormat:@"http://magictcgprices.appspot.com/api/tcgplayer/price.json?cardname=%@", [card.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [cardView updatePriceWith:[responseObject objectAtIndex:0]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cardView updatePriceWith:NSLocalizedString(@"Error", @"error price")];
        }];
    } else {
        [cardView.cardPrice setHidden:YES];
    }
    
    [cardView updateWithCard:card];
    [cardView updateLabelIndicator:index AndTotal:cards.count];
    
    NSString *track;
    if ([DBAppDelegate isMagic]){
        track = [NSString stringWithFormat:@"/card/%d",[((MTGCard *)card) getMultiverseId]];
    } else {
        track = [NSString stringWithFormat:@"/card/%@",[((HSCard *)card) hearthstoneId]];
    }
    [app_delegate trackPage:track];
    
    
    return view;
}

@end
