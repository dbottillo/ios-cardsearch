//
//  MTGCardView.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGCardView.h"

@implementation MTGCardView

@synthesize cardImage, cardName, cardType;
@synthesize cardCost, cardPowerToughness, cardText, bannerView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) updateWithCard:(MTGCard *)card andRootViewController:(UIViewController *)rootViewController{
    [cardName setText:card.name];
    [cardType setText:card.type];
    [cardCost setText:card.manaCost];
    [cardPowerToughness setText:[NSString stringWithFormat:@"%@/%@",card.power,card.toughness]];
    [cardText setText:card.text];
    [cardText sizeToFit];
    
    bannerView.adUnitID = @"ca-app-pub-8119815713373556/8777882818";
    bannerView.rootViewController = rootViewController;
    [app_delegate generateADMobRequestForView:bannerView];
}


@end
