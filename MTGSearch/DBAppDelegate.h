//
//  DBAppDelegate.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSetId  @"setId"
#define app_delegate ((DBAppDelegate *)[[UIApplication sharedApplication] delegate])


#ifdef DEBUG
    #define kDebug          YES
#else
    #define kDebug          NO
#endif

#define kUACategoryUI           @"ui"
#define kUACategoryPopup        @"popup"
#define kUACategorySet          @"set"
#define kUACategoryCard         @"card"
#define kUACategorySearch       @"search"
#define kUACategoryFilter       @"filter"
#define kUACategoryFavourite    @"favourite"
#define kUACategoryLifeCounter  @"lifeCounter"
#define kUACategoryError        @"error"

#define kUAActionClick          @"click"
#define kUAActionToggle         @"toggle"
#define kUAActionShare          @"share"
#define kUAActionSelect         @"select"
#define kUAActionOpen           @"open"
#define kUAActionClose          @"close"
#define kUAActionSaved          @"saved"
#define kUAActionUnsaved        @"unsaved"
#define kUAActionLucky          @"lucky"

@interface DBAppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL filterChanged;
    BOOL filterChangedSearch;
    NSDictionary *cardsInfoMapper;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *cardsInfoMapper;

@property (strong, nonatomic) NSArray *sets;

- (void)setFilterChanged:(BOOL)change;
- (BOOL)filterHasChanged;

- (void)setFilterChangedSearch:(BOOL)change;
- (BOOL)filterHasChangedForSearch;

- (void)trackPage:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label;

+ (UIColor *)mainColor;
+ (UIColor *)greyWhite;
+ (UIColor *)greyBlue;
+ (UIColor *)greyBlack;
+ (UIColor *)greyRed;
+ (UIColor *)greyGreen;
+ (UIColor *)greyMulticolor;
+ (UIColor *)greyArtifact;
+ (UIColor *)common;
+ (UIColor *)unCommon;
+ (UIColor *)rare;
+ (UIColor *)epic;
+ (UIColor *)legendary;
+ (UIColor *)Mythic;
+ (UIColor *)grey;
+ (UIColor*)colorWithHexString:(NSString*)hex;

@end
