//
//  MTGCardView.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGCardView.h"

@implementation MTGCardView

@synthesize cardImage, cardName, cardType, labelIndicator;
@synthesize cardCost, cardPowerToughness, cardText, cardPrice;
@synthesize ptTitle, manacostTitle, typeTitle;
@synthesize heightImage, widthImage;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup{
    [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
    if ([DBAppDelegate isMagic]){
        [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"P/T", @"power toughness")]];
        [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Mana Cost", @"manacost")]];
    } else {
        [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"A/H", @"attack health")]];
        [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Cost", @"cost")]];
    }
    [typeTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Type", @"type")]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight < 500){
        // iphone 4S, the only one with a small screen
        [widthImage setConstant:300];
        [heightImage setConstant:420];
    }
}

- (void) updateWithCard:(GameCard *)card{
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
        [cardCost setText:[NSString stringWithFormat:@"%d",hsCard.getCost]];
        [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",hsCard.attack,hsCard.health]];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[hsCard.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [cardText setAttributedText:attrStr];
    }
    [cardText sizeToFit];
}

- (void) updatePriceWith:(NSString *) string{
    [cardPrice setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Price", "@price"), string]];
}

- (void) updateLabelIndicator:(NSInteger) current AndTotal:(NSInteger)total{
    [labelIndicator setText:[NSString stringWithFormat:@"%ld / %ld", (long)current, (long)total]];
}

@end
