//
//  CardsDatabase.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface CardsDatabase : NSObject{
    sqlite3 *_database;
}

+ (CardsDatabase*)database;

- (NSArray *)gameSets;

- (NSArray *)cardsOfSet:(int)idSet;

@end
