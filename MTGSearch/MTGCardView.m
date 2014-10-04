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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup{
    [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
    [ptTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"P/T", @"power toughness")]];
    [manacostTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Mana Cost", @"manacost")]];
    [typeTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Type", @"type")]];
}

- (void) updateWithCard:(MTGCard *)card{
    [cardName setText:card.name];
    [cardType setText:card.type];
    [cardCost setText:card.manaCost];
    [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",card.power,card.toughness]];
    [cardText setText:card.text];
    [cardText sizeToFit];
}

- (void) updatePriceWith:(NSString *) string{
    [cardPrice setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Price", "@price"), string]];
}

- (void) updateLabelIndicator:(int) current AndTotal:(int)total{
    [labelIndicator setText:[NSString stringWithFormat:@"%d / %d", current, total]];
}

@end
