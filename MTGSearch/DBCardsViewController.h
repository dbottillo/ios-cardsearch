//
//  DBCardsViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface DBCardsViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>{
    int currentPosition;
    BOOL showImage;
}

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSString *nameSet;

- (void)setCurrentPosition:(int)pos;

@end
