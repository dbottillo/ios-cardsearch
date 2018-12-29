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
        BOOL skip = NO;
        if ([card isWhite] && ![userDefaults boolForKey:kFilterWhite]) skip = YES;
        if ([card isBlue] && ![userDefaults boolForKey:kFilterBlue]) skip = YES;
        if ([card isBlack] && ![userDefaults boolForKey:kFilterBlack]) skip = YES;
        if ([card isRed] && ![userDefaults boolForKey:kFilterRed]) skip = YES;
        if ([card isGreen] && ![userDefaults boolForKey:kFilterGreen]) skip = YES;
        
        if (card.isALand && ![userDefaults boolForKey:kFilterLand]) skip = YES;
        if (card.isAnArtifact && ![userDefaults boolForKey:kFilterArtifact]) skip = YES;
        
        if ([card isCommon] && ![userDefaults boolForKey:kFilterCommon]) {
            skip = YES;
        }
        if ([card isUncommon] && ![userDefaults boolForKey:kFilterUncommon]){
                skip = YES;
        }
        if ([card isRare] && ![userDefaults boolForKey:kFilterRare]) {
            skip = YES;
        }
        if ([card isMythic] && ![userDefaults boolForKey:kFilterMyhtic]) {
            skip = YES;
        }
        
        if (skip){
            //NSLog(@"removing %@", card);
        } else {
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
