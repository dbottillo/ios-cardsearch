//
//  CardFilter.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardFilter : NSObject{
    BOOL active;
}

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *filterKey;
@property (strong, nonatomic) NSString *gaLabel;

- (id)initWithName:(NSString *)name andKey:(NSString *)key andState:(BOOL)state andGALabel:(NSString *)gaLabel;

- (void)setActive;
- (void)setInactive;
- (BOOL) isActive;

@end
