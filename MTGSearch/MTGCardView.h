//
//  MTGCardView.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 19/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGCard.h"
#import <GADBannerView.h>
#import "DBAppDelegate.h"

@interface MTGCardView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardText;
@property (weak, nonatomic) IBOutlet UILabel *cardCost;
@property (weak, nonatomic) IBOutlet UILabel *cardPowerToughness;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

- (void) updateWithCard:(MTGCard *)card andRootViewController:(UIViewController *)rootViewController;

@end
