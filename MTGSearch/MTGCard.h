//
//  MTGCard.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "NSFNanoObject.h"

#define kColorWhite     0
#define kColorBlue      1
#define kColorBlack     2
#define kColorRed       3
#define kColorGreen     4

#define kRarityCommon       @"Common"
#define kRarityUncommon     @"Uncommon"
#define kRarityRare         @"Rare"
#define kRarityMythic       @"Mythic"
#define kRarityMythicRare   @"Mythic Rare"

#define     kNanoKeySetId           @"setId"
#define     kNanoKeyCMC             @"cmc"
#define     kNanoKeyIsMultiColor    @"isMultiColor"
#define     kNanoKeyIsALand         @"isALand"
#define     kNanoKeyIsAnArtifact    @"isAnArtifact"
#define     kNanoKeyIsAnEldrazi     @"isAnEldrazi"
#define     kNanoKeyMultiverseId    @"multiverseId"
#define     kNanoKeyName            @"name"
#define     kNanoKeyType            @"type"
#define     kNanoKeyTypes           @"types"
#define     kNanoKeySubTypes        @"subTypes"
#define     kNanoKeyColors          @"colors"
#define     kNanoKeyRarity          @"rarity"
#define     kNanoKeyPower           @"power"
#define     kNanoKeyToughness       @"toughness"
#define     kNanoKeyManaCost        @"manaCost"
#define     kNanoKeyText            @"text"
#define     kNanoKeySetName         @"setName"
#define     kNanoKeySetCode         @"setCode"
#define     kNanoKeyNumber          @"number"
#define     kNanoKeyRulings         @"rulings"
#define     kNanoKeyLayout          @"layout"
#define     kNanoKeyColorsIdentity  @"colorsIdentity"
#define     kNanoKeyUUID            @"uuid"
#define     kNanoKeyScryfallId      @"scryfallId"

@interface MTGCard : NSFNanoObject{
    int setId;
    int cmc;
    BOOL isMultiColor;
    BOOL isALand;
    BOOL isAnArtifact;
    BOOL isAnEldrazi;
    int multiverseId;
    int number;
}

@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSArray *subTypes;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSString *rarity;
@property (strong, nonatomic) NSString *power;
@property (strong, nonatomic) NSString *toughness;
@property (strong, nonatomic) NSString *manaCost;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *setName;
@property (strong, nonatomic) NSString *setCode;
@property (strong, nonatomic) NSMutableArray *rulings;
@property (nonatomic, strong) NSString *layout;
@property (strong, nonatomic) NSArray *colorsIdentity;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *scryfallId;

- (id)initWithName:(NSString *)_name;

- (void)setId:(int)newId;
- (int)getSetId;
- (void)convertColors:(NSArray *)newColors;
- (void)convertColorsIdentity:(NSArray *)newColors;
- (void)setManaCostConverted:(int)manaCostConverted;
- (int) getCmc;
- (void)setNumber:(int)numer;
- (int) getNumber;
- (void)setMultiverseId:(int)idMultiverse;
- (int) getMultiverseId;
- (void)setAsMultiColor;
- (BOOL)isMultiColor;
- (void)setAsLand;
- (BOOL)isALand;
- (void)setAsArtifact;
- (BOOL)isAnArtifact;
- (void)setAsEldrazi;
- (BOOL)isAnEldrazi;
- (BOOL)isAPlane;
- (BOOL)isWhite;
- (BOOL)isRed;
- (BOOL)isGreen;
- (BOOL)isBlue;
- (BOOL)isBlack;
- (BOOL)isCommon;
- (BOOL)isUncommon;
- (BOOL)isRare;
- (BOOL)isMythic;
- (NSString *)imageUrl;
@end
