//
//  DBCardCell.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 02/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBCardCell.h"

@implementation DBCardCell

@synthesize viewIndicator, cardCost, cardName, cardRarity;

- (void)updateWithCard:(GameCard *)card{
    
    [cardName setText:card.name];
    
    if ([DBAppDelegate isMagic]){
        MTGCard *mtgCard = (MTGCard *)card;
    
        if (mtgCard.manaCost != nil){
            NSString *displayCost = [mtgCard.manaCost stringByReplacingOccurrencesOfString:@"{" withString:@""];
            cardCost.text = [NSString stringWithFormat:@"- %@", [displayCost stringByReplacingOccurrencesOfString: @"}" withString:@""]];
        } else {
            cardCost.text = [mtgCard.types objectAtIndex:0];
        }
        UIColor *colorIndicator = [DBAppDelegate grey];
        if (!mtgCard.isMultiColor && !mtgCard.isAnArtifact && !mtgCard.isALand){
            int cardColor = [[mtgCard.colors objectAtIndex:0] intValue];
            //NSLog(@"%d card color", cardColor);
            if (cardColor == kColorWhite) {
                colorIndicator = [DBAppDelegate greyWhite];
            } else if (cardColor == kColorBlue) {
                colorIndicator = [DBAppDelegate greyBlue];
            } else if (cardColor == kColorBlack) {
                colorIndicator = [DBAppDelegate greyBlack];
            } else if (cardColor == kColorRed) {
                colorIndicator = [DBAppDelegate greyRed];
            } else if (cardColor == kColorGreen) {
                colorIndicator = [DBAppDelegate greyGreen];
            }
        } else if (mtgCard.isMultiColor){
            colorIndicator = [DBAppDelegate greyMulticolor];
        } else if (mtgCard.isAnArtifact){
            colorIndicator = [DBAppDelegate greyArtifact];
        }
        [viewIndicator setBackgroundColor:colorIndicator];
        
        UIColor *colorRarity = [DBAppDelegate common];
        NSString *textRariry = @"C";
        if ([mtgCard.rarity isEqualToString:kRarityUncommon]){
            colorRarity = [DBAppDelegate unCommon];
            textRariry = @"U";
        } else if ([mtgCard.rarity isEqualToString:kRarityRare]){
            colorRarity = [DBAppDelegate rare];
            textRariry = @"R";
        } else if ([mtgCard.rarity isEqualToString:kRarityMythic]){
            colorRarity = [DBAppDelegate Mythic];
            textRariry = @"M";
        }
        [cardRarity setTextColor:colorRarity];
        [cardRarity setText:textRariry];
        
    } else{
        HSCard *hsCard = (HSCard *)card;
        //cardCost.text = [NSString stringWithFormat:@"- %@: %d", NSLocalizedString(@"Cost", "@cost"), hsCard.getCost];
        
        UIColor *colorRarity = [DBAppDelegate common];
        if ([hsCard.rarity isEqualToString:kRarityCommon]){
            colorRarity = [DBAppDelegate common];
        } else if ([hsCard.rarity isEqualToString:kRarityRare]){
            colorRarity = [DBAppDelegate rare];
        } else if ([hsCard.rarity isEqualToString:kRarityEpic]){
            colorRarity = [DBAppDelegate epic];
        } else if ([hsCard.rarity isEqualToString:kRarityLegendary]){
            colorRarity = [DBAppDelegate legendary];
        }
        [cardCost setText:[NSString stringWithFormat:@" %@", hsCard.rarity]];
        [cardCost setTextColor:colorRarity];
        
        [cardRarity setText:[NSString stringWithFormat:@"%d", hsCard.getCost]];

    }
    
    //   NSLog(@"%@ card name", card.name);
    // NSLog(@"card color %@", card.colors);
    
    //    cell.textLabel.text = card.name;
    //  cell.detailTextLabel.text = [NSString stringWithFormat:@"subtitle %d", indexPath.row];
    

}

@end
