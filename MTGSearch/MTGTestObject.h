//
//  MTGTestObject.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 18/11/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFNanoObject.h"

#define     kNanoKeyName    @"name"
#define     kNanoKeyType    @"type"

@interface MTGTestObject : NSFNanoObject;

@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSString *type;

@end
