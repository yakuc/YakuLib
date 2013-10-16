//
//  YMasterViewController.h
//  YakuLib
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDetailViewController;

@interface YMasterViewController : UITableViewController

@property (strong, nonatomic) YDetailViewController *detailViewController;

@end
