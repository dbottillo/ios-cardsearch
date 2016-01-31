//
//  UIViewController+FilterCards.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 21/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#define kSortAlphabet   @"alphabethicOrder"

#import <UIKit/UIKit.h>

@interface UIViewController (FilterCards)

- (void)openFilter:(UIBarButtonItem *)barButtonItem;
- (NSMutableArray *)realFilterCards:(NSArray *)cards;

@end
