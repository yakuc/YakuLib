//
//  UIAlertView+YakuLib.m
//  YLib
//
//  Created by 薬師寺 信勝 on 2012/10/27.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "UIAlertView+YakuLib.h"

@implementation UIAlertView (YakuLib)

-(id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.title = [error localizedDescription];
        self.message = [[NSArray arrayWithObjects:[error localizedFailureReason], [error localizedRecoverySuggestion], nil] componentsJoinedByString:@"\n"];
        NSArray* optionTitles = [error localizedRecoveryOptions];
        if (optionTitles.count > 0) {
            for (NSString *title in optionTitles) {
                [self addButtonWithTitle:title];
            }
        } else {
            [self addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
        }
    }
    return self;
}

@end
