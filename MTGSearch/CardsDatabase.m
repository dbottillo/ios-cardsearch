//
//  CardsDatabase.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "CardsDatabase.h"
#import "MTGSet.h"
#import "MTGCard.h"
#import "DBAppDelegate.h"

#ifdef DEBUG
#   define __debugLog(fmt, args...) NSLog(@"[CardsDatabase debug]: " fmt, ##args)
#else
#   define __debugLog(...)
#endif

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
        NSString *name = @"mtgsearch";
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:name
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            __debugLog(@"Failed to open database!");
            [app_delegate trackEventWithCategory:kUACategoryError andAction:@"failed to open database" andLabel:@""];
        } else {
            __debugLog(@"database opened!");
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
            
            char *code = (char *) sqlite3_column_text(statement, 2);
            char *name = (char *) sqlite3_column_text(statement, 1);
            
            MTGSet *set = [[MTGSet alloc] init];
            [set setName:[[NSString alloc] initWithUTF8String:name]];
            [set setCode:[[NSString alloc] initWithUTF8String:code]];
            [set setId:uniqueId];
            [retval addObject:set];
            
            NSLog(@"set created with %@ and %@",set.name, set.code);
            
        }
        sqlite3_finalize(statement);
    } else {
        __debugLog(@"Failed to load sets! %s",sqlite3_errmsg(_database));
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"failed to load sets" andLabel:[NSString stringWithFormat:@"%s",sqlite3_errmsg(_database)]];
    }
    return retval;
}

- (NSArray *)cardsOfSet:(int)idSet{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *table = @"MTGCard";
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE setId=%d", table, idSet];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [retval addObject:[self generateCardFromStatement:statement]];
        }
        sqlite3_finalize(statement);
    } else {
        __debugLog(@"Failed to load cards of a set! %s",sqlite3_errmsg(_database));
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"failed to load cards of a set" andLabel:[NSString stringWithFormat:@"%s",sqlite3_errmsg(_database)]];
    }
    return retval;
}

- (NSArray *)cardsOfSearch:(NSString *)text{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *table = @"MTGCard";
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name LIKE '%%%@%%'", table, text];
    sqlite3_stmt *statement;
    int res =sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
    if (res == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [retval addObject:[self generateCardFromStatement:statement]];
        }
        sqlite3_finalize(statement);
    } else {
        __debugLog(@"Failed to search cards! %s",sqlite3_errmsg(_database));
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"failed to search cards" andLabel:[NSString stringWithFormat:@"%s",sqlite3_errmsg(_database)]];
    }
    return retval;
}

- (NSArray *)randomCards{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM MTGCard ORDER BY RANDOM() LIMIT 4"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [retval addObject:[self generateCardFromStatement:statement]];
        }
        sqlite3_finalize(statement);
    } else {
        __debugLog(@"Failed to load random cards! %s",sqlite3_errmsg(_database));
        [app_delegate trackEventWithCategory:kUACategoryError andAction:@"failed to load random cards" andLabel:[NSString stringWithFormat:@"%s",sqlite3_errmsg(_database)]];
    }
    return retval;
}

- (MTGCard *)generateCardFromStatement:(sqlite3_stmt *) statement{
    return [self generateMTGCardFromStatement:statement];
}

- (MTGCard *)generateMTGCardFromStatement:(sqlite3_stmt *) statement{
    /*
     int numberOfColumns = sqlite3_column_count(statement);
     for (int i=0; i<numberOfColumns; i++){
     char *el = (char *) sqlite3_column_text(statement, i);
     NSLog(@"%d - value: %s", i, el);
     }*/
    
    char *name = (char *) sqlite3_column_text(statement, 1);
    MTGCard *card = [[MTGCard alloc] initWithName:[[NSString alloc] initWithUTF8String:name]];
    
    int uniqueId = sqlite3_column_int(statement, 0);
    [card setId:uniqueId];
    
    char *type = (char *) sqlite3_column_text(statement, 2);
    [card setType:[[NSString alloc] initWithUTF8String:type]];
    
    char *types = (char *) sqlite3_column_text(statement, 3);
    if (types != nil){
        NSString *stringTypes = [[NSString alloc] initWithUTF8String:type];
        [card setTypes:[stringTypes componentsSeparatedByString:@","]];
    }
    
    char *colors = (char *) sqlite3_column_text(statement, 5);
    if (colors != nil){
        NSString *stringColors = [[NSString alloc] initWithUTF8String:colors];
        [card convertColors:[stringColors componentsSeparatedByString:@","]];
    }
    
    int cmc = sqlite3_column_int(statement, 6);
    [card setManaCostConverted:cmc];
    
    char *rarity = (char *) sqlite3_column_text(statement, 7);
    [card setRarity:[[NSString alloc] initWithUTF8String:rarity]];
    
    char *power = (char *) sqlite3_column_text(statement, 8);
    [card setPower:[[NSString alloc] initWithUTF8String:power]];
    
    char *toughness = (char *) sqlite3_column_text(statement, 9);
    [card setToughness:[[NSString alloc] initWithUTF8String:toughness]];
    
    char *manaCost = (char *) sqlite3_column_text(statement, 10);
    if (manaCost != nil){
        [card setManaCost:[[NSString alloc] initWithUTF8String:manaCost]];
    }
    
    char *text = (char *) sqlite3_column_text(statement, 11);
    if (text != nil){
        [card setText:[[NSString alloc] initWithUTF8String:text]];
    }
    
    int multicolor = sqlite3_column_int(statement, 12);
    if (multicolor == 1){
        [card setAsMultiColor];
    }
    
    int land = sqlite3_column_int(statement, 13);
    if (land == 1){
        [card setAsLand];
    }
    
    int artifact = sqlite3_column_int(statement, 14);
    if (artifact == 1){
        [card setAsArtifact];
    }
    
    int multiverseId = sqlite3_column_int(statement, 15);
    [card setMultiverseId:multiverseId];
    
    int setID = sqlite3_column_int(statement, 16);
    [card setId:setID];
    
    char *setName = (char *) sqlite3_column_text(statement, 17);
    [card setSetName:[[NSString alloc] initWithUTF8String:setName]];
    
    char *rulings = (char *) sqlite3_column_text(statement, 18);
    if (rulings != nil){
        NSString *rules = [[NSString alloc] initWithUTF8String:rulings];
        NSError *jsonError;
        NSData *objectData = [rules dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        [json enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
            [card.rulings addObject:[obj objectForKey:@"text"]];
        }];
    }
    
    char *layout = (char *) sqlite3_column_text(statement, 19);
    [card setLayout:[[NSString alloc] initWithUTF8String:layout]];
    
    char *setCode = (char *) sqlite3_column_text(statement, 20);
    [card setSetCode:[[NSString alloc] initWithUTF8String:setCode]];
    
    int number = sqlite3_column_int(statement, 21);
    [card setNumber:number];
    
    char *colorsIdentity = (char *) sqlite3_column_text(statement, 30);
    if (colorsIdentity != nil){
        NSString *string = [[NSString alloc] initWithUTF8String:colorsIdentity];
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *colors = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        [card convertColorsIdentity:colors];
    }
    
    char *uuid = (char *) sqlite3_column_text(statement, 31);
    [card setUuid:[[NSString alloc] initWithUTF8String:uuid]];

    char *scryfallId = (char *) sqlite3_column_text(statement, 32);
    [card setScryfallId:[[NSString alloc] initWithUTF8String:scryfallId]];

    if ([card.type rangeOfString:@"Eldrazi"].location != NSNotFound) {
        [card setAsEldrazi];
    }
    
    return card;
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
