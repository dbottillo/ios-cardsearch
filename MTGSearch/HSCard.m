//
//  HSCard.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 05/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "HSCard.h"

@implementation HSCard

@synthesize type, rarity, faction, text, mechanics;
@synthesize attack, health, setName, hearthstoneId;

- (id)initWithName:(NSString *)name{
    self = [super init];
    if (self != nil){
        self.name = name;
        self.faction = @"";
    }
    return self;
}

- (void)setCost:(NSUInteger)_cost{
    self->cost = _cost;
}

- (NSUInteger) getCost{
    return cost;
}

- (NSComparisonResult)compare:(HSCard *)otherCard {
    return [self.name compare:otherCard.name];
}


@end
