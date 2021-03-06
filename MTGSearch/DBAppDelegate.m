//
//  DBAppDelegate.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBAppDelegate.h"
#import "DBFilterViewController.h"
#import "DBSettingsViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import Firebase;

@implementation DBAppDelegate

@synthesize sets, cardsInfoMapper;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDefaultsDictionary = [userDefaults dictionaryRepresentation];
    //NSLog(@"userDefaultsDictionary %@", userDefaultsDictionary);
    if (![userDefaultsDictionary.allKeys containsObject:kFilterWhite]){
        [userDefaults setBool:YES forKey:kFilterWhite];
        [userDefaults setBool:YES forKey:kFilterBlue];
        [userDefaults setBool:YES forKey:kFilterBlack];
        [userDefaults setBool:YES forKey:kFilterRed];
        [userDefaults setBool:YES forKey:kFilterGreen];
        [userDefaults setBool:YES forKey:kFilterArtifact];
        [userDefaults setBool:YES forKey:kFilterLand];
        [userDefaults setBool:YES forKey:kFilterCommon];
        [userDefaults setBool:YES forKey:kFilterUncommon];
        [userDefaults setBool:YES forKey:kFilterRare];
        [userDefaults setBool:YES forKey:kFilterMyhtic];
        [userDefaults setBool:YES forKey:kUserImage];
        [userDefaults synchronize];
    }
        
    cardsInfoMapper = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"tr", @"tor",
                       @"dm", @"dkm",
                       @"ex", @"exo",
                       @"ug", @"ugl",
                       @"us", @"usg",
                       @"at", @"ath",
                       @"ul", @"ulg",
                       @"6e", @"6ed",
                       @"p3k", @"ptk",
                       @"ud", @"uds",
                       @"st", @"s99",
                       @"mm", @"mmq",
                       @"ne", @"nms",
                       @"pr", @"pcy",
                       @"in", @"inv",
                       @"ps", @"pls",
                       @"7e", @"7ed",
                       @"ap", @"apc",
                       @"od", @"ody",
                       @"ju", @"jud",
                       @"on", @"ons",
                       @"le", @"lgn",
                       @"sc", @"scg",
                       @"8e", @"8ed",
                       @"mi", @"mrd",
                       @"ds", @"dst",
                       @"uh", @"unh",
                       @"9e", @"9ed",
                       @"gp", @"gpt",
                       @"di", @"dis",
                       @"cs", @"csp",
                       @"ts", @"tsp",
                       @"tsts", @"tsb",
                       @"pc", @"plc",
                       @"lw", @"lrw",
                       @"mt", @"mor",
                       @"fvd", @"drb",
                       @"ddajvc", @"dd2",
                       @"cfx", @"con",
                       @"ddadvd", @"ddc",
                       @"fve", @"v09",
                       @"pch", @"hop",
                       @"gvl", @"ddd",
                       @"pds", @"h09",
                       @"pvc", @"dde",
                       @"fvr", @"v10",
                       @"fvl", @"v11",
                       @"cma", @"cm1",
                       @"mpskld", @"mps",
                       @"mpsakh", @"mps_akh",
                       nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setFilterChanged:(BOOL)change{
    filterChanged = change;
}

- (BOOL) filterHasChanged{
    return filterChanged;
}

- (void)setFilterChangedSearch:(BOOL)change{
    filterChangedSearch = change;
}

- (BOOL)filterHasChangedForSearch{
    return filterChangedSearch;
}

- (void)trackPage:(NSString *)page{
    [Answers logContentViewWithName:page
                        contentType:nil
                          contentId:nil
                   customAttributes:nil];
}

- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label{
    [Answers logCustomEventWithName:category
                   customAttributes:@{
                                      @"action" : action,
                                      label : label}];
}

+ (UIColor *)mainColor{
    return [DBAppDelegate colorWithHexString:@"39627E"];
}

+ (UIColor *)greyWhite{
    return [DBAppDelegate colorWithHexString:@"FDF1A2"];
}

+ (UIColor *)greyBlue{
    return [DBAppDelegate colorWithHexString:@"7FC3F8"];
}

+ (UIColor *)greyBlack{
    return [DBAppDelegate colorWithHexString:@"AAA8A8"];
}

+ (UIColor *)greyRed{
    return [DBAppDelegate colorWithHexString:@"FCBCA0"];
}

+ (UIColor *)greyGreen{
    return [DBAppDelegate colorWithHexString:@"B1FCA3"];
}

+ (UIColor *)greyMulticolor{
    return [DBAppDelegate colorWithHexString:@"a571b0"];
}

+ (UIColor *)greyArtifact{
    return [DBAppDelegate colorWithHexString:@"b5b5b5"];
}

+ (UIColor *)common{
    return [DBAppDelegate colorWithHexString:@"666666"];
}

+ (UIColor *)unCommon{
    return [DBAppDelegate colorWithHexString:@"a8a8a8"];
}

+ (UIColor *)rare{
    return [DBAppDelegate colorWithHexString:@"BD9723"];
}

+ (UIColor *)Mythic{
    return [DBAppDelegate colorWithHexString:@"D46805"];
}

+ (UIColor *)epic{
    return [DBAppDelegate colorWithHexString:@"c544ce"];
}

+ (UIColor *)legendary{
    return [DBAppDelegate colorWithHexString:@"f8a036"];
}

+ (UIColor *)grey{
    return [DBAppDelegate colorWithHexString:@"F2F2F2"];
}


+ (UIColor*)colorWithHexString:(NSString*)hex{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
