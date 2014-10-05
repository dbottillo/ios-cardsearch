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
#import "HSCard.h"
#import "DBAppDelegate.h"

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
        if (![DBAppDelegate isMagic]){
            name = @"hssearch";
        }
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:name
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
    if (![DBAppDelegate isMagic]){
        query = @"SELECT * from HSSet";
    }
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            
            if ([DBAppDelegate isMagic]){
            
                char *code = (char *) sqlite3_column_text(statement, 1);
                char *name = (char *) sqlite3_column_text(statement, 2);
            
                MTGSet *set = [[MTGSet alloc] init];
                [set setName:[[NSString alloc] initWithUTF8String:name]];
                [set setCode:[[NSString alloc] initWithUTF8String:code]];
                [set setId:uniqueId];
                [retval addObject:set];
                
            } else {
                char *name = (char *) sqlite3_column_text(statement, 1);
                
                GameSet *set = [[GameSet alloc] init];
                [set setName:[[NSString alloc] initWithUTF8String:name]];
                [set setId:uniqueId];
                [retval addObject:set];

            }
            
            
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (NSArray *)cardsOfSet:(int)idSet{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *table = @"MTGCard";
    if (![DBAppDelegate isMagic]){
        table = @"HSCard";
    }
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE setId=%d", table, idSet];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [retval addObject:[self generateCardFromStatement:statement]];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (NSArray *)cardsOfSearch:(NSString *)text{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *table = @"MTGCard";
    if (![DBAppDelegate isMagic]){
        table = @"HSCard";
    }
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name LIKE '%%%@%%'", table, text];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [retval addObject:[self generateCardFromStatement:statement]];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (GameCard *)generateCardFromStatement:(sqlite3_stmt *) statement{
    if ([DBAppDelegate isMagic]) return [self generateMTGCardFromStatement:statement];
    return [self generateHSCardFromStatement:statement];
}

- (MTGCard *)generateMTGCardFromStatement:(sqlite3_stmt *) statement{
    /*int numberOfColumns = sqlite3_column_count(statement);
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
    
    if (!card.isMultiColor && !card.isALand && !card.isAnArtifact && card.colors.count == 0){
        [card setAsEldrazi];
    }
    return card;
}

- (HSCard *)generateHSCardFromStatement:(sqlite3_stmt *) statement{
    
    char *name = (char *) sqlite3_column_text(statement, 1);
    HSCard *card = [[HSCard alloc] initWithName:[[NSString alloc] initWithUTF8String:name]];
    
    char *type = (char *) sqlite3_column_text(statement, 2);
    [card setType:[[NSString alloc] initWithUTF8String:type]];
    
    int cmc = sqlite3_column_int(statement, 3);
    [card setCost:cmc];
    
    char *rarity = (char *) sqlite3_column_text(statement, 4);
    NSString *rarityS = [[NSString alloc] initWithUTF8String:rarity];
    if (rarityS.length == 0){
        rarityS = kRarityFree;
    }
    [card setRarity:rarityS];
    
    char *faction = (char *) sqlite3_column_text(statement, 5);
    if (faction != nil){
        [card setFaction:[[NSString alloc] initWithUTF8String:faction]];
    }
    
    char *text = (char *) sqlite3_column_text(statement, 6);
    if (text != nil){
        [card setText:[[NSString alloc] initWithUTF8String:text]];
    }
    
    char *attack = (char *) sqlite3_column_text(statement, 8);
    if (attack != nil){
        [card setAttack:[[NSString alloc] initWithUTF8String:attack]];
    }
    
    char *health = (char *) sqlite3_column_text(statement, 9);
    if (health != nil){
        [card setHealth:[[NSString alloc] initWithUTF8String:health]];
    }
    
    int setID = sqlite3_column_int(statement, 12);
    [card setId:setID];
    
    char *setName = (char *) sqlite3_column_text(statement, 13);
    [card setSetName:[[NSString alloc] initWithUTF8String:setName]];
    
    char *hearthstoneId = (char *) sqlite3_column_text(statement, 14);
    [card setHearthstoneId:[[NSString alloc] initWithUTF8String:hearthstoneId]];
    
    return card;
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
