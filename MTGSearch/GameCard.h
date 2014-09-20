//
//  GameCard.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCard : NSObject{
    int setId;
}

@property (nonatomic, strong) NSString *name;

- (void)setId:(int)newId;
- (int)getId;

@end
