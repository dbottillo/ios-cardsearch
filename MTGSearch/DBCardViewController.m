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

@interface DBCardViewController ()

@end

@implementation DBCardViewController

@synthesize pageIndex, totalItems;
@synthesize cardImage, cardName, cardType, labelIndicator;
@synthesize cardCost, cardPowerToughness, cardText, cardPrice;
@synthesize ptTitle, manacostTitle, typeTitle, cardDetailContainer;
@synthesize card, heightImage, widthImage, leftImage, topImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
    [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"P/T", @"power toughness")]];
    [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Mana Cost", @"manacost")]];
    [typeTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Type", @"type")]];
    
    [self update];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    if ([UIScreen mainScreen].bounds.size.height < 500){
        w = [[UIScreen mainScreen] bounds].size.width - 66;
        [leftImage setConstant:33];
        [topImage setConstant:8];
    }
    [widthImage setConstant:w];
    [heightImage setConstant:w*1.4];
    
    
    [cardImage setHidden:YES];
    [cardDetailContainer setHidden:NO];
    if (showImage){
        cardImage.image = nil;
        NSString *url = [NSString stringWithFormat:@"http://mtgimage.com/multiverseid/%d.jpg", ((MTGCard *)card).getMultiverseId];
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


}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *track = [NSString stringWithFormat:@"/card/%d",[((MTGCard *)card) getMultiverseId]];
    [app_delegate trackPage:track];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) update{
    MTGCard *mtgCard = (MTGCard *)card;
    [cardName setText:mtgCard.name];
    [cardType setText:mtgCard.type];
    [cardCost setText:mtgCard.manaCost];
    [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",mtgCard.power,mtgCard.toughness]];
    [cardText setText:mtgCard.text];
    [cardText sizeToFit];
    
    [labelIndicator setText:[NSString stringWithFormat:@"%ld / %ld", ((long)pageIndex + 1), (long)totalItems]];
}

- (void) updatePriceWith:(NSString *) string{
    [cardPrice setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Price", "@price"), string]];
}

- (void)setShowImage:(BOOL)_show{
    showImage = _show;
}


@end
