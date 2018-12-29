//
//  MTGCard.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "MTGCard.h"
@implementation MTGCard

@synthesize type, types, subTypes, colors, rarity, power, toughness, manaCost, text, setName, name, setCode, uuid;
@synthesize rulings, layout, scryfallId, colorsIdentity;

- (id)initNanoObjectFromDictionaryRepresentation:(NSDictionary *)theDictionary forKey:(NSString *)aKey store:(NSFNanoStore *)theStore{
    if (self = [super initNanoObjectFromDictionaryRepresentation:theDictionary forKey:aKey store:theStore]) {
        [self createFromDictionary:theDictionary];
    }
    
    return self;
}

- (void)createFromDictionary:(NSDictionary *)dictionary{
    name = [dictionary objectForKey:kNanoKeyName];
    type = [dictionary objectForKey:kNanoKeyType];
    types = [dictionary objectForKey:kNanoKeyTypes];
    subTypes = [dictionary objectForKey:kNanoKeySubTypes];
    colors = [dictionary objectForKey:kNanoKeyColors];
    rarity = [dictionary objectForKey:kNanoKeyRarity];
    power = [dictionary objectForKey:kNanoKeyPower];
    toughness = [dictionary objectForKey:kNanoKeyToughness];
    manaCost = [dictionary objectForKey:kNanoKeyManaCost];
    text = [dictionary objectForKey:kNanoKeyText];
    setName = [dictionary objectForKey:kNanoKeySetName];
    setCode = [dictionary objectForKey:kNanoKeySetCode];
    setId = [[dictionary objectForKey:kNanoKeySetId] intValue];
    cmc = [[dictionary objectForKey:kNanoKeyCMC] intValue];
    isMultiColor = [[dictionary objectForKey:kNanoKeyIsMultiColor] boolValue];
    isALand = [[dictionary objectForKey:kNanoKeyIsALand] boolValue];
    isAnArtifact = [[dictionary objectForKey:kNanoKeyIsAnArtifact] boolValue];
    isAnEldrazi = [[dictionary objectForKey:kNanoKeyIsAnEldrazi] boolValue];
    multiverseId = [[dictionary objectForKey:kNanoKeyMultiverseId] intValue];
    number = [[dictionary objectForKey:kNanoKeyNumber] intValue];
    rulings = [dictionary objectForKey:kNanoKeyRulings];
    layout = [dictionary objectForKey:kNanoKeyLayout];
    colorsIdentity = [dictionary objectForKey:kNanoKeyColorsIdentity];
    uuid = [dictionary objectForKey:kNanoKeyUUID];
    scryfallId = [dictionary objectForKey:kNanoKeyScryfallId];
}

- (NSDictionary *)nanoObjectDictionaryRepresentation{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setValue:name forKey:kNanoKeyName];
    [ret setValue:type forKey:kNanoKeyType];
    [ret setValue:types forKey:kNanoKeyTypes];
    [ret setValue:subTypes forKey:kNanoKeySubTypes];
    [ret setValue:colors forKey:kNanoKeyColors];
    [ret setValue:rarity forKey:kNanoKeyRarity];
    [ret setValue:power forKey:kNanoKeyPower];
    [ret setValue:toughness forKey:kNanoKeyToughness];
    [ret setValue:manaCost forKey:kNanoKeyManaCost];
    [ret setValue:text forKey:kNanoKeyText];
    [ret setValue:setName forKey:kNanoKeySetName];
    [ret setValue:setCode forKey:kNanoKeySetCode];
    [ret setValue:[NSNumber numberWithInt:setId] forKey:kNanoKeySetId];
    [ret setValue:[NSNumber numberWithInt:cmc] forKey:kNanoKeyCMC];
    [ret setValue:[NSNumber numberWithBool:isMultiColor] forKey:kNanoKeyIsMultiColor];
    [ret setValue:[NSNumber numberWithBool:isALand] forKey:kNanoKeyIsALand];
    [ret setValue:[NSNumber numberWithBool:isAnArtifact] forKey:kNanoKeyIsAnArtifact];
    [ret setValue:[NSNumber numberWithBool:isAnEldrazi] forKey:kNanoKeyIsAnEldrazi];
    [ret setValue:[NSNumber numberWithInt:multiverseId] forKey:kNanoKeyMultiverseId];
    [ret setValue:[NSNumber numberWithInt:number] forKey:kNanoKeyNumber];
    [ret setValue:rulings forKey:kNanoKeyRulings];
    [ret setValue:layout forKey:kNanoKeyLayout];
    [ret setValue:colorsIdentity forKey:kNanoKeyColorsIdentity];
    [ret setValue:uuid forKey:kNanoKeyUUID];
    [ret setValue:scryfallId forKey:kNanoKeyScryfallId];
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
        self.rulings = [[NSMutableArray alloc] init];
        self.colorsIdentity = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setId:(int)newId{
    setId = newId;
}

