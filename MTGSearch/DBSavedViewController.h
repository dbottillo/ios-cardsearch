//
//  DBSavedViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalDataProvider.h"

@interface DBSavedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *savedCards;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UITableView *savedTable;
@property (strong, nonatomic) LocalDataProvider *localDataProvider;

@end
