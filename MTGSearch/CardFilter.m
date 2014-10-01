//
//  CardFilter.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "CardFilter.h"

@implementation CardFilter

@synthesize filterKey, displayName, gaLabel;

- (id)initWithName:(NSString *)name andKey:(NSString *)key andState:(BOOL)state andGALabel:(NSString *)gaLabel{
    self = [super init];
    if (self != nil){
        self.displayName = name;
        self.filterKey = key;
        self.gaLabel = gaLabel;
        active = state;
    }
    return self;
}

- (void)setActive{
    active = YES;
}

- (void)setInactive{
    active = NO;
}

- (BOOL) isActive{
    return active;
}

@end
