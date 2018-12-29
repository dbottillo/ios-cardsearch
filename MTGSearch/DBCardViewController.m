//
//  DBCardViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardViewController.h"
#import "MTGCard.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DBPriceCardParser.h"
#import "CardsDatabase.h"
#import "DBAppDelegate.h"

@interface DBCardViewController ()

@end

@implementation DBCardViewController

@synthesize pageIndex, totalItems, priceCard;
@synthesize cardImage, cardName, cardType, labelIndicator;
@synthesize cardCost, cardPowerToughness, cardText, cardPrice;
@synthesize ptTitle, manacostTitle, typeTitle, cardDetailContainer;
@synthesize card, heightImage, widthImage, leftImage, topImage;
@synthesize savedCards, localDataProvider, randomCards;
@synthesize favBtn, currentSavedCard;
@synthesize priceContainer, viewOnTCG;

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
        
        UISwipeGestureRecognizer *mSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnImage:)];
        [mSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
        
        [cardImage addGestureRecognizer:mSwipeRecognizer];
        
        UISwipeGestureRecognizer *mSwipeRecognizerOnDetail = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnImage:)];
        [mSwipeRecognizerOnDetail setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
        [cardDetailContainer addGestureRecognizer:mSwipeRecognizerOnDetail];
        
        [self loadRandomCards];
    } else {
        [self update];
    }
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openCardOnTCG:)];
    [priceContainer addGestureRecognizer:singleFingerTap];
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
        [self loadImage:[card imageUrl]];
    }
    if (isLucky){
        [labelIndicator setHidden:YES];
    } else {
        [labelIndicator setText:[NSString stringWithFormat:@"%ld / %ld", ((long)pageIndex + 1), (long)totalItems]];
    }
    [self updatePriceWith:NSLocalizedString(@"Loading...", @"loading")];
    [viewOnTCG setHidden:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    NSString *baseUrl = [NSString stringWithFormat:@"http://partner.tcgplayer.com/x3/phl.asmx/p?pk=MTGCARDSINFO&s=&p=%@", card.name];
    NSString *url = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"url: %@",url);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSData * data = (NSData *)responseObject;
        DBPriceCardParser *parser = [[DBPriceCardParser alloc] initWithData:data];
        self.priceCard = [parser parse];
        if (self.priceCard.hiPrice.length > 5){
            [self.cardPrice setText:[NSString stringWithFormat:@"H: %@$  -  L: %@$", self.priceCard.hiPrice, self.priceCard.lowprice]];
        } else {
            [self.cardPrice setText:[NSString stringWithFormat:@"H: %@$  A: %@$  L: %@$", self.priceCard.hiPrice, self.priceCard.avgprice,self. priceCard.lowprice]];
        }
        [self.viewOnTCG setHidden:NO];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        int statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if (statusCode == 500){
            [self.cardPrice setText:NSLocalizedString(@"Product not found on TCG", nil)];
        } else {
            [self updatePriceWith:NSLocalizedString(@"Error", @"error price")];
        }
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"price" andLabel:error.localizedDescription];
        if ([AFNetworkReachabilityManager sharedManager].reachable){
            [app_delegate trackEventWithCategory:kUACategoryError andAction:@"price-with-connection" andLabel:url];
        }

    }];

    NSString *track = [NSString stringWithFormat:@"/card/%d",[((MTGCard *)card) getMultiverseId]];
    [app_delegate trackPage:track];
}

- (void)loadImage:(NSString *)imageUrl{
    cardImage.image = nil;
    
    NSLog(@"url: %@",imageUrl);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        // Success
        self.cardImage.image = responseObject;
        [self.cardImage setHidden:NO];
        [self.cardDetailContainer setHidden:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        // Failure
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"image" andLabel:imageUrl];
        if ([AFNetworkReachabilityManager sharedManager].reachable){
            [app_delegate trackEventWithCategory:kUACategoryError andAction:@"image-with-connection" andLabel:imageUrl];
        }
        [self.cardImage setHidden:YES];
        [self.cardDetailContainer setHidden:NO];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void) updatePriceWith:(NSString *) string{
    [cardPrice setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Price", "@price"), string]];
}

- (void)setShowImage:(BOOL)_show{
    showImage = _show;
}

- (void)openCardOnTCG:(UIGestureRecognizer *)gesture{
    if (priceCard != nil && priceCard.link != nil){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:priceCard.link]];
    }
}


- (void)save:(UIBarButtonItem *)barButtonItem{
    if (currentSavedCard){
        [localDataProvider removeCard:currentSavedCard];
        [app_delegate trackEventWithCategory:kUACategoryFavourite andAction:kUAActionUnsaved andLabel:[NSString stringWithFormat:@"%d",currentSavedCard.getMultiverseId]];
    } else {
        [localDataProvider addCard:card];
        [app_delegate trackEventWithCategory:kUACategoryFavourite andAction:kUAActionSaved andLabel:[NSString stringWithFormat:@"%d",currentSavedCard.getMultiverseId]];
    }
    [self loadSavedCards];
}

- (void)share:(UIBarButtonItem *)barButtonItem{
    NSString *baseUrl =[NSString stringWithFormat:@"http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=%d", card.getMultiverseId];
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [app_delegate trackEventWithCategory:kUACategoryCard andAction:kUAActionShare andLabel:card.name];
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
        
        self.savedCards = [NSArray arrayWithArray:[localDataProvider fetchSavedCards]];
        
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
            [self.randomCards addObject:newCard];
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
    [app_delegate trackEventWithCategory:kUACategoryCard andAction:kUAActionLucky andLabel:card.name];
}

- (void)swipeOnImage:(UISwipeGestureRecognizer *)gesture{
    [self popCard];
}

- (void)tapOnImage{
    [self popCard];
}

@end
