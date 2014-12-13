//
//  LocalDataProvider.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 16/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "LocalDataProvider.h"
#import "NSFNanoBag.h"


#ifdef DEBUG
#   define __debugLog(fmt, args...) NSLog(@"[LocalDataProvider debug]: " fmt, ##args)
#else
#   define __debugLog(...)
#endif

@implementation LocalDataProvider

@synthesize nanoStore;

- (id) init{
    if (self = [super init]){
        [self openStore];
    }
    return self;
}

- (BOOL) addCard:(MTGCard *)card{
    if (nanoStore.isClosed) [self openStore];
    
    __debugLog(@"bags %@", [nanoStore bags]);
    
    NSFNanoBag *bag = [nanoStore bagWithName:kBagSaved];
    __debugLog(@"bag %@", bag);
    __debugLog(@"bag savedObjects %@", bag.savedObjects);
    
    if (!bag){
        NSLog(@"bag is nill!");
        bag = [NSFNanoBag bagWithName:kBagSaved];
        NSError *outError;
        BOOL res = [nanoStore addObject:bag error:&outError];
        if (res && nil == outError){
            __debugLog("bad %@ added correctly", bag);
        } else {
            __debugLog("error adding bag %@",outError);
            return NO;
        }
    }
    
    NSError *outError;
    BOOL res = [bag addObject:card error:&outError];
    if (res && nil == outError){
        NSError *outErrorSave;
        BOOL resSave = [bag saveAndReturnError:&outErrorSave];
        if (resSave && nil == outErrorSave){
            __debugLog("object %@ saved correctly", card.name);
        }else{
            __debugLog("error saving object %@",outErrorSave);
        }
        res = resSave;
    }else{
        __debugLog("error adding object %@",outError);
    }

    return res;
}

- (BOOL) removeCard:(MTGCard *)card{
    if (nanoStore.isClosed) [self openStore];
    
    NSError *outError;
    BOOL res = [nanoStore removeObject:card error:&outError];
    if (nil == outError){
        __debugLog("object %@ removed correctly", card);
    }else{
        __debugLog("error adding object %@",outError);
    }
    return res;
}

- (NSArray *) fetchSavedCards{
    if (nanoStore.isClosed) [self openStore];
    
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    NSFNanoBag *bag = [nanoStore bagWithName:kBagSaved];
    for (NSString *key in bag.savedObjects.allKeys){
        MTGCard *object = [bag.savedObjects objectForKey:key];
        [ret addObject:object];
    }

    return ret;
}

- (void)cleanDatabase{
    if (nanoStore.isClosed) [self openStore];
    NSError *outError;
    [nanoStore removeAllObjectsFromStoreAndReturnError:&outError];
    if (nil == outError){
        __debugLog("removeAllObjectsFromStoreAndReturnError:: success");
        [self commitChangesAndCloseAndCompact:YES];
    }else{
        __debugLog("error cleaning database %@",outError);
    }
}

- (void) commitChangesAndCloseAndCompact:(BOOL)compact{
    NSError *outError;
    if ( YES == [nanoStore saveStoreAndReturnError:&outError]) {
        __debugLog("changes commited");
        
        if (compact) [nanoStore compactStoreAndReturnError: &outError];
        [self closeDatabase];
        
    }else{
        __debugLog("error committing changes %@",outError);
    }
}

- (void) closeDatabase{
    NSError *outError;
    [nanoStore closeWithError:&outError];
    if ( outError == nil ) {
        __debugLog("database closing: success!");
    }
    else {
        __debugLog("error closing database %@",outError);
    }
}

+ (NSString *)pathForNanoStore{
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [docs stringByAppendingPathComponent:kSqliteNanostore];
}

- (void)openStore{
    NSError *outError;
    nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType path:[LocalDataProvider pathForNanoStore] error:&outError];
    /*if (outError != nil) __debugLog(@"nanostore open with error: %@",outError);
    else __debugLog(@"nanostore open correctly: %@", nanoStore);*/
}

@end
