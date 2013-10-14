//
//  YMasterViewController.h
//  YakuLib
//
//  Created by 薬師寺 信勝 on 2013/10/14.
//  Copyright (c) 2013年 YAKUC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDetailViewController;

@interface YMasterViewController : UITableViewController

@property (strong, nonatomic) YDetailViewController *detailViewController;

@end
