//
//  DBCardViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAppDelegate.h"
#import "MTGCard.h"
#import "MTGCardPrice.h"
#import "LocalDataProvider.h"

@interface DBCardViewController : UIViewController {
    BOOL showImage;
    BOOL isLucky;
    BOOL needToLoadCard;
    BOOL isLoading;
}

@property NSUInteger pageIndex;
@property NSUInteger totalItems;

@property (strong, nonatomic) MTGCard *card;
@property (strong, nonatomic) MTGCardPrice *priceCard;

@property (weak, nonatomic) IBOutlet UIView *cardDetailContainer;
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labelIndicator;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *ptTitle;
@property (weak, nonatomic) IBOutlet UILabel *manacostTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImage;

@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardText;
@property (weak, nonatomic) IBOutlet UILabel *cardCost;
@property (weak, nonatomic) IBOutlet UILabel *cardPowerToughness;
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;
@property (weak, nonatomic) IBOutlet UIView *priceContainer;
@property (weak, nonatomic) IBOutlet UILabel *viewOnTCG;

@property (strong, nonatomic) UIBarButtonItem *favBtn;
@property (strong, nonatomic) MTGCard *currentSavedCard;

// lucky mode
@property (strong, nonatomic) NSArray *savedCards;
@property (strong, nonatomic) LocalDataProvider *localDataProvider;
@property (strong, nonatomic) NSMutableArray *randomCards;

- (void) updatePriceWith:(NSString *) string;
- (void)setShowImage:(BOOL)_show;

- (void) setLuckyModeOff;
- (void) setLuckyModeOn;

@end
