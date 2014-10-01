//
//  DBFilterViewController.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 09/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFilterWhite    @"FilterWhite"
#define kFilterBlue     @"FilterBlue"
#define kFilterBlack    @"FilterBlack"
#define kFilterRed      @"FilterRed"
#define kFilterGreen    @"FilterGreen"

#define kFilterArtifact @"FilterArtifact"
#define kFilterLand     @"FilterLand"

#define kFilterCommon   @"FilterCommon"
#define kFilterUncommon @"FilterUncommon"
#define kFilterRare     @"FilterRare"
#define kFilterMyhtic   @"FilterMyhtic"

@interface DBFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (strong, nonatomic) NSArray *filters;

@end
