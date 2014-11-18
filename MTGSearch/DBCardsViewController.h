//
//  DBCardsViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAppDelegate.h"
#import "LocalDataProvider.h"

@interface DBCardsViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    NSInteger currentPosition;
    BOOL showImage;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSArray *savedCards;
@property (strong, nonatomic) LocalDataProvider *localDataProvider;
@property (strong, nonatomic) UIBarButtonItem *favBtn;
@property (strong, nonatomic) MTGCard *currentSavedCard;

- (void)setCurrentPosition:(NSInteger)pos;

@end
