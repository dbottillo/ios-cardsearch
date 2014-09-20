//
//  DBSearchViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 21/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSMutableArray *filteredCards;

@end
