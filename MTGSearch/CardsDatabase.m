//
//  CardsDatabase.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "CardsDatabase.h"
#import "MTGSet.h"

@implementation CardsDatabase

static CardsDatabase *_database;

+ (CardsDatabase*)database {
    if (_database == nil) {
        _database = [[CardsDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"mtgsearch"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        } else {
            NSLog(@"Database opened!");
        }
    }
    return self;
}

- (NSArray *)gameSets{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * FROM MTGSet";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            
            char *code = (char *) sqlite3_column_text(statement, 1);
            char *name = (char *) sqlite3_column_text(statement, 2);
            
            MTGSet *set = [[MTGSet alloc] init];
            [set setName:[[NSString alloc] initWithUTF8String:name]];
            [set setCode:[[NSString alloc] initWithUTF8String:code]];
            
            [retval addObject:set];
            
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
