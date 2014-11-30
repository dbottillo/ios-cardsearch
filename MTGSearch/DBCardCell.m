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

- (void)updateWithCard:(MTGCard *)card{
    
    [cardName setText:card.name];
    
    if (card.manaCost != nil){
        NSString *displayCost = [card.manaCost stringByReplacingOccurrencesOfString:@"{" withString:@""];
        cardCost.text = [NSString stringWithFormat:@"- %@", [displayCost stringByReplacingOccurrencesOfString: @"}" withString:@""]];
    } else {
        cardCost.text = [card.types objectAtIndex:0];
    }
    UIColor *colorIndicator = [DBAppDelegate grey];
    if (!card.isMultiColor && !card.isAnArtifact && !card.isALand && !card.isAnEldrazi){
        int cardColor = [[card.colors objectAtIndex:0] intValue];
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
    } else if (card.isMultiColor){
        colorIndicator = [DBAppDelegate greyMulticolor];
    } else if (card.isAnArtifact){
        colorIndicator = [DBAppDelegate greyArtifact];
    }
    [viewIndicator setBackgroundColor:colorIndicator];
    
    UIColor *colorRarity = [DBAppDelegate common];
    NSString *textRariry = @"C";
    if ([card.rarity isEqualToString:kRarityUncommon]){
        colorRarity = [DBAppDelegate unCommon];
        textRariry = @"U";
    } else if ([card.rarity isEqualToString:kRarityRare]){
        colorRarity = [DBAppDelegate rare];
        textRariry = @"R";
    } else if ([card.rarity isEqualToString:kRarityMythic]){
        colorRarity = [DBAppDelegate Mythic];
        textRariry = @"M";
    }
    [cardRarity setTextColor:colorRarity];
    [cardRarity setText:textRariry];
    
    //   NSLog(@"%@ card name", card.name);
    // NSLog(@"card color %@", card.colors);
    
    //    cell.textLabel.text = card.name;
    //  cell.detailTextLabel.text = [NSString stringWithFormat:@"subtitle %d", indexPath.row];
    

}

@end
