//
//  MTGCardPrice.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 01/12/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGCardPrice.h"

@implementation MTGCardPrice

@synthesize hiPrice, lowprice, avgprice, link;

- (NSString *)description{
    return [NSString stringWithFormat:@"[MTGCardPrice] %@ %@ %@ - %@", hiPrice, avgprice, lowprice, link];
}


@end
