//
//  YDetailViewController.h
//  YakuLib
//
//  Created by 薬師寺 信勝 on 2013/10/14.
//  Copyright (c) 2013年 YAKUC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
