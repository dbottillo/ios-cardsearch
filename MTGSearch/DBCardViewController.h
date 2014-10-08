//
//  DBCardViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAppDelegate.h"
#import "GameCard.h"

@interface DBCardViewController : UIViewController {
    BOOL showImage;
}

@property NSUInteger pageIndex;
@property NSUInteger totalItems;

@property (strong, nonatomic) GameCard *card;

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labelIndicator;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *ptTitle;
@property (weak, nonatomic) IBOutlet UILabel *manacostTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImage;

@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardText;
@property (weak, nonatomic) IBOutlet UILabel *cardCost;
@property (weak, nonatomic) IBOutlet UILabel *cardPowerToughness;
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;

- (void) updatePriceWith:(NSString *) string;
- (void)setShowImage:(BOOL)_show;

@end
