//
//  DBPriceCardParser.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 01/12/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGCardPrice.h"

@interface DBPriceCardParser : NSObject  <NSXMLParserDelegate>{
    BOOL isHighprice;
    BOOL isAvgPrice;
    BOOL isLowprice;
    BOOL isLink;
}

@property (strong, nonatomic) MTGCardPrice *price;
@property (strong, nonatomic) NSXMLParser *parser;

- (id) initWithData:(NSData *)data;
- (MTGCardPrice *)parse;

@end
