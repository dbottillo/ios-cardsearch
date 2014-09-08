//
//  DBFirstViewController.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBSetViewController.h"
#import <sqlite3.h>
#import "CardsDatabase.h"

@interface DBSetViewController ()

@property (nonatomic) sqlite3 *contactDB;

@end

@implementation DBSetViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Cards";
    
    [self loadSets];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"title %d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"subtitle %d", indexPath.row];
    
    return cell;
}

- (void)loadSets{
    NSArray *sets = [CardsDatabase database].gameSets;
    NSLog(@"number of set loaded: %d", [sets count]);
}

@end