- (int)getSetId{
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

- (BOOL)isAPlane{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"Plane"]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray *results = [types filteredArrayUsingPredicate:predicate];
    if (results.count > 0){
        return true;
    }
    return false;
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

- (void)convertColorsIdentity:(NSArray *)newColors{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *color in newColors){
        if ([color isEqualToString:@"W"]){
            [temp addObject:[NSNumber numberWithInteger:kColorWhite]];
        }
        if ([color isEqualToString:@"U"]){
            [temp addObject:[NSNumber numberWithInteger:kColorBlue]];
        }
        if ([color isEqualToString:@"B"]){
            [temp addObject:[NSNumber numberWithInteger:kColorBlack]];
        }
        if ([color isEqualToString:@"R"]){
            [temp addObject:[NSNumber numberWithInteger:kColorRed]];
        }
        if ([color isEqualToString:@"G"]){
            [temp addObject:[NSNumber numberWithInteger:kColorGreen]];
        }
    }
    self.colorsIdentity = [[NSArray alloc] initWithArray:temp];
}

- (NSComparisonResult)compare:(MTGCard *)otherCard {
    /*if (isALand && otherCard.isALand) return NSOrderedSame;
    if (!isALand && otherCard.isALand) return NSOrderedAscending;
    if (isALand) return NSOrderedDescending;
    
    if (isAnArtifact && otherCard.isAnArtifact) return NSOrderedSame;
    if (!isAnArtifact && otherCard.isAnArtifact) return NSOrderedAscending;
    if (isAnArtifact) return NSOrderedDescending;
    
    if (isMultiColor && otherCard.isMultiColor) return NSOrderedSame;
    if (!isMultiColor && otherCard.isMultiColor) return NSOrderedAscending;
    if (isMultiColor) return NSOrderedDescending;

    int color = -1;
    if (self.colors.count > 0){
        color = [(NSNumber *)[colors objectAtIndex:0] intValue];
    }
    int otherColor = -1;
    if (otherCard.colors.count > 0){
        otherColor = [(NSNumber *)[otherCard.colors objectAtIndex:0] intValue];
    }
    if (color == otherColor) return NSOrderedSame;
    if (color < otherColor) return NSOrderedAscending;
    return NSOrderedDescending;*/
    if ([self getSetId] > [otherCard getSetId]) return NSOrderedDescending;
    if ([self getSetId] < [otherCard getSetId]) return NSOrderedAscending;
    if ([self getNumber] == [otherCard getNumber]) return NSOrderedSame;
    if ([self getNumber] < [otherCard getNumber]) return NSOrderedAscending;
    return NSOrderedDescending;
}


- (void)setNumber:(int)nmb{
    self->number = nmb;
}

- (int) getNumber{
    return number;
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

- (BOOL)isWhite{
    return [colorsIdentity containsObject:[NSNumber numberWithInt:kColorWhite]];
}

- (BOOL)isRed{
    return [colorsIdentity containsObject:[NSNumber numberWithInt:kColorRed]];
}

- (BOOL)isGreen{
    return [colorsIdentity containsObject:[NSNumber numberWithInt:kColorGreen]];
}

- (BOOL)isBlue{
    return [colorsIdentity containsObject:[NSNumber numberWithInt:kColorBlue]];
}

- (BOOL)isBlack{
    return [colorsIdentity containsObject:[NSNumber numberWithInt:kColorBlack]];
}

- (BOOL)isCommon{
    return [rarity caseInsensitiveCompare:kRarityCommon] == NSOrderedSame;
}

- (BOOL)isUncommon{
    return [rarity caseInsensitiveCompare:kRarityUncommon] == NSOrderedSame;
}

- (BOOL)isRare{
    return [rarity caseInsensitiveCompare:kRarityRare] == NSOrderedSame;
}

- (BOOL)isMythic{
    return [rarity caseInsensitiveCompare:kRarityMythic] == NSOrderedSame ||
            [rarity caseInsensitiveCompare:kRarityMythicRare] == NSOrderedSame;
}

- (BOOL)isNormal{
    return [layout caseInsensitiveCompare:@"normal"] == NSOrderedSame;
}

- (NSString *)imageUrl{
    if (scryfallId != nil && [scryfallId length] > 0 && [self isNormal]){
        return [NSString stringWithFormat:@"https://api.scryfall.com/cards/%@?format=image", scryfallId];
    }
    return [NSString stringWithFormat:@"http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=%d&type=card", [self getMultiverseId]];
}
@end
