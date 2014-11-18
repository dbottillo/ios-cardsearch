//
//  MTGTestObject.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 18/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGTestObject.h"

@implementation MTGTestObject

@synthesize type, name;


- (id)initNanoObjectFromDictionaryRepresentation:(NSDictionary *)theDictionary forKey:(NSString *)aKey store:(NSFNanoStore *)theStore{
    if (self = [super initNanoObjectFromDictionaryRepresentation:theDictionary forKey:aKey store:theStore]) {
        name = [theDictionary objectForKey:kNanoKeyName];
        type = [theDictionary objectForKey:kNanoKeyType];
    }
    
    return self;
}

- (NSDictionary *)nanoObjectDictionaryRepresentation{
    NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:
                         name, kNanoKeyName,
                         type, kNanoKeyType, nil];
    return ret;
}

- (NSString *)nanoObjectKey{
    return self.key;
}

- (id) rootObject{
    return self;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"[MTGTestObject] %@ - %@ ", self.key, self.name];
}

@end
