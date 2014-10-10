//
//  DBCardViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardViewController.h"
#import "MTGCard.h"
#import "HSCard.h"
#import <AFNetworking.h>

@interface DBCardViewController ()

@end

@implementation DBCardViewController

@synthesize pageIndex, totalItems;
@synthesize cardImage, cardName, cardType, labelIndicator;
@synthesize cardCost, cardPowerToughness, cardText, cardPrice;
@synthesize ptTitle, manacostTitle, typeTitle;
@synthesize card, heightImage, widthImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
    if ([DBAppDelegate isMagic]){
        [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"P/T", @"power toughness")]];
        [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Mana Cost", @"manacost")]];
    } else {
        [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"A/H", @"attack health")]];
        [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Cost", @"cost")]];
    }
    [typeTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Type", @"type")]];
    
    [self update];
    
    [widthImage setConstant:[[UIScreen mainScreen] bounds].size.width];
    [heightImage setConstant:[[UIScreen mainScreen] bounds].size.width*1.4];
    
    [cardImage setHidden:YES];
    if (showImage){
        cardImage.image = nil;
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
            cardImage.image = responseObject;
            [cardImage setHidden:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cardImage setHidden:YES];
        }];
        [requestOperation start];
    }
    if ([DBAppDelegate isMagic]){
        [self updatePriceWith:NSLocalizedString(@"Loading...", @"loading")];
        NSString *url = [NSString stringWithFormat:@"http://magictcgprices.appspot.com/api/tcgplayer/price.json?cardname=%@", [card.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self updatePriceWith:[responseObject objectAtIndex:0]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self updatePriceWith:NSLocalizedString(@"Error", @"error price")];
        }];
    } else {
        [self.cardPrice setHidden:YES];
    }

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *track;
    if ([DBAppDelegate isMagic]){
        track = [NSString stringWithFormat:@"/card/%d",[((MTGCard *)card) getMultiverseId]];
    } else {
        track = [NSString stringWithFormat:@"/card/%@",[((HSCard *)card) hearthstoneId]];
    }
    [app_delegate trackPage:track];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) update{
    if ([DBAppDelegate isMagic]){
        MTGCard *mtgCard = (MTGCard *)card;
        [cardName setText:mtgCard.name];
        [cardType setText:mtgCard.type];
        [cardCost setText:mtgCard.manaCost];
        [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",mtgCard.power,mtgCard.toughness]];
        [cardText setText:mtgCard.text];
    } else {
        HSCard *hsCard = (HSCard *)card;
        [cardName setText:hsCard.name];
        [cardType setText:hsCard.type];
        [cardCost setText:[NSString stringWithFormat:@"%lu",(unsigned long)hsCard.getCost]];
        [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",hsCard.attack,hsCard.health]];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[hsCard.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [cardText setAttributedText:attrStr];
    }
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
