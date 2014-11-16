//
//  DBCardCell.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 02/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAppDelegate.h"
#import "MTGCard.h"
#import "DBFilterViewController.h"

@interface DBCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewIndicator;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardCost;
@property (weak, nonatomic) IBOutlet UIView *lightBg;
@property (weak, nonatomic) IBOutlet UILabel *cardRarity;

- (void)updateWithCard:(MTGCard *)card;

@end
