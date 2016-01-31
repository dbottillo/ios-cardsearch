//
//  UIViewController+FilterCards.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 21/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "UIViewController+FilterCards.h"
#import "MTGCard.h"
#import "DBFilterViewController.h"

@implementation UIViewController (FilterCards)

- (void)openFilter:(UIBarButtonItem *)barButtonItem{
    DBFilterViewController *filter = (DBFilterViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:filter];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (NSMutableArray *)realFilterCards:(NSArray *)cards{
    NSMutableArray *filteredCards = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (MTGCard *card in cards){
        BOOL toAdd = NO;
        
        /*if (card.colors.count > 0){
            NSNumber *number = [card.colors objectAtIndex:0];
            NSLog(@"card colors %@", number);
        }*/
        if ([card.colors containsObject:[NSNumber numberWithInt:kColorWhite]] && [userDefaults boolForKey:kFilterWhite]) toAdd = YES;
        if ([card.colors containsObject:[NSNumber numberWithInt:kColorBlue]] && [userDefaults boolForKey:kFilterBlue]) toAdd = YES;
        if ([card.colors containsObject:[NSNumber numberWithInt:kColorBlack]] && [userDefaults boolForKey:kFilterBlack]) toAdd = YES;
        if ([card.colors containsObject:[NSNumber numberWithInt:kColorRed]] && [userDefaults boolForKey:kFilterRed]) toAdd = YES;
        if ([card.colors containsObject:[NSNumber numberWithInt:kColorGreen]] && [userDefaults boolForKey:kFilterGreen]) toAdd = YES;
        
        if (card.isALand && [userDefaults boolForKey:kFilterLand]) toAdd = YES;
        if (card.isAnArtifact && [userDefaults boolForKey:kFilterArtifact]) toAdd = YES;
        
        if (toAdd && [card.rarity isEqualToString:kRarityCommon] && ![userDefaults boolForKey:kFilterCommon]) toAdd = NO;
        if (toAdd && [card.rarity isEqualToString:kRarityUncommon] && ![userDefaults boolForKey:kFilterUncommon]) toAdd = NO;
        if (toAdd && [card.rarity isEqualToString:kRarityRare] && ![userDefaults boolForKey:kFilterRare]) toAdd = NO;
        if (toAdd && [card.rarity isEqualToString:kRarityMythic] && ![userDefaults boolForKey:kFilterMyhtic]) toAdd = NO;
        
        if (!toAdd && card.isAnEldrazi) toAdd = YES;
        
        if (toAdd){
            //NSLog(@"adding");
            [filteredCards addObject:card];
        }
    }
    //    NSLog(@"filtering cards");
    
    BOOL alphabeticalOrder = [userDefaults boolForKey:kSortAlphabet];
    if (alphabeticalOrder){
        NSArray *sortedArray = [filteredCards sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MTGCard *card1 = (MTGCard *)obj1;
            MTGCard *card2 = (MTGCard *)obj2;
            return [card1.name compare:card2.name options:NSNumericSearch];
        }];
        return [NSMutableArray arrayWithArray:sortedArray];
    }
    return filteredCards;
}

@end
