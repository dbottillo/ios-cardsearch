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
        if ([card isWhite]) {
            colorIndicator = [DBAppDelegate greyWhite];
        } else if ([card isBlue]) {
            colorIndicator = [DBAppDelegate greyBlue];
        } else if ([card isBlack]) {
            colorIndicator = [DBAppDelegate greyBlack];
        } else if ([card isRed]) {
            colorIndicator = [DBAppDelegate greyRed];
        } else if ([card isGreen]) {
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
    if ([card isUncommon]){
        colorRarity = [DBAppDelegate unCommon];
        textRariry = @"U";
    } else if ([card isRare]){
        colorRarity = [DBAppDelegate rare];
        textRariry = @"R";
    } else if ([card isMythic]){
        colorRarity = [DBAppDelegate Mythic];
        textRariry = @"M";
    }
    [cardRarity setTextColor:colorRarity];
    [cardRarity setText:textRariry];
    
}

@end
