//
//  UIViewController+NavBar.m
//  MTGSearch
//
//  Created by Daniele Bottillo on 01/10/2014.
//  Copyright (c) 2014 Daniele Bottillo. All rights reserved.
//

#import "UIViewController+NavBar.h"

@implementation UIViewController (NavBar)

- (void)styleNavBar{
    self.navigationController.navigationBar.barTintColor = [DBAppDelegate blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
