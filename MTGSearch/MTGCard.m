//
//  MTGCard.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGCard.h"
@implementation MTGCard

@synthesize type, types, subTypes, colors, rarity, power, toughness, manaCost, text, setName, name;

- (id)initNanoObjectFromDictionaryRepresentation:(NSDictionary *)theDictionary forKey:(NSString *)aKey store:(NSFNanoStore *)theStore{
    if (self = [super initNanoObjectFromDictionaryRepresentation:theDictionary forKey:aKey store:theStore]) {
        name = [theDictionary objectForKey:kNanoKeyName];
        type = [theDictionary objectForKey:kNanoKeyType];
        multiverseId = [[theDictionary objectForKey:kNanoKeyMultiverseId] intValue];
    }
    
    return self;
}

- (NSDictionary *)nanoObjectDictionaryRepresentation{
    NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:name, kNanoKeyName,
                         type, kNanoKeyType,
                         [NSNumber numberWithInt:multiverseId], kNanoKeyMultiverseId, nil];
    return ret;
}

- (id)initWithName:(NSString *)_name{
    self = [super init];
    if (self != nil){
        name = _name;
        isMultiColor = NO;
        isALand = NO;
        isAnArtifact = NO;
        isAnEldrazi = NO;
        self.colors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setId:(int)newId{
    setId = newId;
}

- (int)getId{
    return setId;
}

- (void)setManaCostConverted:(int)manaCostConverted{
    self->cmc = manaCostConverted;
}

- (int) getCmc{
    return cmc;
}

- (void)setMultiverseId:(int)idMultiverse{
    self->multiverseId = idMultiverse;
}

- (int) getMultiverseId{
    return multiverseId;
}

- (void)setAsMultiColor{
    isMultiColor = YES;
}

- (BOOL)isMultiColor{
    return isMultiColor;
}

- (void)setAsLand{
    isALand = YES;
}

- (BOOL)isALand{
    return isALand;
}

- (void)setAsArtifact{
    isAnArtifact = YES;
}

- (BOOL)isAnArtifact{
    return isAnArtifact;
}

- (void)setAsEldrazi{
    isAnEldrazi = YES;
}

- (BOOL)isAnEldrazi{
    return isAnEldrazi;
}

- (void)convertColors:(NSArray *)newColors{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *color in newColors){
        if ([color isEqualToString:@"White"]){
            [temp addObject:[NSNumber numberWithInteger:kColorWhite]];
        }
        if ([color isEqualToString:@"Blue"]){
            [temp addObject:[NSNumber numberWithInteger:kColorBlue]];
        }
        if ([color isEqualToString:@"Black"]){
            [temp addObject:[NSNumber numberWithInteger:kColorBlack]];
        }
        if ([color isEqualToString:@"Red"]){
            [temp addObject:[NSNumber numberWithInteger:kColorRed]];
        }
        if ([color isEqualToString:@"Green"]){
            [temp addObject:[NSNumber numberWithInteger:kColorGreen]];
        }
    }
    self.colors = [[NSArray alloc] initWithArray:temp];
}

- (NSComparisonResult)compare:(MTGCard *)otherCard {
    if (isALand && otherCard.isALand) return NSOrderedSame;
    if (!isALand && otherCard.isALand) return NSOrderedAscending;
    if (isALand) return NSOrderedDescending;
    
    if (isAnArtifact && otherCard.isAnArtifact) return NSOrderedSame;
    if (!isAnArtifact && otherCard.isAnArtifact) return NSOrderedAscending;
    if (isAnArtifact) return NSOrderedDescending;
    
    if (isMultiColor && otherCard.isMultiColor) return NSOrderedSame;
    if (!isMultiColor && otherCard.isMultiColor) return NSOrderedAscending;
    if (isMultiColor) return NSOrderedDescending;

    int color = [(NSNumber *)[self.colors objectAtIndex:0] integerValue];
    int otherColor = [(NSNumber *)[otherCard.colors objectAtIndex:0] integerValue];
    if (color == otherColor) return NSOrderedSame;
    if (color < otherColor) return NSOrderedAscending;

    return NSOrderedDescending;
}

- (NSString *)nanoObjectKey{
    return self.key;
}

- (id) rootObject{
    return self;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"[MTGCard] %@ - %d ", self.name, multiverseId];
}

@end
