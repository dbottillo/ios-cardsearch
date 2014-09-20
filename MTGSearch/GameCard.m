//
//  GameCard.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "GameCard.h"

@implementation GameCard

@synthesize name;

- (void)setId:(int)newId{
    setId = newId;
}

- (int)getId{
    return setId;
}

@end
