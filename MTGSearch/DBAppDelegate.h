//
//  DBAppDelegate.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#define kSetId  @"setId"
#define app_delegate ((DBAppDelegate *)[[UIApplication sharedApplication] delegate])

#define kUACategoryUI           @"ui"
#define kUACategorySearch       @"search"
#define kUACategoryFavourite    @"favourite"
#define kUAActionClick          @"click"
#define kUAActionToggle         @"toggle"
#define kUAActionOpen           @"open"
#define kUAActionSaved          @"saved"
#define kUAActionUnsaved        @"unsaved"
#define kUAActionLifeCounter    @"lifeCounter"

@interface DBAppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL filterChanged;
    BOOL filterChangedSearch;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<GAITracker> tracker;

@property (strong, nonatomic) NSArray *sets;

- (void)setFilterChanged:(BOOL)change;
- (BOOL)filterHasChanged;

- (void)setFilterChangedSearch:(BOOL)change;
- (BOOL)filterHasChangedForSearch;

- (void)trackPage:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label;

+ (UIColor *)blueColor;
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

+ (BOOL) isMagic;

@end
