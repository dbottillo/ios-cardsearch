//
//  DBFirstViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGSet.h"

@interface DBSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSInteger currentIndexSet;
    BOOL setLoaded;
    BOOL showImage;
}

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSMutableArray *filteredCards;
@property (strong, nonatomic) IBOutlet UITableView *cardsTable;
@property (weak, nonatomic) IBOutlet UILabel *setName;
@property (weak, nonatomic) IBOutlet UIView *setPicker;

@property (strong, nonatomic) MTGSet *set;
- (IBAction)pickSet:(id)sender;

@end
