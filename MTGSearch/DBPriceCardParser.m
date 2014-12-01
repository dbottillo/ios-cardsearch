//
//  DBPriceCardParser.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 01/12/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "DBPriceCardParser.h"

@implementation DBPriceCardParser

@synthesize price, parser;

- (id) initWithData:(NSData *)data{
    self = [super init];
    if (self != nil){
        price = [[MTGCardPrice alloc] init];
         parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        isAvgPrice = NO;
        isHighprice = NO;
        isLink = NO;
        isLowprice = NO;
    }
    return self;
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    //NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"didStartElement --> %@", elementName);
    isHighprice = isLowprice = isAvgPrice = isLink = NO;
    if ([elementName isEqualToString:@"hiprice"]) isHighprice = YES;
    if ([elementName isEqualToString:@"lowprice"]) isLowprice = YES;
    if ([elementName isEqualToString:@"avgprice"]) isAvgPrice = YES;
    if ([elementName isEqualToString:@"link"]) isLink = YES;
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"foundCharacters --> %@", string);
    if (isHighprice)  [price setHiPrice:string];
    if (isLowprice) [price setLowprice:string];
    if (isAvgPrice) [price setAvgprice:string];
    if (isLink) [price setLink:string];
    isHighprice = isLowprice = isAvgPrice = isLink = NO;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"didEndElement   --> %@", elementName);
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    //NSLog(@"parserDidEndDocument");
}

- (MTGCardPrice *)parse{
    [parser parse];
    parser = nil;
    return price;
}

@end
