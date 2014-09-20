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

@interface DBAppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL filterChanged;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *sets;

- (void)setFilterChanged:(BOOL)change;
- (BOOL)filterHasChanged;

@end
