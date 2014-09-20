//
//  DBFullCardCell.h
//  MTGSearch
//
//  Created by Daniele Bottillo on 10/09/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBFullCardCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;

@end
