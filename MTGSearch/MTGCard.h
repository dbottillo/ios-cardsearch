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
#define kRarityMythic       @"Mythic Rare"

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

@interface MTGCard : NSFNanoObject{
    int setId;
    int cmc;
    BOOL isMultiColor;
    BOOL isALand;
    BOOL isAnArtifact;
    BOOL isAnEldrazi;
    int multiverseId;
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

- (id)initWithName:(NSString *)_name;

- (void)setId:(int)newId;
- (int)getId;
- (void)convertColors:(NSArray *)newColors;
- (void)setManaCostConverted:(int)manaCostConverted;
- (int) getCmc;
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

@end
