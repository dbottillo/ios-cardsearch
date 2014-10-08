//
//  DBCardsViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAppDelegate.h"

@interface DBCardsViewController : UIViewController <UIPageViewControllerDataSource> {
    NSInteger currentPosition;
    BOOL showImage;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSString *nameSet;

- (void)setCurrentPosition:(NSInteger)pos;

@end
