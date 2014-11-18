//
//  LocalDataProvider.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 16/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NanoStore.h"
#import "MTGCard.h"

#define     kSqliteNanostore    @"mtg.sqlite"

#define     kBagSaved       @"savedd"

@interface LocalDataProvider : NSObject

@property (strong, nonatomic) NSFNanoStore *nanoStore;

- (BOOL) addCard:(MTGCard *)card;
- (BOOL) removeCard:(MTGCard *)card;
- (void)cleanDatabase;

- (NSArray *) fetchSavedCards;
+ (NSString *)pathForNanoStore;

@end
