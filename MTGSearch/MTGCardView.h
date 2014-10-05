//
//  MTGCardView.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGCard.h"
#import "DBAppDelegate.h"

@interface MTGCardView : UIView

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

- (void)setup;
- (void) updateWithCard:(MTGCard *)card;
- (void) updatePriceWith:(NSString *) string;
- (void) updateLabelIndicator:(NSInteger) current AndTotal:(NSInteger)total;
@end
