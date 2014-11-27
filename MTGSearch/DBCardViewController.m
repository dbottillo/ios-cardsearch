//
//  DBCardViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardViewController.h"
#import "MTGCard.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "CardsDatabase.h"

@interface DBCardViewController ()

@end

@implementation DBCardViewController

@synthesize pageIndex, totalItems;
@synthesize cardImage, cardName, cardType, labelIndicator;
@synthesize cardCost, cardPowerToughness, cardText, cardPrice;
@synthesize ptTitle, manacostTitle, typeTitle, cardDetailContainer;
@synthesize card, heightImage, widthImage, leftImage, topImage;
@synthesize savedCards, localDataProvider, randomCards;
@synthesize favBtn, currentSavedCard;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
    [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"P/T", @"power toughness")]];
    [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Mana Cost", @"manacost")]];
    [typeTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Type", @"type")]];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
     favBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_fav_off"]  style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: shareBtn, favBtn, nil]];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    if ([UIScreen mainScreen].bounds.size.height < 500){
        w = [[UIScreen mainScreen] bounds].size.width - 66;
        [leftImage setConstant:33];
        [topImage setConstant:8];
    }
    [widthImage setConstant:w];
    [heightImage setConstant:w*1.4];
    
    if (isLucky){
        localDataProvider = [[LocalDataProvider alloc] init];
        randomCards = [[NSMutableArray alloc] init];
        
        needToLoadCard = YES;
        isLoading = NO;
        
        self.navigationItem.title = NSLocalizedString(@"Lucky?","lucky?");
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
        singleTap.numberOfTapsRequired = 1;
        cardImage.userInteractionEnabled = YES;
        [cardImage addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *singleTapOnDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
        singleTapOnDetail.numberOfTapsRequired = 1;
        [cardDetailContainer setUserInteractionEnabled:YES];
        [cardDetailContainer addGestureRecognizer:singleTapOnDetail];

        
        [self loadRandomCards];
    } else {
        [self update];
    }

}

- (void) setLuckyModeOff{
    isLucky = NO;
}

- (void) setLuckyModeOn{
    isLucky = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadSavedCards];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) update{
    [cardName setText:card.name];
    [cardType setText:card.type];
    [cardCost setText:card.manaCost];
    [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",card.power,card.toughness]];
    [cardText setText:card.text];
    [cardText sizeToFit];
    
    [cardImage setHidden:YES];
    [cardDetailContainer setHidden:NO];
    if (showImage){
        cardImage.image = nil;
        NSString *url = [NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", [card getMultiverseId]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            cardImage.image = responseObject;
            [cardImage setHidden:NO];
            [cardDetailContainer setHidden:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cardImage setHidden:YES];
            [cardDetailContainer setHidden:NO];
        }];
        [requestOperation start];
    }
    [self updatePriceWith:NSLocalizedString(@"Loading...", @"loading")];
    NSString *url = [NSString stringWithFormat:@"http://magictcgprices.appspot.com/api/tcgplayer/price.json?cardname=%@", [card.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updatePriceWith:[responseObject objectAtIndex:0]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self updatePriceWith:NSLocalizedString(@"Error", @"error price")];
    }];
    
    if (isLucky){
        [labelIndicator setHidden:YES];
    } else {
        [labelIndicator setText:[NSString stringWithFormat:@"%ld / %ld", ((long)pageIndex + 1), (long)totalItems]];
    }
    if (isLucky){
        [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionLucky andLabel:card.name];
    }
    NSString *track = [NSString stringWithFormat:@"/card/%d",[((MTGCard *)card) getMultiverseId]];
    [app_delegate trackPage:track];
}

- (void) updatePriceWith:(NSString *) string{
    [cardPrice setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Price", "@price"), string]];
}

- (void)setShowImage:(BOOL)_show{
    showImage = _show;
}


- (void)save:(UIBarButtonItem *)barButtonItem{
    if (currentSavedCard){
        [localDataProvider removeCard:currentSavedCard];
    } else {
        [localDataProvider addCard:card];
    }
    [self loadSavedCards];
}

- (void)share:(UIBarButtonItem *)barButtonItem{
    NSString *text = card.name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", card.getMultiverseId]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [app_delegate trackEventWithCategory:kUACategoryUI andAction:kUAActionOpen andLabel:@"share"];
}


- (void) checkSavedCard{
    currentSavedCard = nil;
    for (MTGCard *cardSaved in savedCards){
        if([cardSaved getMultiverseId] == [card getMultiverseId]){
            currentSavedCard = cardSaved;
            break;
        }
    }
    if (currentSavedCard){
        [favBtn setImage:[[UIImage imageNamed:@"nav_icon_fav_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    } else {
        [favBtn setImage:[UIImage imageNamed:@"nav_icon_fav_off"]];
    }
}



// lucky mode
- (void) loadSavedCards{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        savedCards = [NSArray arrayWithArray:[localDataProvider fetchSavedCards]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkSavedCard];
        });
    });
}

- (void) loadRandomCards{
    if (isLoading){
        return;
    }
    isLoading = YES;
    if (needToLoadCard){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *newCards = [[CardsDatabase database] randomCards];
        for (MTGCard *newCard in newCards){
            [randomCards addObject:newCard];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (needToLoadCard){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self popCard];
                needToLoadCard = NO;
            }
            isLoading = NO;
        });
    });
}

- (void)popCard{
    card = [randomCards objectAtIndex:0];
    [self update];
    [self checkSavedCard];
    [randomCards removeObjectAtIndex:0];
    if (randomCards.count == 0){
        needToLoadCard = YES;
    }
    if (randomCards.count < 2){
        [self loadRandomCards];
    }
}

- (void)tapOnImage{
    [self popCard];
}

@end
