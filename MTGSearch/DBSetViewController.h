//
//  DBFirstViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGSet.h"

@interface DBSetViewController : UITableViewController {
    NSInteger currentIndexSet;
    BOOL setLoaded;
}

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSMutableArray *filteredCards;

@property (strong, nonatomic) GameSet *set;

@end
