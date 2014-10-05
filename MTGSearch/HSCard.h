//
//  HSCard.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 05/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "GameCard.h"

#define kRarityFree         @"Free"
#define kRarityCommon       @"Common"
#define kRarityRare         @"Rare"
#define kRarityEpic         @"Epic"
#define kRarityLegendary    @"Legendary"

@interface HSCard : GameCard{
    NSUInteger cost;
    BOOL collectible;
    BOOL elite;
}

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *rarity;
@property (strong, nonatomic) NSString *faction;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *mechanics;
@property (strong, nonatomic) NSString *attack;
@property (strong, nonatomic) NSString *health;
@property (strong, nonatomic) NSString *setName;
@property (strong, nonatomic) NSString *hearthstoneId;

- (id)initWithName:(NSString *)name;
- (void)setCost:(NSUInteger)_cost;
- (NSUInteger) getCost;

@end
