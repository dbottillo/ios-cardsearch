//
//  MTGSet.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 08/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

@interface MTGSet : NSObject {
    int setId;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

- (void)setId:(int)newId;
- (int)getId;


@end
